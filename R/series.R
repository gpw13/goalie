sdg_series <- function(all_releases = TRUE) {
  if (all_releases) {
    query <- "allreleases=true"
  } else {
    query <- "allreleases=false"
  }
  resp <- dplyr::as_tibble(sdg_GET("Series/List", query))
  dplyr::select(resp, release:description)
}

assert_series <- function(series) {
  valid_series <- series %in% sdg_series()[["code"]]
  if (!all(valid_series)) {
    stop(sprintf("%s are not valid series in the SDG database. Use sdg_series() to get a data frame of all valid series.",
                 paste(series[!valid_series], collapse = ", ")),
         call. = FALSE)
  }
}
