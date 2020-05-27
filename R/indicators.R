sdg_indicators <- function(goals = NULL, targets = NULL) {
  df <- dplyr::as_tibble(sdg_api("Indicator/List"))
  df <- rename_select(df, "indicator") %>%
    dplyr::select(-series)
  if (!is.null(targets)) {
    assert_targets(targets)
    df <- dplyr::filter(df, target %in% targets)
  } else if (!is.null(goals)) {
    assert_goals(goals)
    df <- dplyr::filter(df, goal %in% goals)
  }
  df
}

assert_indicators <- function(indicators) {
  valid_indicators <- indicators %in% sdg_indicators()[["indicator"]]
  if (!all(valid_indicators)) {
    stop(sprintf("%s are not valid indicator(s) the SDG database. Use sdg_targets() to get a data frame of all valid indicators.",
                 paste(indicators[!valid_indicators], collapse = ", ")))
  }
}
