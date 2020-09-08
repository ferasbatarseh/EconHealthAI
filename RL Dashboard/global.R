library(shiny)
library(shinydashboard)
library(tidyverse)
library(RColorBrewer)
library(DT)
library(MDPtoolbox)

convertMenuItem = function(mi,tabName) {
  
  mi$children[[1]]$attribs['data-toggle'] = "tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  
  if(length(mi$attribs$class) > 0 && mi$attribs$class == "treeview"){
    mi$attribs$class = NULL
  }
  
  mi
}