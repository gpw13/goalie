sdg_data <- function(series) {
  assert_series(series)
  dplyr::as_tibble(sdg_POST("Series/DataCSV", list(seriesCodes=series)))
}
