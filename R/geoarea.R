sdg_geoareas <- function(goal = NULL, indicator = NULL, series = NULL) {
  if (!is.null(series)) {
    assert_series(series)
    path <- paste0("Series/", series, "/GeoAreas")
  } else if (!is.null(indicator)) {
    path <- paste0("Indicator/", indicator, "/GeoAreas")
  } else if (!is.null(goal)) {
    assert_goals(goal)
    path <- paste0("Goal/", goal, "/GeoAreas")
  } else {
    path <- "GeoArea/List"
  }
  dplyr::as_tibble(sdg_api(path))
}

sdg_geoarea_data <- function(area_code = NULL, area_name = NULL, returns = "all") {
  if (!is.null(area_code)) {
    assert_geoarea(area_code)
  } else if (!is.null(area_name)) {
    area_code <- cnvrt_name_to_code(area_name)
  } else {
    stop("Must provide either area_code or area_name.", call. = F)
  }

  resp <- dplyr::as_tibble(sdg_api(path = paste0("GeoArea/", area_code, "/List")))
  resp <- unnest_data_tree(resp)
  parse_data_tree(resp, returns)
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

#' @noRd
assert_geoarea <- function(geoarea) {
  areas <- sdg_geoareas()[["geoAreaCode"]]
  if (!(geoarea %in% areas)) {
    stop(sprintf("%s is not a valid geoAreaCode", geoarea), call. = FALSE)
  }
}
