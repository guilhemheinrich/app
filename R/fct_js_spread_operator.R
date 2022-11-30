#' js_spread_operator
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
js_spread <- function (...) {
  arguments <- list(...)
  # print(arguments)
  final <- list()
  for (listEleIndex in 1:length(arguments)) {
    listEle <- arguments[[listEleIndex]]
    # print(listEle)
    # CHeck that it has names
    if (!is.null(names(listEle)) && length(names(listEle)) == length(listEle) ) {
      for (key in names(listEle)) {
        # print(key)
        final[[key]] <- listEle[[key]]
      }
    } else {
      print(paste(listEle, "is not a fully named List (1 or more element is not named)"))
    }
  }
  return(final)
}
