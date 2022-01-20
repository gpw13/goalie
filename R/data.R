#' Load data from UNSD SDG database
#'
#' \code{sdg_data()} provides a data frame of all data for specified series
#'   in the UNSD SDG database.
#'
#' @param series Character vector of
#'   \href{https://unstats.un.org/sdgs/indicators/database/}{SDG series codes}.
#' @param area_codes \href{https://unstats.un.org/unsd/methodology/m49/}{M49 codes}
#'   for specific geoAreas.
#' @param time_start Numeric value indicating the starting (inclusive) year of
#'   the series.
#' @param time_end Numeric value indicating the ending (inclusive) year of
#'   the series.
#' @param clean_names Logical value indicating whether or not to clean up names
#'   of the returned data frame. If `TRUE`, the default, spaces are replaced
#'   with underscores and all other non-alphabetic characters are removed.
#'
#'
#' @return A data frame.
#'
#' @export
sdg_data <- function(series, area_codes = NULL, time_start = NULL, time_end = NULL, clean_names = TRUE) {
  assert_series(series)
  names(series) <- rep("seriesCodes", length(series))

  if (!is.null(area_codes)) {
    assert_geoarea(area_codes)
    names(area_codes) <- rep("areaCodes", length(area_codes))
  }

  if (!is.null(time_start)) {
    assert_time(time_start)
    names(time_start) <- "timePeriodStart"
  }

  if (!is.null(time_end)) {
    assert_time(time_end)
    names(time_end) <- "timePeriodEnd"
  }


  df <- sdg_POST("Series/DataCSV", as.list(c(
    series,
    area_codes,
    time_start,
    time_end
  )))
  suppressMessages(
    df <- readr::type_convert(df) %>%
      dplyr::filter(rowSums(is.na(.)) != ncol(.))
  )

  if (clean_names) df <- unsd_column_names(df)
  df
}

#' @noRd
assert_time <- function(time) {
  if (!is.numeric(time)) {
    stop(sprintf("time period needs to be a numeric value, not %s", class(time)), call. = FALSE)
  } else if (!(time %% 1 == 0)) {
    stop(sprintf("time period needs to be an integer value, not %s", time), call. = FALSE)
  } else if (!dplyr::between(time, 1000, 9999)) {
    stop(sprintf("time period must be a 4 digit number, not %s", time), call. = FALSE)
  }
}

#' @noRd
assert_clean_names <- function(x) {
  if (!is.logical(x)) {
    stop(sprintf("clean_names must be a logical value, not %s", class(x)), call. = FALSE)
  }
}
