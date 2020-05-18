sdg_geoareas <- function(type = "list") {
  if (type == "list") {
    tibble::as_tibble(sdg_api(path = "GeoArea/List"))
  } else if (type == "tree") {
    cat("Functionality not developed yet to parse the SDG geoArea tree.")
  } else {
    stop(sprintf("type must be 'list' or 'tree', not %s", type), call. = FALSE)
  }
}

sdg_geoarea_data <- function(area_code = NULL, area_name = NULL, returns = "all") {
  if (!is.null(area_code)) {
    assert_geoarea(area_code)
  }

  if (!is.null(area_name)) {
    area_code <- cnvrt_name_to_code(area_name)
  }

  resp <- tibble::as_tibble(sdg_api(path = paste0("GeoArea/", area_code, "/List")))
  resp <- unnest_goal_tree(resp)
  parse_goal_tree(resp, returns)
}

#' @noRd
rename_geoarea <- function(df, prefix) {
  dplyr::rename_at(df,
                   dplyr::vars(code:description),
                   ~ paste0(prefix, "_", .x))
}

#' @noRd
select_geoarea <- function(df) {
  dplyr::select(df,
                dplyr::contains("_"),
                is.list)
}

#' @noRd
cnvrt_name_to_code <- function(area_name) {
  tbl <- sdg_geoareas()
  code <- tbl$geoAreaCode[tbl$geoAreaName == area_name]
  if (length(code) == 0) {
    stop(sprintf("%s is not a valid area name in the SDG database. Use sdg_geoareas() to get a data frame of all valid area names.", area_name), call. = FALSE)
  }
  code
}
