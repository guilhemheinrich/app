#' measures UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_measures_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' measures Server Functions
#'
#' @noRd 
mod_measures_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_measures_ui("measures_1")
    
## To be copied in the server
# mod_measures_server("measures_1")
