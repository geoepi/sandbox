calc_county_metrics <- function(counties_proj, buffer_m = 50000, res_m = 5000) {
  
  r_crs_sf <- st_crs(counties_proj) # counties
  results <- list()
  
  for (i in seq_len(nrow(counties_proj))) {
    county <- counties_proj[i, ]
    geom <- st_geometry(county)[[1]]
    geom <- st_make_valid(geom)
    
    # expand bbox by buffer_m
    bbox <- st_bbox(county)
    bbox_expanded <- bbox
    bbox_expanded$xmin <- bbox$xmin - buffer_m
    bbox_expanded$ymin <- bbox$ymin - buffer_m
    bbox_expanded$xmax <- bbox$xmax + buffer_m
    bbox_expanded$ymax <- bbox$ymax + buffer_m
    
    # raster template
    ext <- terra::ext(bbox_expanded$xmin, bbox_expanded$xmax,
                      bbox_expanded$ymin, bbox_expanded$ymax)
    r_template <- rast(ext, resolution = res_m, crs = st_crs(county)$wkt)
    
    # offset for seed sim points
    offset <- res_m * 2
    bb <- terra::ext(r_template)
    xmin <- bb[1]; xmax <- bb[2]
    ymin <- bb[3]; ymax <- bb[4]
    xmin_in <- xmin + offset; xmax_in <- xmax - offset
    ymin_in <- ymin + offset; ymax_in <- ymax - offset
    
    # seed points
    x_north <- xmin_in + c(1/3, 2/3) * (xmax_in - xmin_in)
    north_pts <- data.frame(x = x_north, y = ymax_in)
    x_south <- xmin_in + c(1/3, 2/3) * (xmax_in - xmin_in)
    south_pts <- data.frame(x = x_south, y = ymin_in)
    y_east <- ymin_in + c(1/3, 2/3) * (ymax_in - ymin_in)
    east_pts <- data.frame(x = xmax_in, y = y_east)
    y_west <- ymin_in + c(1/3, 2/3) * (ymax_in - ymin_in)
    west_pts <- data.frame(x = xmin_in, y = y_west)
    sim_origin_pnts <- rbind(north_pts, south_pts, east_pts, west_pts)
    sim_origin_pnts <- st_as_sf(sim_origin_pnts, coords = c("x", "y"), crs = r_crs_sf)
    
    # rasterize county
    county_rast <- rasterize(vect(county), r_template, field = 1, background = 0)
    
    # patch metrics
    area_vec_m2 <- as.numeric(st_area(geom))
    area_vec_km2 <- area_vec_m2 / 1e6
    perim_m <- as.numeric(st_length(st_boundary(geom)))
    perim_km <- perim_m / 1000
    compactness_pp <- 4 * pi * area_vec_m2 / (perim_m^2)
    convex_hull_ratio <- area_vec_m2 / as.numeric(st_area(st_convex_hull(geom)))
    bb_geom <- st_bbox(geom)
    bbox_w <- bb_geom$xmax - bb_geom$xmin
    bbox_h <- bb_geom$ymax - bb_geom$ymin
    bbox_elongation <- pmax(bbox_w, bbox_h) / pmin(bbox_w, bbox_h)
    
    centroid <- st_centroid(geom)
    centroid_xy <- st_coordinates(centroid)[1, ]
    ex <- terra::ext(county_rast)
    rel_centroid_x <- (centroid_xy[1] - ex[1]) / (ex[2] - ex[1])
    rel_centroid_y <- (centroid_xy[2] - ex[3]) / (ex[4] - ex[3])
    
    # grid metrics
    r_rast <- raster::raster(county_rast)
    vals <- raster::getValues(r_rast)
    vals_pres <- ifelse(!is.na(vals) & vals == 1, 1L, NA_integer_)
    raster::values(r_rast) <- vals_pres
    res_m_eff <- raster::res(r_rast)[1]
    cell_area_m2 <- res_m_eff * res_m_eff
    raster_cell_count <- sum(!is.na(raster::getValues(r_rast)))
    area_raster_km2 <- (raster_cell_count * cell_area_m2) / 1e6
    matrix_cell_count <- sum(is.na(raster::getValues(r_rast)))
    patch_matrix_ratio <- raster_cell_count / matrix_cell_count
    
    # distances from centroid to seeds/boundary
    centroid_sfc <- st_sfc(centroid, crs = r_crs_sf)
    centroid_sf <- st_sf(geometry = centroid_sfc)
    dist_to_centroid_km <- as.numeric(st_distance(sim_origin_pnts, centroid_sf)) / 1000
    min_dist_to_centroid_km <- min(dist_to_centroid_km)
    
    boundary_geom <- st_boundary(geom)
    boundary_sfc <- st_sfc(boundary_geom, crs = r_crs_sf)
    boundary_sf <- st_sf(geometry = boundary_sfc)
    dist_to_boundary_km <- as.numeric(st_distance(sim_origin_pnts, boundary_sf)) / 1000
    min_dist_to_boundary_km <- min(dist_to_boundary_km)
    
    # background matrix
    buf <- st_buffer(geom, dist = buffer_m)
    buf_area_m2 <- as.numeric(st_area(buf))
    background_area_km2 <- (buf_area_m2 - area_vec_m2) / 1e6
    background_prop <- if (!is.na(buf_area_m2) && buf_area_m2 > 0) 
      (buf_area_m2 - area_vec_m2) / buf_area_m2 else NA_real_
    
    # organize
    results[[i]] <- tibble(
      county_id = i,
      county_name = county$NAME,
      state_name = county$STATE_NAME,
      area_vec_km2 = area_vec_km2,
      area_vec_m2 = area_vec_m2,
      perimeter_km = perim_km,
      compactness_pp = compactness_pp,
      convex_hull_ratio = convex_hull_ratio,
      bbox_elongation = bbox_elongation,
      centroid_x = centroid_xy[1],
      centroid_y = centroid_xy[2],
      centroid_rel_x = rel_centroid_x,
      centroid_rel_y = rel_centroid_y,
      raster_cell_count = raster_cell_count,
      area_raster_km2 = area_raster_km2,
      patch_matrix_ratio = patch_matrix_ratio,
      min_dist_to_centroid_km = min_dist_to_centroid_km,
      min_dist_to_boundary_km = min_dist_to_boundary_km,
      background_area_km2 = background_area_km2,
      background_prop = background_prop
    )
  }
  
  bind_rows(results)
}
