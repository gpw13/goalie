sdg_overview <- function(goals = 1:17, returns = "all") {
  assert_goals(goals)
  resp <- tibble::as_tibble(sdg_api("Goal/List", "includechildren=true"))
  resp <- unnest_data_tree(resp)
  resp <- parse_data_tree(resp, returns)
  dplyr::filter(resp, goal %in% goals)
}
