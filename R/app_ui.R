library(shinydashboard)

#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic

    shinydashboard::dashboardPage(
      shinydashboard::dashboardHeader(title = "Deepomics viewer"),
      shinydashboard::dashboardSidebar(
        shinydashboard::sidebarMenu(
          id = "tabs",
          shinydashboard::menuItem("Authentification",
                                   tabName = "authentification",
                                   mod_authentification_ui("auth",
                                                           default_token = "Basic   dG9rZW46ZWI1ZTc4ZDM3ZmZmNGYzN2I2MDBiYzBlZTJjMjg2ZjA=")),
          shinydashboard::menuItem("Experimental serie selection",
                                   tabName = "experimental_serie",
                                   mod_selectInput_GET_projects_ui("projects"),
                                   mod_selectInput_GET_experimental_series_ui('experimental_series'),
                                   mod_selectInput_GET_compartment_replicates_ui('compartment_replicates'),
                                   mod_selectInput_GET_monitored_measure_types_ui('monitored_measure_types')
                                   )

        )
      ),
      shinydashboard::dashboardBody(h1('nothing'))
    )

    # navbarPage("Deepomics explorer",
    #            tabPanel("Authentification", mod_authentification_ui("auth", default_token = "Basic dG9rZW46ZWI1ZTc4ZDM3ZmZmNGYzN2I2MDBiYzBlZTJjMjg2ZjA=")),
    #            tabPanel("Projects", mod_projects_ui("projects")),
    #            tabPanel("experimentalSerie", mod_jointed_selector_ui("experimental_serie"))
    # )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "app"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
