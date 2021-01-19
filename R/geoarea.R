#' @title Load the geoArea reference table from the UNSD SDG database
#'
#' @description \code{sdg_geoareas()} provides a data frame of all geoArea
#'   \href{https://unstats.un.org/unsd/methodology/m49/}{M49 codes} and names.
#'   If all arguments are NULL, returns all possible values, but if `goal`,
#'   `indicator`, or `series` specified, returns geoArea codes and names
#'   available for that subset of the SDGs.
#'
#' @param goal Numeric or character value between 1 and 17 corresponding to
#'   one of the
#'   \href{https://www.un.org/development/desa/disabilities/envision2030.html}{17
#'   SDGs}.
#' @param target Character value of one of the
#'   \href{https://unstats.un.org/sdgs/indicators/Global%20Indicator%20Framework%20after%202020%20review_Eng.pdf}{SDG
#'   target codes} of the form "#.#".
#' @param indicator Character value of one of the
#'   \href{https://unstats.un.org/sdgs/indicators/Global%20Indicator%20Framework%20after%202020%20review_Eng.pdf}{SDG
#'   indicator codes} of the form "#.#.#".
#' @param series Character value of one of the
#'   \href{https://unstats.un.org/sdgs/indicators/database/}{SDG series codes}.
#'
#' @return A data frame.
#'
#' @export
sdg_geoareas <- function(goal = NULL, target = NULL, indicator = NULL, series = NULL) {
  if (!is.null(series)) {
    assertthat::assert_that(length(series) == 1)
    assert_series(series, 1)
    path <- paste0("Series/", series, "/GeoAreas")
  } else if (!is.null(target)) {
    assertthat::assert_that(length(target) == 1)
    assert_targets(target)
    path <- paste0("Target/", target, "/GeoAreas")
  } else if (!is.null(indicator)) {
    assertthat::assert_that(length(indicator) == 1)
    assert_indicators(indicator)
    path <- paste0("Indicator/", indicator, "/GeoAreas")
  } else if (!is.null(goal)) {
    assertthat::assert_that(length(goal) == 1)
    assert_goals(goal, 1)
    path <- paste0("Goal/", goal, "/GeoAreas")
  } else {
    path <- "GeoArea/List"
  }
  sdg_GET(path)
}

#' @title Show SDG data available for specific geoArea
#'
#' @description \code{sdg_geoarea_data()} provides a data frame of all series
#'   available for a specific \href{https://unstats.un.org/unsd/methodology/m49/}{
#'   geoArea}. Must provide either an M49 area code or name, corresponding to
#'   the UN SD standards. You can search for valid codes and names using
#'   \code{sdg_geoareas()}.
#'
#' @param area_code \href{https://unstats.un.org/unsd/methodology/m49/}{M49 code}
#'   for a specific geoArea.
#' @param area_name \href{https://unstats.un.org/unsd/methodology/m49/}{M49 name}
#'   for a specific geoArea. Recommended to use code instaed since the name
#'   must exactly match.
#' @param returns String specifying the level of detail to return. "all" (default) and
#'   "series" returns full details, while "indicators", "targets", and "goals"
#'   provides details only to the specified level. Beyond that level, values are
#'   summarized by their availability on the UN SDG database (e.g # of targets
#'   available under each goal).
#'
#' @return A data frame.
#'
#' @export
sdg_geoarea_data <- function(area_code = NULL, area_name = NULL, returns = "all") {
  if (!is.null(area_code)) {
    assert_geoarea(area_code)
  } else if (!is.null(area_name)) {
    area_code <- cnvrt_name_to_code(area_name)
  } else {
    stop("Must provide either area_code or area_name.", call. = F)
  }

  resp <- dplyr::as_tibble(sdg_GET(path = paste0("GeoArea/", area_code, "/List")))
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
assert_geoarea <- function(geoareas) {
  areas <- sdg_geoareas()[["geoAreaCode"]]
  valid_areas <- geoareas %in% areas
  if (!all(valid_areas)) {
    stop(sprintf("%s(s) are not valid geoAreaCodes", paste(geoareas, collapse = ", ")), call. = FALSE)
  }
}
