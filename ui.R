#load required packages
library(shinydashboard)
library(shiny)
library(DT)

dashboardPage(
  
  #header
  dashboardHeader(
    #application title
    title = "Shinyscape"
  ),
  
  #sidebar content
  dashboardSidebar(
    h3(HTML('&nbsp;'),'1. Gene list'),
    htmlOutput('gl.status'),
    uiOutput('string.button'),
    h3(HTML('&nbsp;'),'2. Data Vis'),
    htmlOutput('ds.status'),
    htmlOutput('run.status'),
    uiOutput('run.button')
  ),
  
  #body content
  dashboardBody(
    fluidRow(
      #debug
      textOutput('debug.text')
    ),
    fluidRow(
      box(
        title = "Gene List", status = "info", solidHeader = TRUE, collapsible = T,
        textOutput("gl.text"),
        fileInput("gl.file", "Upload CSV Files",
                  multiple = FALSE,
                  accept = c("text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv")),
        div(DT::dataTableOutput("table.gl"), style = "font-size:80%; line-height:30%"),
        br(),
        uiOutput("gene.check"),
        htmlOutput("gl.ready")
      ),
      box(
        title = "Data Vis", status = "warning", solidHeader = TRUE, collapsible = T,
        textOutput("dv.text"),
        sliderInput("node.label.font.size", "Node Font Size", 4,24,1)
      ),
      box(
        title = "Cytoscape Network", status = "primary", solidHeader = TRUE, collapsible = T,
        imageOutput("cyto.png")
      )
    )
  )
)