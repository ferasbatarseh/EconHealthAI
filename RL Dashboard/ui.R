header <- dashboardHeader(title = span("Dashboard", width = 550))

sidebar <- dashboardSidebar(sidebarMenu(
  sidebarMenu(id = "sidebarmenu"),       
  numericInput("prob", "Enter the value for pandemic severity", "0.1"),
  numericInput("reward1", "Enter reward when the population is in the oldest state and
               action Wait is performed", "4"),
  numericInput("reward2", "Enter reward when the population is in the oldest state and action 
               Share Resources is performed", "2")
)
)

body = dashboardBody(
  fluidRow (
    column(width = 6,
           box(title = "Resources Management Problem",
               width = NULL,
               status = "primary",
               height = "100%",
               solidHeader = TRUE,
               collapsible  = TRUE,
               htmlOutput("selected_var_1"),
               htmlOutput("selected_var_2") 
           )
    ),
    column(width = 6,
           box(title = "Inputs",
               width = NULL,
               status = "primary",
               height = "100%",
               solidHeader = TRUE,
               collapsible  = TRUE,
               textOutput("text1"),
               verbatimTextOutput("value1"),
               textOutput("text2"),
               verbatimTextOutput("value2"),
               textOutput("text3"),
               verbatimTextOutput("value3")
           )
    ),
    column(width = 6,
           box(title = "Reward and Transition Matrix",
               width = NULL,
               status = "primary",
               height = "100%",
               solidHeader = TRUE,
               collapsible  = TRUE,
               htmlOutput("text4"),
               DT::dataTableOutput("table1"),
               htmlOutput("text5"),
               DT::dataTableOutput("table2"),
           )
    ),
    column(width = 6,
           box(title = "Optimal Values and Policy",
               width = NULL,
               status = "primary",
               height = "100%",
               solidHeader = TRUE,
               collapsible  = TRUE,
               htmlOutput("text6"),
               DT::dataTableOutput("selected_var_tab_1"),
               htmlOutput("text7"),
               DT::dataTableOutput("selected_var_tab_2")
           )
    )
  )
)

ui = fluidPage(dashboardPage(
  skin = "black",       # <- app skin/themes
  header,               # <- app header
  sidebar,              # <- app sidebar
  body                  # <- app body
)
)