#' authentification UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList textInput passwordInput actionButton verbatimTextOutput
mod_authentification_ui <- function(id, default_host = "http://deepomics-api.dvp", default_token = "Basic Getme"){
  ns <- NS(id)
  tagList(
    shiny::textInput(NS(id, "host"), "Host", value = default_host),
    shiny::textInput(NS(id, "token"), "Token", value = default_token),
  )
}

#' authentification Server Functions
#'
#' @export
#' @importFrom shiny renderPrint reactive observeEvent
#' @importFrom evaluate try_capture_stack evaluate
#' @importFrom utils capture.output
mod_authentification_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns


    return(list(
      token = shiny::reactive(input$token),
      host = shiny::reactive(input$host)
    ))
  })
}

## To be copied in the UI
# mod_authentification_ui("authentification_1")

## To be copied in the server
# mod_authentification_server("authentification_1")
