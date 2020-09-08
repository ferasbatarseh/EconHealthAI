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
    paste0('Two actions can be performed - Wait and Share Resources, and there are three stages in this problem. <br>',
           '<B>',
           "Stage 1: Age class 0-20 years <br>",
           "Stage 2: Age class 21-40 years <br>",
           "Stage 3: Age class more than 40 years <br>",
           '</B>',
           "An action is decided and applied each time period of 20 years at the beginning of the period.  
            If a pandemic occurs, then the whole population goes back into stage 1.", 
           '<B>',
           " Thus, we want to select the policy which will maximize the reward.",
           '</B>'
    ) 
  })
  
  output$text1 = renderText({paste("The entered reward when the population is in the oldest state
                                   and action Wait is performed is")})
  output$value1 <- renderText({input$reward1})
  
  output$text2 = renderText({paste("The entered reward when the population is in the oldest state 
                                   and action Share Resources is performed is")})
  output$value2 <- renderText({input$reward2})
  
  output$text3 <- renderText({paste("The entered the value for pandemic severity is")})
  output$value3 <- renderText({input$prob})
  
  output$text4 = renderText({ paste0("<B>Reward Matrix</b>")})
  
  output$text5 = renderText({ paste0("<br><B>Transition Matrix</B>")})
  
  data <- reactive({
    num1 = as.numeric(input$reward1)
    num2 = as.numeric(input$reward2)
    num3 = as.numeric(input$prob)
    return(mdp_example_forest(3, num1, num2, num3))
  })
  
  output$table1 <- renderDataTable(
    datatable(data()$R,
              colnames = c('Wait', 'Share Resources'), 
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
    return(mdp_policy_iteration(P = data()$P, R = data()$R, discount = 0.95))
  })
  
  output$testprint <- renderText(solver()$policy) 
  
  Stage <- c(1,2,3)
  
  df1 <- reactive({
    Value <- c(solver()$V[1],solver()$V[2], solver()$V[3])
    return(data.frame(Stage, Value)) 
  })
  
  output$text6 = renderText({ paste0("<br><B>Optimal Values </B>")})
  
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
        Action[i] <- "Wait"
      }
      else
      {
        Action[i] <- "Cut"
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
    paste0('<B>Recommendation: based on the Policy Iteration algorithm, the best possible action to take 
    for the population in Stage 1 is  ',
           '<font color="#D55E00">',
           df2()$Action[1],
           '</font>',
           ', for the population in Stage 2 is ',
           '<font color="#D55E00">',
           df2()$Action[2],
           '</font>',
           ', and for the population in Stage 3 is ',
           '<font color="#D55E00">',
           df2()$Action[3],
           '</font>',
           '. ',
           '</B>'
    ) 
  })
  
})
