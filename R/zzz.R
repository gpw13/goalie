.onLoad <- function(pkgname, libname) {
  sdg_GET <<- memoise::memoise(sdg_GET)
  sdg_POST <<- memoise::memoise(sdg_POST)
}
