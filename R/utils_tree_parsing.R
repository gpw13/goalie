#' @noRd
unnest_goal_tree <- function(df) {
  df %>%
    rename_geoarea("goal") %>%
    select_geoarea() %>%
    tidyr::unnest("targets") %>%
    rename_geoarea("target") %>%
    select_geoarea() %>%
    tidyr::unnest("indicators") %>%
    rename_geoarea("indicator") %>%
    select_geoarea() %>%
    tidyr::unnest("series") %>%
    dplyr::select(dplyr::contains("_"), release:description) %>%
    dplyr::rename_at(dplyr::vars(release:description),
                     ~ paste0("series_", .x)) %>%
    dplyr::ungroup()
}

parse_goal_tree <- function(df, returns) {
  assert_returns(returns)
  if (returns %in% c("all", "series")) {
    return(df)
  }

  df <- dplyr::group_by(df, dplyr::across(c(goal_code:indicator_description))) %>%
    dplyr::summarise(series_count = dplyr::n()) %>%
    dplyr::ungroup()

  if (returns == "indicators") {
    return(df)
  }

  df <- dplyr::group_by(df, dplyr::across(c(goal_code:target_description))) %>%
    dplyr::summarize(indicator_count = dplyr::n(),
                     series_count = sum(series_count)) %>%
    dplyr::ungroup()

  if (returns == "targets") {
    return(df)
  }

  dplyr::group_by(df, dplyr::across(c(goal_code:goal_description))) %>%
    dplyr::summarize(target_count = dplyr::n(),
                     indicator_count = sum(indicator_count),
                     series_count = sum(series_count)) %>%
    dplyr::ungroup()
}

#' @noRd
assert_returns <- function(returns) {
  vals <- c("all", "series", "indicators", "targets", "goals")
  if (!(returns %in% vals)) {
    stop(sprintf("returns should be a string equal to one of '%s'",
                 paste(vals, collapse = ", ")), call. = FALSE)
  }
}

