sdg_geoareas <- function(type = "list") {
  if (type == "list") {
    tibble::as_tibble(sdg_api(path = "GeoArea/List"))
  } else if (type == "tree") {
    cat("Functionality not developed yet to dive into the SDG tree")
  } else {
    stop(sprintf("type must be 'list' or 'tree', not %s", type), call. = FALSE)
  }
}

sdg_geoarea_data <- function(area_code = NULL, area_name = NULL, returns = "all") {
  assert_returns(returns)
  if (!is.null(area_code)) {
    assert_geoarea(area_code)
  }

  if (!is.null(area_name)) {
    area_code <- cnvrt_name_to_code(area_name)
  }

  resp <- tibble::as_tibble(sdg_api(path = paste0("GeoArea/", area_code, "/List"))) %>%
    rename_geoarea("goal") %>%
    select_geoarea() %>%
    tidyr::unnest("targets") %>%
    rename_geoarea("target") %>%
    select_geoarea() %>%
    tidyr::unnest("indicators") %>%
    rename_geoarea("indicator") %>%
    select_geoarea() %>%
    tidyr::unnest("series") %>%
    dplyr::select(dplyr::contains("_"), release:description) %>%
    dplyr::rename_at(dplyr::vars(release:description),
                     ~ paste0("series_", .x)) %>%
    dplyr::ungroup()

  if (returns %in% c("all", "series")) {
    return(resp)
  }

  resp <- dplyr::group_by(resp, dplyr::across(c(goal_code:indicator_description))) %>%
    dplyr::summarise(series_count = dplyr::n()) %>%
    dplyr::ungroup()

  if (returns == "indicators") {
    return(resp)
  }

  resp <- dplyr::group_by(resp, dplyr::across(c(goal_code:target_description))) %>%
    dplyr::summarize(indicator_count = dplyr::n(),
                     series_count = sum(series_count)) %>%
    dplyr::ungroup()

  if (returns == "targets") {
    return(resp)
  }

  dplyr::group_by(resp, dplyr::across(c(goal_code:goal_description))) %>%
    dplyr::summarize(target_count = dplyr::n(),
                    indicator_count = sum(indicator_count),
                    series_count = sum(series_count)) %>%
    dplyr::ungroup()
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

#' @noRd
assert_returns <- function(returns) {
  vals <- c("all", "series", "indicators", "targets", "goals")
  if (!(returns %in% vals)) {
    stop(sprintf("returns should be a string equal to one of '%s'",
                 paste(vals, collapse = ", ")), call. = FALSE)
  }
}
