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
                      format = "csv",
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
  body <- paste0('
                    {
        "locations": "', paste0(replicate_ids, collapse = ","), '",
        "mmts": "', paste0(monitored_measure_type_ids, collapse = ","), '"
                    }
        '
  )
  body <- list(
    locations = paste0(replicate_ids, collapse = ","),
    mmts = paste0(monitored_measure_type_ids, collapse = ",")
  )

  print(body)


  post_result <- parse_status(
    # This request is a POST request
    httr::POST(
      call0,
      # It is a POST request, which have its arguments passed as a body parameter, and *not* as a multiple query parmaters like previous request.
      # As we precised the Content-Type to be an application/json format, we need to pass this argument as a valid JSON object.
      body = body,
      httr::add_headers(
        `Content-Type` = "multipart/form-data",
        Accept = "application/json",
        Authorization = token
      ),
      encode = "multipart"
    )
  )

  post_result_text <- httr::content(post_result, "text")
  separator = ";"
  header_lines <- utils::read.csv(
    text = post_result_text,
    nrows = 3,
    header = FALSE,
    sep = separator
  )
  header <- paste(header_lines[1, ], header_lines[2, ],header_lines[3, ], sep = "/")
  print(header)
  result_df <- read.csv(
    text = post_result_text,
    skip = 2,
    col.names = header,
    row.names = NULL,
    check.names = FALSE,
    sep = separator
  )
  # post_result_json <- jsonlite::prettify(
  #   post_result_text
  # )
  print(result_df)
  return(result_df)

}
