#' replicates UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_replicates_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' replicates Server Functions
#'
#' @noRd 
mod_replicates_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_replicates_ui("replicates_1")
    
## To be copied in the server
# mod_replicates_server("replicates_1")
