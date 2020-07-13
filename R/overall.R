#' Load an overview of data available in the UNSD SDG database
#'
#' \code{sdg_overview()} provides a data frame of all available
#' \href{https://unstats.un.org/sdgs/indicators/Global%20Indicator%20Framework%20after%202020%20review_Eng.pdf}{goals,
#'   targets, indicators, and series}, in the UNSD SDG database.
#'
#' @param goals Numeric or character vector of values between 1 and 17
#'   corresponding to the
#'   \href{https://www.un.org/development/desa/disabilities/envision2030.html}{17
#'   SDGs}.
#' @param returns String specifying the level of detail to return. "all" (default) and
#'   "series" returns full details, while "indicators", "targets", and "goals"
#'   provides details only to the specified level. Beyond that level, values are
#'   summarized by their availability on the UN SDG database (e.g # of targets
#'   available under each goal).
#'
#' @return A data frame.
#'
#' @export
sdg_overview <- function(goals = 1:17, returns = "all") {
  assert_goals(goals)
  resp <- sdg_GET("Goal/List", "includechildren=true")
  resp <- unnest_data_tree(resp)
  resp <- parse_data_tree(resp, returns)
  dplyr::filter(resp, goal %in% goals)
}

#' @noRd
assert_returns <- function(returns) {
  valid <- as.character(goals) %in% as.character(1:17)
  if (!all(valid_goals)) {
    stop(sprintf("goals must be only be numeric or character values between 1 and 17, not %s", paste(goals[!valid_goals], collapse = ", ")), call. = FALSE)
  }
}
