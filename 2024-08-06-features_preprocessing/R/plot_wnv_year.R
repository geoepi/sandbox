#' Plot Yearly West Nile Virus Data on a Spatial Grid
plot_wnv_year <- function(grid, plot_data, column, plot_year, col_palette = "chelix") {
  
  tmp_year <- plot_data %>%
    filter(year == plot_year)
  
  grid[[column]] <- with(tmp_year,
                         get(column)[match(
                           grid$Grid_ID,
                           Grid_ID)])
  
  sp_grid <- as(grid, "Spatial")
  sp_state_borders <- fortify(as(state_borders, "Spatial"))
  sp_grid@data$id <- 1:nrow(sp_grid@data)
  grid_fort <- fortify(sp_grid, region = "id")
  grid_fort$id <- as.integer(grid_fort$id)
  grid_fort <- left_join(grid_fort, sp_grid@data, by = "id")
  
  min_val <- min(grid_fort[[column]], na.rm = TRUE)
  max_val <- ceiling(max(grid_fort[[column]], na.rm = TRUE))
  
  if(col_palette == "chelix"){
    color_palette <- rev(pals::cubehelix(50))
    col_values <- c(0, 0.05, 0.1, 0.25, 1)
  }else{
    color_palette <- rev(pals::ocean.thermal(50))
    col_values <- c(0, 0.05, 0.1, 0.25, 1)
  }
  
  column_sym <- rlang::sym(column)  # Convert string to symbol
  
  ret_plot <- ggplot() +
    geom_raster(data = grid_fort,
                aes(x = long, y = lat, group = group, fill = !!column_sym)) + 
    geom_polygon(data = sp_state_borders,
                 aes(long, lat, group = group), fill = "transparent", col="gray70") +
    scale_fill_gradientn(colours = color_palette, limits = c(min_val, max_val), values = col_values, na.value = "transparent") +
    coord_equal() +
    xlab("Easting") +
    ylab("Northing") +
    ggtitle(plot_year) + 
    theme_minimal() + 
    theme(plot.margin = unit(c(1, 0.5, 1, 0.5), "cm"),
          legend.direction = "horizontal",
          legend.position = "bottom", 
          strip.text = element_text(size = 26, face = "bold"),
          strip.background = element_blank(),
          legend.key.size = unit(1, "line"),
          legend.key.width = unit(4, "line"),
          legend.text = element_text(size = 16, face = "bold"),
          legend.title = element_text(size = 18, face = "bold"),
          axis.title.x = element_text(size = 24, face = "bold"),
          axis.title.y = element_text(size = 24, face = "bold"),
          axis.text.x = element_text(face = "bold", size = 12, vjust = 1, 
                                     hjust = 1, angle = 45),
          axis.text.y = element_text(size = 12, face = "bold"),
          plot.title = element_text(size = 28, face = "bold", hjust = 0.5))
  
  return(ret_plot)
}