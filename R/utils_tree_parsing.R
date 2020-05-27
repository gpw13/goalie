#' @noRd
unnest_data_tree <- function(df) {
  df %>%
    rename_select("goal") %>%
    dplyr::mutate(targets = purrr::map(targets, select_nest)) %>%
    tidyr::unnest("targets") %>%
    rename_select("target") %>%
    dplyr::mutate(indicators = purrr::map(indicators, select_nest)) %>%
    tidyr::unnest("indicators") %>%
    rename_select("indicator") %>%
    dplyr::mutate(series = purrr::map(series, select_nest)) %>%
    tidyr::unnest("series") %>%
    rename_select("series") %>%
    dplyr::ungroup()
}

parse_data_tree <- function(df, returns) {
  assert_returns(returns)
  if (returns %in% c("all", "series")) {
    return(df)
  }

  df <- dplyr::group_by(df, dplyr::across(c(goal:indicator_description))) %>%
    dplyr::summarise(series_count = dplyr::n()) %>%
    dplyr::ungroup()

  if (returns == "indicators") {
    return(df)
  }

  df <- dplyr::group_by(df, dplyr::across(c(goal:target_description))) %>%
    dplyr::summarize(indicator_count = dplyr::n(),
                     series_count = sum(series_count)) %>%
    dplyr::ungroup()

  if (returns == "targets") {
    return(df)
  }

  dplyr::group_by(df, dplyr::across(c(goal:goal_description))) %>%
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

#' @noRd
rename_nested <- function(df, prefix) {
  dplyr::rename_with(df,
                     ~ paste0(prefix, "_", .x),
                     dplyr::any_of(renamed_vars())) %>%
    dplyr::select(-where(is.logical)) %>%
    dplyr::rename({{prefix}} := code)
}

#' @noRd
select_vars <- function(df) {
  dplyr::select(df,
                dplyr::matches(paste(renamed_vars(), key_vars(), sep = "|", collapse = "|")))
}

rename_select <- function(df, prefix) {
  df <- rename_nested(df, prefix)
  select_vars(df)
}

#' @noRd
renamed_vars <- function() c("description", "title", "tier", "release")

#' @noRd
key_vars <- function() c("goal", "target", "indicator", "series")

#' @noRd
select_nest <- function(df) {
  if (!is.data.frame(df)) {
    NA
  } else {
    dplyr::select(df, dplyr::any_of(c(renamed_vars(), "code", "targets", "indicators", "series")))
  }
}
