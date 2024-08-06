source_dir <- function(directory_path) {
  
  if (!dir.exists(directory_path)) {
    stop("The specified directory does not exist.")
  }
  
  file_list <- list.files(path = directory_path, pattern = "\\.R$", full.names = TRUE)
  
  for (file in file_list) {
    source(file)
  }
}


convert_doy_to_date <- function(year, day_of_year) {
  as.Date(paste(year, day_of_year, sep="-"), format="%Y-%j")
}
