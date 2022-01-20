#' @noRd
sdg_GET <- function(path = NULL, query = NULL) {
  query <- modify_query(query)
  url <- httr::modify_url("https://unstats.un.org", path = paste0("SDGAPI/v1/sdg/", path), query = query)

  resp <- httr::GET(url, httr::accept_json())
  if (httr::http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "SDG API request failed with status %s",
        httr::status_code(resp)
      ),
      call. = FALSE
    )
  }
  df <- jsonlite::fromJSON(httr::content(resp, "text"))
  dplyr::as_tibble(df)
}

#' @noRd
sdg_POST <- function(path = NULL, body = NULL, type = "text/csv", encoding = "UTF-8") {
  url <- httr::modify_url("https://unstats.un.org", path = paste0("SDGAPI/v1/sdg/", path))

  resp <- httr::POST(url, body = body)
  if (httr::http_type(resp) != "application/octet-stream") {
    stop("API did not return application/octet-stream", call. = FALSE)
  }

  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "SDG API request failed with status %s",
        httr::status_code(resp)
      ),
      call. = FALSE
    )
  }
  suppressWarnings(
    httr::content(resp, type = type, encoding = encoding, col_types = readr::cols(.default = "c"))
  )
}


#' @noRd
modify_query <- function(qry) {
  gsub(" ", "%20", qry)
}

#' @noRd
unsd_column_names <- function(df) {
  nms <- names(df)
  nms <- stringr::str_replace_all(nms, "[^A-Za-z_ ]+", "")
  nms <- stringr::str_replace_all(nms, " ", "_")
  names(df) <- nms
  df
}
