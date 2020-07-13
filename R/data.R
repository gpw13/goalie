#' Load data from UNSD SDG database
#'
#' \code{sdg_data()} provides a data frame of all data for specified series
#'   in the UNSD SDG database
#'
#' @param series Character vector of
#'   \href{https://unstats.un.org/sdgs/indicators/database/}{SDG series codes}.
#'
#' @return A data frame.
#'
#' @export
sdg_data <- function(series) {
  assert_series(series)
  dfs <- purrr::map(series, ~ sdg_POST("Series/DataCSV", list(seriesCodes=.x)))
  df <- purrr::reduce(dfs, dplyr::bind_rows)
  suppressMessages(
    readr::type_convert(df)
  )
}
