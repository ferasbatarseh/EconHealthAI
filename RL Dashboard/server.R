#' Title
#'
#' @param input 
#' @param output 
#' @param session 
#'
#' @return
#' @export
#'
#' @examples
server<- shinyServer(function(input, output, session){
  
  output$selected_var_1 <- renderText({ 
    paste0('Two actions can be performed - Wait/Idle or Share for resources, and there are three stages in this problem. <br>',
           '<B><br>',
           "Stage 1: Equipment allocated for nurses and doctors <br>",
           "Stage 2: Resources allocated for ER <br>",
           "Stage 3: Resources allocated for ICU <br>",
           '</B> <br>',
           "An action based on the values of clinical severity, transmissibility and ratio for case hospitalization
           will be recommended for each stage.Thus, it will assist policymakers in deciding actions based on the current condition.") 
  })
  
  output$text3 = renderText({paste("The entered scaled measure of clinical severity is")})
  output$value3 <- renderText({input$reward1})
  
  output$text2 = renderText({paste("The entered scaled measure of transmissibility is")})
  output$value2 <- renderText({input$reward2})
  
  output$text1 <- renderText({paste("The entered ratio for case hospitalization is")})
  output$value1 <- renderText({input$prob})
  
  output$text4 = renderText({ paste0("<B>Value Matrix</b>")})
  
  output$text5 = renderText({ paste0("<br><B>Transition Matrix</B>")})
  
  data <- reactive({
    num1 = as.numeric(input$reward1)
    num2 = as.numeric(input$reward2)
    num3 = as.numeric(input$prob)
    return(mdp_example_forest(3, num1, num2, num3))
  })
  
  output$table1 <- renderDataTable(
    datatable(data()$R,
              colnames = c('Wait/Idle', 'Share'), 
              rownames = FALSE,
              extensions = 'Buttons',
              options = list(
                dom = 't',
                buttons = list(list(
                  extend = "collection",
                  buttons = "csv",
                  text = "Download"
                )
                ), pageLength = 8
              ))
  )
  output$table2 <- renderDataTable(
    datatable(data()$P[,,1],
              colnames = c('Stage 1', 'Stage 2', 'Stage 3'), 
              rownames = FALSE,
              extensions = 'Buttons',
              options = list(
                dom = 't',
                buttons = list(list(
                  extend = "collection",
                  buttons = "csv",
                  text = "Download"
                )
                ), pageLength = 8
              ))
  )
  
  solver <- reactive({
    return(mdp_policy_iteration(P = data()$P, R = data()$R, discount = 0.5))
  })
  
  output$testprint <- renderText(solver()$policy) 
  
  Stage <- c(1,2,3)
  
  df1 <- reactive({
    Value <- round(c(solver()$V[1],solver()$V[2], solver()$V[3]),2) #,solver()$V[4],solver()$V[5], solver()$V[6],solver()$V[7])
    return(data.frame(Stage, Value)) 
  })
  
  output$text6 = renderText({ paste0("<br><B>Resources</B>")})
  
  output$selected_var_tab_1 = renderDataTable(
    datatable(df1(),rownames = FALSE,
              extensions = 'Buttons',
              options = list(
                dom = 't',
                buttons = list(list(
                  extend = "collection",
                  buttons = "csv",
                  text = "Download"
                )
                ), pageLength = 8
              ))
  )
  
  df2 <- reactive({ 
    Action <- c()
    for(i in 1:3){
      if(solver()$policy[i] == 1)
      {
        Action[i] <- "Wait/Idle"
      }
      else
      {
        Action[i] <- "Share"
      }
    }
    Stage <- c(1,2,3)
    Action <- as.character(Action)
    return(data.frame(Stage, Action))
  })
  
  output$text7 = renderText({ paste0("<br><B>Optimal Policy </B>")})
  
  output$selected_var_tab_2 = renderDataTable(
    datatable(df2(),rownames = FALSE,
              extensions = 'Buttons',
              options = list(
                dom = 't',
                buttons = list(list(
                  extend = "collection",
                  buttons = "csv",
                  text = "Download"
                )
                ), pageLength = 8
              ))
  )
  output$selected_var_2 <- renderText({ 
    paste0('<B> The Policy Iteration algorithm suggests the best possible action 
    for the equipments allocated in Stage 1 is  ',
           '<font color="#D55E00">',
           df2()$Action[1],
           '</font>',
           ', for the resources allocated in Stage 2 is ',
           '<font color="#D55E00">',
           df2()$Action[2],
           '</font>',
           ', and for the resources allocated in Stage 3 is ',
           '<font color="#D55E00">',
           df2()$Action[3],
           '</font>',
           '. ',
           '</B>'
    ) 
  })
  
})
