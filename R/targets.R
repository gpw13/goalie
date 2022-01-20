#' Load available targets from the UNSD SDG database
#'
#' \code{sdg_targets()} provides a data frame of all available
#' \href{https://unstats.un.org/sdgs/indicators/Global%20Indicator%20Framework%20after%202020%20review_Eng.pdf}{targets
#' in the UNSD SDG database}.
#'
#' @param goals Numeric or character vector of values between 1 and 17
#'   corresponding to the
#'   \href{https://www.un.org/development/desa/disabilities/envision2030.html}{17
#'   SDGs}.
#'
#' @return A data frame.
#'
#' @export
sdg_targets <- function(goals = 1:17) {
  assert_goals(goals)
  df <- sdg_GET("Target/List")
  df <- rename_select(df, "target")
  dplyr::filter(df, .data[["goal"]] %in% goals)
}

#' @noRd
assert_targets <- function(targets, len = length(targets)) {
  valid_targets <- targets %in% sdg_targets()[["target"]]
  if (!all(valid_targets)) {
    stop(sprintf(
      "%s are not valid target(s) in the UNSD SDG database. Use sdg_targets() to get a data frame of all valid targets.",
      paste(targets[!valid_targets], collapse = ", ")
    ))
  } else if (len != length(targets)) {
    stop(sprintf("targets must be of length %s, not %s", len, length(targets)), call. = FALSE)
  }
}
