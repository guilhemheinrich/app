#' experimental_series UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_experimental_series_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::uiOutput(NS(id, "choix"))
  )
}

#' experimental_series Server Functions
#'
#' @noRd
mod_experimental_series_server <- function(id,
                                           authentification_module,
                                           project = NULL,
                                           api_function_options = list(),
                                           widget_options = list()) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Function to call when wanted actual values, in a reactive context
    function_options_reactive <- compute_reactive_in_list(api_function_options)
    widget_options_reactive <- compute_reactive_in_list(widget_options)

    result_df <- reactiveVal(data.frame())
    itemList <- reactiveVal(list())

    output$choix <- shiny::renderUI({
      # Compute reactive
      host <- authentification_module$host()
      token <- authentification_module$token()

      final_options <<- function_options_reactive()

      # Custom code
      # This is where the code should come from a R deepomics package
      call1 <-
        paste0(
          host,
          "/experimental_series",
          parse_query_parameters(
            js_spread(
              list(
                pageSize = 10000
              ),
              final_options)
          )
        )

      get_result <- parse_status(
        # This request is a GET request
        httr::GET(call1, httr::add_headers(Authorization = token))
      )
      get_result_text <- httr::content(get_result, "text")

      label <- 'Choose an experimental serie:'
      final_widget_options <- widget_options_reactive()
      final_widget_options[['inputId']] = ns("choix")
      get_result_json <- jsonlite::fromJSON(get_result_text, flatten = TRUE)
      result_df_static <- get_result_json[['hydra:member']]
      result_df(result_df_static)
      # result_df(get_result_json[['hydra:member']])

      itemListStatic <- setNames(result_df_static[["@id"]], result_df_static$slug)
      itemList(itemListStatic)
      # If the user specifies thoses values, we keep item
      # This allow easy use of the module by hiding its UI
      if (!('label' %in% names(final_widget_options))) {
        final_widget_options[['label']] = label
      }
      if (!('choices' %in% names(final_widget_options))) {
        final_widget_options[['choices']] = itemListStatic
      }
      if (isTruthy(final_widget_options$multiple)) {
        label <- 'Choose one or more experimental series:'
      }
      do.call(shiny::selectInput, final_widget_options)
    })

    selected <- shiny::reactive({
      choice <- which(input$choix == itemList())
      out <- NA
      if (!is.null(input$choix) && length(itemList()) > 0 &&
          choice != 0) {
        # index_selected <- which(LETTERS == "R")
        out <- result_df()[choice, ]
      } else {
        out <- NA
      }
      return(out)
    })

    return(
      list(
        input = input,
        options = shiny::reactive({
          final_options
        }),
        selected = selected,
        choices = itemList,
        result_df = shiny::reactive({
          result_df
        })
      )
    )
  })
}

## To be copied in the UI
# mod_experimental_series_ui("experimental_series_1")

## To be copied in the server
# mod_experimental_series_server("experimental_series_1")
