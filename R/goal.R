sdg_goals <- function(goals = 1:17, returns = "all") {
  assert_goals(goals)
  resp <- tibble::as_tibble(sdg_api("Goal/List", "includechildren=true"))
  resp <- unnest_goal_tree(resp)
  resp <- parse_goal_tree(resp, returns)
  dplyr::filter(resp, goal_code %in% goals)
}

assert_goals <- function(goals) {
  if (!(as.character(goals) %in% as.character(1:17))) {
    stop(sprintf("goals must be only be numeric or character values between 1 and 17, not %s", goals), call. = FALSE)
  }
}
