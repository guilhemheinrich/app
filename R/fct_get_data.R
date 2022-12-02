#' get_data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_data <- function(
                      host,
                      token,
                      experimental_serie_id,
                      type = 1,
                      with_empty_columns = 1,
                      format = "xlsx",
                      replicate_ids = c(),
                      monitored_measure_type_ids = c()
                     ) {
  operation_id <- substr(
      experimental_serie_id,
      nchar("/experimental_series/") + 1,
      nchar(experimental_serie_id)
    )
  call0 <- paste0(c(
      host,
      "operation",
      operation_id,
      "monitored_data",
      "export",
      format,
      type,
      with_empty_columns
    ),
    collapse = "/"
  )
  print(call0)
  print(token)
  post_result <- parse_status(
    # This request is a POST request
    httr::POST(
      call0,
      # It is a POST request, which have its arguments passed as a body parameter, and *not* as a multiple query parmaters like previous request.
      # As we precised the Content-Type to be an application/json format, we need to pass this argument as a valid JSON object.
      body = paste0('
        "locations": ', paste0(replicate_ids, collapse = ","), ',
        "mmts": "', paste0(monitored_measure_type_ids, collapse = ","), '
        '
      ),
      httr::add_headers(
        `Content-Type` = "multipart/formdata",
        Accept = "application/json",
        Authorization = token
      )
    )
  )

  post_result_text <- httr::content(post_result, "text")
  post_result_json <- jsonlite::fromJSON(
    post_result_text,
    flatten = TRUE
  )
  print(post_result_json)

}
