#' @noRd
sdg_api <- function(path = NULL, query = NULL, type = "GET") {
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
  jsonlite::fromJSON(httr::content(resp, "text"))
}

#' @noRd
modify_query <- function(qry) {
  gsub(" ", "%20", qry)
}

# Importing the pipe operator
#' @importFrom dplyr %>%
NULL

