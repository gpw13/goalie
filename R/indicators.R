#' @title Load available indicators from the UNSD SDG database
#'
#' @description \code{sdg_indicators()} provides a data frame of all available
#'   \href{https://unstats.un.org/sdgs/indicators/database/}{indicators in the
#'   UNSD SDG database}.
#'
#' @param goals Numeric or character vector of values between 1 and 17
#'   corresponding to the
#'   \href{https://www.un.org/development/desa/disabilities/envision2030.html}{17
#'   SDGs}.
#' @param targets Character vector of
#'   \href{https://unstats.un.org/sdgs/indicators/Global%20Indicator%20Framework%20after%202020%20review_Eng.pdf}{SDG
#'   target codes} of the form "#.#".
#'
#' @return A data frame.
#'
#' @export
sdg_indicators <- function(goals = NULL, targets = NULL) {
  df <- sdg_GET("Indicator/List")
  df <- rename_select(df, "indicator") %>%
    dplyr::select(-"series")
  if (!is.null(targets)) {
    assert_targets(targets)
    df <- dplyr::filter(df, .data[["target"]] %in% targets)
  } else if (!is.null(goals)) {
    assert_goals(goals)
    df <- dplyr::filter(df, .data[["goal"]] %in% goals)
  }
  df
}

#' @noRd
assert_indicators <- function(indicators, len = length(indicators)) {
  valid_indicators <- indicators %in% sdg_indicators()[["indicator"]]
  if (!all(valid_indicators)) {
    stop(sprintf(
      "%s are not valid indicator(s) in the UNSD SDG database. Use sdg_indicators() to get a data frame of all valid indicators.",
      paste(indicators[!valid_indicators], collapse = ", ")
    ))
  } else if (len != length(indicators)) {
    stop(sprintf("indicators must be of length %s, not %s", len, length(indicators)), call. = FALSE)
  }
}
