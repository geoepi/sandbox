#' Download and Unzip a GZ File to a Specified Directory
#'
#' This function downloads a compressed (.gz) file from a given URL 
#' and unzips it into a specified destination directory. If the destination
#' directory does not exist, it will be created. Additionally, after unzipping,
#' the original .gz file is deleted.
#'
#' @param url A string URL pointing to the .gz file that needs to be downloaded.
#' @param dest_dir A string specifying the path to the directory where
#'        the file should be unzipped.
#' @return Invisible NULL. The side effect of this function is the 
#'         download and extraction of the .gz file contents to the 
#'         destination directory.
#' @export
#'
#' @importFrom R.utils gunzip
download_and_unzip <- function(url, dest_dir) {
  # destination directory, if it doesn't exist
  if (!dir.exists(dest_dir)) {
    dir.create(dest_dir, recursive = TRUE)
  }
  
  # construct local paths
  file_name <- basename(url)
  gz_file_path <- file.path(dest_dir, file_name)
  txt_file_path <- sub("\\.gz$", "", gz_file_path) # Remove .gz extension
  
  # Download 
  download.file(url, gz_file_path, mode = "wb")
  
  # Check if the download was successful
  if (!file.exists(gz_file_path)) {
    stop("Download failed: File does not exist at path ", gz_file_path)
  }
  
  # Unzip
  unzip_status <- try({
    R.utils::gunzip(gz_file_path, txt_file_path, remove = FALSE)
  }, silent = TRUE)
  
  if(class(unzip_status) == "try-error") {
    stop("Unzipping failed: ", unzip_status)
  }
  
  # Delete the original 
  file.remove(gz_file_path)
  
  cat("File downloaded, unzipped, and original zip deleted successfully: ", txt_file_path, "\n")
}