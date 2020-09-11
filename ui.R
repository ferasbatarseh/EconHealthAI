header <- dashboardHeader(title = span("Dashboard", width = 550))

sidebar <- dashboardSidebar(sidebarMenu(
  sidebarMenu(id = "sidebarmenu"),       
  numericInput("prob", "Enter the ratio for case hospitalization", "0"),
  numericInput("reward1", "Enter the scaled measure of clinical severity", "4"),
  numericInput("reward2", "Enter the scaled measure of transmissibility", "2")
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
               htmlOutput("selected_var_1")
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
           box(title = "Resources and Policy",
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
    ),
    column(width = 6,
           box(title = "Recommendation",
               width = NULL,
               status = "primary",
               height = "100%",
               solidHeader = TRUE,
               collapsible  = TRUE,
               htmlOutput("selected_var_2") 
           ),
           img(src='Snapshot.png', align = "right", width =600, height = 320)
    ),
  )
)

ui = fluidPage(dashboardPage(
  skin = "black",       # <- app skin/themes
  header,               # <- app header
  sidebar,              # <- app sidebar
  body                  # <- app body
)
)