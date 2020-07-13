#' @title Load all available series from the UNSD SDG database
#'
#' @description \code{sdg_series()} provides a data frame of all available \href{https://unstats.un.org/sdgs/indicators/database/}{series in the UNSD SDG database}.
#'
#' @param all_releases If FALSE, the default, returns only the current release, and returns all releases if TRUE.
#'
#' @return A data frame.
#'
#' @export
sdg_series <- function(all_releases = FALSE) {
  if (!is.logical(all_releases)) {
    stop(sprintf("all_releases needs to be a single logical value, not %s.",
                 all_releases),
         call. = F)
  } else if (all_releases) {
    query <- "allreleases=true"
  } else {
    query <- "allreleases=false"
  }
  resp <- sdg_GET("Series/List", query)
  dplyr::select(resp, release:description)
}

#' @noRd
assert_series <- function(series, len = length(series)) {
  valid_series <- series %in% sdg_series()[["code"]]
  if (!all(valid_series)) {
    stop(sprintf("%s are not valid series in the SDG database. Use sdg_series() to get a data frame of all valid series.",
                 paste(series[!valid_series], collapse = ", ")),
         call. = FALSE)
  } else if (len != length(series)) {
    stop(sprintf("series must be of length %s, not %s", len, length(series)), call. = FALSE)
  }
}
