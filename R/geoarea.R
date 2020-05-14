sdg_geoareas <- function(type = "list") {
  if (type == "list") {
    tibble::as_tibble(sdg_api(path = "GeoArea/List"))
  } else if (type == "tree") {
    cat("Functionality not developed yet to dive into the SDG tree")
  } else {
    stop(sprintf("type must be 'list' or 'tree', not %s", type), call. = FALSE)
  }
}

sdg_geoarea_data <- function(geoarea) {
  assert_geoarea(geoarea)
  resp <- tibble::as_tibble(sdg_api(path = paste0("GeoArea/", geoarea, "/List")))
  tidyr::unnest(resp, cols = "targets")
}
