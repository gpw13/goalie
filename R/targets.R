sdg_targets <- function(goals = NULL) {
  df <- dplyr::as_tibble(sdg_api("Target/List"))
  rename_select(df, "target")
}

assert_targets <- function(targets) {
  valid_targets <- targets %in% sdg_targets()[["target"]]
  if (!all(valid_targets)) {
    stop(sprintf("%s are not valid target(s) in the SDG database. Use sdg_targets() to get a data frame of all valid targets.",
                 paste(targets[!valid_targets], collapse = ", ")))
  }
}
