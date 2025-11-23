# Script to create country of origin map for symposium attendees
# https://crdfglobal.org/programs/fmds/

# Libraries
library(dplyr)
library(stringr)
library(sf)
library(ggspatial)
library(ggplot2)

# csv with countries (from registrations)
att <- read.csv("attendee_countries.csv", stringsAsFactors = FALSE)

# clean names
att_clean <- att %>%
  mutate(country_std = str_to_title(str_trim(country))) %>%
  distinct(country_std) %>%
  mutate(attended = "Yes")

# map bounds
world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
world <- world %>% mutate(country_std = str_to_title(admin))


world_flagged <- world %>%
  left_join(att_clean, by = "country_std") %>%
  mutate(attended = ifelse(is.na(attended), "No", attended))

# check for mismatched
setdiff(att_clean$country_std, world$country_std)

# fix a few
att_clean <- att_clean %>%
  mutate(
    country_std = case_when(
      country_std == "Hong Kong" ~ "Hong Kong S.a.r.",
      country_std == "The Netherlands" ~ "Netherlands",
      country_std == "United Arab Emirtaes" ~ "United Arab Emirates",
      country_std == "United States" ~ "United States Of America",
      TRUE ~ country_std
    )
  )


# match to polygons
world_flagged <- world %>%
  left_join(att_clean, by = "country_std") %>%
  mutate(attended = ifelse(is.na(attended), "No", attended))

# recheck
setdiff(att_clean$country_std, world$country_std)

# quick check
ggplot(world_flagged) +
  geom_sf(aes(fill = attended), color = "gray40", size = 0.1) +
  scale_fill_manual(values = c("Yes" = "#1B7837", "No" = "white")) +
  coord_sf() +
  theme_minimal()


# fancyfication
# curev it some curvature
world_flagged <- st_transform(world_flagged, "ESRI:54030")

# centers to label countries
centroids <- st_centroid(world_flagged)

# only countries that attended
lab <- centroids %>%
  filter(attended == "Yes") 

# shorten HK
lab$country_std[lab$country_std == "Hong Kong S.a.r."] <- "Hong Kong"

# Drop this, too much mapspace
world_flagged <- world_flagged %>%
  dplyr::filter(country_std != "Antarctica")

# Symposium location
conf_pt <- st_as_sf(
  data.frame(
    name = "Conference",
    lon  = -96.5717,
    lat  = 39.1836
  ),
  coords = c("lon", "lat"),
  crs = 4326
)

# match map projection
conf_pt <- st_transform(conf_pt, st_crs(world_robin))

set.seed(1223) # there's random jitter in label positions

# base map
p <- ggplot(world_flagged) +
  geom_sf(aes(fill = attended), color = "gray60", size = 0.1) +
  scale_fill_manual(values = c("Yes" = "skyblue2", "No" = "gray95")) +
  coord_sf(
    label_graticule = "all",
    label_axes = "----",
    expand = FALSE
  ) +
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.major = element_line(color = "gray80", linewidth = 0.2),
    panel.grid.minor = element_line(color = "gray90", linewidth = 0.1),
    legend.position = "none",
    legend.title = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )

# labels
p +
  ggrepel::geom_text_repel(
    data = lab,
    aes(label = country_std, geometry = geometry),
    stat = "sf_coordinates",
    size = 2.8,
    fontface = "bold",
    max.overlaps = Inf,
    box.padding = 0.3,
    point.padding = 0.1,
    segment.color = NA,
    force = 1.0,
    min.segment.length = Inf,
    color = "gray20"
  ) +
  geom_sf( # manhattan point
    data = conf_pt,
    color = "gray10",
    size = 2.5,
    shape = 21,
    fill = "darkred",
    stroke = 0.6
  ) +
  geom_text(
    data = conf_pt,
    aes(x = st_coordinates(conf_pt)[1,1],
        y = st_coordinates(conf_pt)[1,2],
        label = "Manhattan, Kansas"),
    nudge_y = -300000,   # label below
    size = 2.5,
    color = "gray20"
  )


