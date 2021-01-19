#' Load available dimensions from the UNSD SDG database
#'
#' \code{sdg_dimensions()} provides a data frame of all available dimensions
#'   for a specific SDG goal or series of data.
#'
#' @param goal Numeric or character value between 1 and 17 corresponding to
#'   one of the
#'   \href{https://www.un.org/development/desa/disabilities/envision2030.html}{17
#'   SDGs}.
#' @param series Character value of one of the
#'   \href{https://unstats.un.org/sdgs/indicators/database/}{SDG series codes}.
#'
#' @return A data frame.
#'
#' @export
sdg_dimensions <- function(goal = NULL, series = NULL) {
  sdg_features("Dimensions", goal, series)
}

#' Load available attributes from the UNSD SDG database
#'
#' \code{sdg_attributes()} provides a data frame of all available attributes
#'   for a specific SDG goal or series of data.
#'
#' @param goal Numeric or character value between 1 and 17 corresponding to
#'   one of the
#'   \href{https://www.un.org/development/desa/disabilities/envision2030.html}{17
#'   SDGs}.
#' @param series Character value of one of the
#'   \href{https://unstats.un.org/sdgs/indicators/database/}{SDG series codes}.
#'
#' @return A data frame.
#'
#' @export
#' @export
sdg_attributes <- function(goal = NULL, series = NULL) {
  sdg_features("Attributes", goal, series)
}

#' @noRd
sdg_features <- function(type, goal = NULL, series = NULL) {
  if (!is.null(series)) {
    assert_series(series, 1)
    resp <- sdg_GET(paste0("Series/", series, "/", type))
  } else if (!is.null(goal)) {
    assert_goals(goal, 1)
    resp <- sdg_GET(paste0("Goal/", goal, "/", type))
  } else {
    stop("Must provide either a goal or series code.", call. = FALSE)
  }
  tidyr::unnest(resp, data = "codes")
}
