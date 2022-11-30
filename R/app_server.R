#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  authentification <- mod_authentification_server("auth")
  projects <- mod_projects_server("projects", authentification)
  # experimental_serie <- mod_experimental_series_server("experimental_series",
  #                                                   authentification,
  #                                                   api_function_options =
  #                                                     list(
  #                                                       project.id = projects$selected()[["@id"]]
  #                                                       )
  #                                                   )

  obsProject <- observe({
    if (shiny::isTruthy(projects$selected())) {
      print('projects$selected()[["@id"]]')
      print(projects$selected()[["@id"]])
      project_id <- projects$selected()[["@id"]]
      experimental_serie <- mod_experimental_series_server("experimental_series",
                                                           authentification,
                                                           api_function_options =
                                                             list(
                                                               project.id = project_id
                                                             )
      )
    }
  })
}
