#' jointed_selector UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_jointed_selector_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::uiOutput(NS(id, "choix"))
  )
}

#' jointed_selector Server Functions
#'
#' @noRd
mod_jointed_selector_server <- function(id,
                                        reactive_list,
                                        widget_options = list()){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    widget_options_reactive <- compute_reactive_in_list(widget_options)

    output$choix <- shiny::renderUI({
      final_options <<- function_options_reactive()

      if (!('label' %in% names(final_widget_options))) {
        final_widget_options[['label']] = final_widget_options[['choices']]
      }

      do.call(shiny::selectInput, final_widget_options)
    })
  })
}

## To be copied in the UI
# mod_jointed_selector_ui("jointed_selector_1")

## To be copied in the server
# mod_jointed_selector_server("jointed_selector_1")
