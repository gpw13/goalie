.onLoad <- function(pkgname, libname) {
  httr::set_config(httr::config(ssl_verifypeer = FALSE))
  options(RCurlOptions = list(ssl_verifypeer = FALSE))
  options(rsconnect.check.certificate = FALSE)
  sdg_GET <<- memoise::memoise(sdg_GET)
  sdg_POST <<- memoise::memoise(sdg_POST)
}
