sdg_dimensions <- function(goal = NULL, series = NULL) {
  sdg_features("Dimensions", goal, series)
}

sdg_attributes <- function(goal = NULL, series = NULL) {
  sdg_features("Attributes", goal, series)
}

#' @noRd
sdg_features <- function(type, goal = NULL, series = NULL) {
  if (!is.null(series)) {
    assert_series(series)
    resp <- sdg_GET(paste0("Series/", series, "/", type))
  } else if (!is.null(goal)) {
    assert_goals(goal)
    resp <- sdg_GET(paste0("Goal/", goal, "/", type))
  } else {
    stop("Must provide either a goal or series code.", call. = FALSE)
  }
  dplyr::as_tibble(resp) %>%
    tidyr::unnest(codes)
}
