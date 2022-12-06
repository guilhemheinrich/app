#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  authentification <- mod_authentification_server("auth")
  projects <- mod_selectInput_GET_projects_server("projects", authentification)
  experimental_serie <- mod_selectInput_GET_experimental_series_server("experimental_series",
                                                                          authentification,
                                                                          api_function_options =
                                                                            list(
                                                                              project.id = selectedProjectId
                                                                          ))
  compartment_replicates <- mod_selectInput_GET_compartment_replicates_server(
    "compartment_replicates",
    authentification,
    api_function_options =
      list(
        "id[]" = selectedAllLocations
      ),
    widget_options = list(
      multiple = TRUE
    )
    )

  monitored_measure_types <- mod_selectInput_GET_monitored_measure_types_server(
    "monitored_measure_types",
    authentification,
    api_function_options =
      list(
        operation.id = selectedExperimentalSerieId
      ),
    widget_options = list(
      multiple = TRUE
    )
  )

  selectedProjectId <- reactiveVal("None")
  shiny::observeEvent(projects$selected(), {
    if (shiny::isTruthy(projects$selected())) {
      selectedProjectId(projects$selected()[["@id"]])
      print("selectedProjectId()")
      print(selectedProjectId())
    }
  })

  selectedExperimentalSerieId <- reactiveVal("None")
  selectedAllLocations <- shiny::reactiveVal(list())
  shiny::observeEvent(experimental_serie$selected(), {
    if (shiny::isTruthy(experimental_serie$selected())) {
      selectedExperimentalSerieId(experimental_serie$selected()[["@id"]])
      selectedAllLocations(experimental_serie$selected()[["allLocations"]][[1]]) # It's a list and not a vector => ?
      print("selectedAllLocations()")
      print(selectedAllLocations())
      print("selectedExperimentalSerieId()")
      print(selectedExperimentalSerieId())
    }
  })

  selectedAllReplicates <- shiny::reactiveVal(list())
  shiny::observeEvent(compartment_replicates$selected(), {
    if (shiny::isTruthy(compartment_replicates$selected())) {
      # selectedExperimentalSerieId(compartment_replicates$selected()[["@id"]])
      print("compartment_replicates$selected()$id")
      print(compartment_replicates$selected()$id)
      selectedAllReplicates(compartment_replicates$selected()$id)
    }
  })

  selectedAllMonitoredMeasureTypes <- shiny::reactiveVal(list())
  shiny::observeEvent(monitored_measure_types$selected(), {
    if (shiny::isTruthy(monitored_measure_types$selected())) {
      # selectedExperimentalSerieId(compartment_replicates$selected()[["@id"]])
      print("monitored_measure_types$selected()$id")
      print(monitored_measure_types$selected()$id)
      selectedAllMonitoredMeasureTypes(monitored_measure_types$selected()$id)
    }
  })

  data <- shiny::reactiveValues(data = data.frame(), name = "data")
  shiny::observeEvent(input$load_data,{
    result_df <- get_data(
      host = authentification$host(),
      token = authentification$token(),
      experimental_serie_id = selectedExperimentalSerieId(),
      type = 1,
      with_empty_columns = 1,
      replicate_ids = selectedAllReplicates(),
      monitored_measure_type_ids = selectedAllMonitoredMeasureTypes()
    )
    data$data <- result_df
  })

  results <- esquisse::esquisse_server(
    id = "esquisse",
    data_rv = data
  )
}
