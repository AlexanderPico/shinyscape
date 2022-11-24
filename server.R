#load required packages
require(RCy3)

shinyServer(function(input, output, session) {
  
  rv <- reactiveValues()
  
  ########### 
  # sidebar #
  ###########
  
  
  #############
  # cytoscape #
  #############
  
  refreshImage<-function(){
    output$cyto.png <- renderImage({
      RCy3::exportImage("cyto.png", width = 500, network = rv$net.suid)
      list(src = "cyto.png", alt = "Cytoscape screenshot")
    }, deleteFile = FALSE)
  }
  
  #############
  # gene list #
  #############
  
  getGeneList <- function(){
    output$gl.text <- NULL
    output$gene.check <- NULL
    rv$gl.status <- FALSE
    if (file.exists("gl.csv")){
      data.df <- read.table("gl.csv", sep = ",", header = T, stringsAsFactors = F)
      checkTableData(data.df)
      return(data.df) 
    }
  }
  
  #check table data
  checkTableData <- function(data.df) {
    output$gl.text <- renderText("Let's examine your gene list...")
    ds.names <- tolower(names(data.df))
    #GENE CHECK
    if(!'gene' %in% ds.names){
      stop('Please reformat your CSV to have a "gene" column with gene names.')
    } 
    rv$gene.list <- data.df$gene[1:5]
    #TODO
    rv$gl.status <- TRUE
  }
  
  #render table data
  output$table.gl <- DT::renderDataTable(server = TRUE,{
    DT::datatable({ head(getGeneList()) },
                  rownames=FALSE,
                  options = list(
                    dom = 'Brt'
                  )
    )
  })
  
  #when upload is performed
  observeEvent(input$gl.file, { 
    # output$debug.text<-renderText(paste(input$gl.file$name,collapse = ","))
    uploaded.file = file.rename(input$gl.file$datapath, "gl.csv")
    output$table.gl <- NULL
    getGeneList()
  })
  
  #set run status
  observe({
    if(rv$gl.status){
      output$gl.ready <-  renderText("&emsp;&#10004; Ready!")
      output$gl.status <- renderText("&emsp;&#10004; Ready!")
      output$string.button <- renderUI({
        actionButton("string.query", "Create Network")
      })
    } else {
      output$gl.ready <- NULL
      output$gl.status <- NULL
    }
  })
  
  observeEvent(input$string.query,{
    rv$net.suid <- RCy3::commandsPOST(paste0(
      'string protein query query="',
      paste(rv$gene.list, collapse = ","),
      '"')
    )
    refreshImage()
  })
  
  ############
  # data vis #
  ############
  observeEvent(input$node.label.font.size, {
    RCy3::setNodeFontSizeDefault(input$node.label.font.size, "STRING")
    refreshImage()
  })
  
  # 
  # #differential analysis tab - select the cluster number
  # output$DEclusterNumUI <- renderUI({
  #   selectInput(
  #     "clusterNum",
  #     "Choose a cluster to compare with all other clusters for differentially expressed genes",
  #     choices = sort(unique(get(input$dataset)@meta.data$seurat_clusters)),
  #     selected = sort(unique(get(input$dataset)@meta.data$seurat_clusters))[1]
  #   )
  # })
  
  
})
