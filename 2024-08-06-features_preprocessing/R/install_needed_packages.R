#' Install needed packages from CRAN
install_needed_packages <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      message(paste("Installing package:", pkg))
      install.packages(pkg)
    } else {
      message(paste("Package", pkg, "is already installed."))
    }
  }
}
