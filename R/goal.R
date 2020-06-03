sdg_goals <- function(goals = 1:17, returns = "all") {
  assert_goals(goals)
  resp <- tibble::as_tibble(sdg_GET("Goal/List", "includechildren=true"))
  resp <- unnest_data_tree(resp)
  resp <- parse_data_tree(resp, returns)
  dplyr::filter(resp, goal %in% goals)
}

assert_goals <- function(goals) {
  valid_goals <- as.character(goals) %in% as.character(1:17)
  if (!all(valid_goals)) {
    stop(sprintf("goals must be only be numeric or character values between 1 and 17, not %s", paste(goals[!valid_goals], collapse = ", ")), call. = FALSE)
  }
}
