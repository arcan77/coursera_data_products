library(shiny)
require(rCharts)
shinyUI(
pageWithSidebar(
    headerPanel("Extracting top n-gramms from text"),
    
    
    sidebarPanel(
        
        fileInput('file1', 'Upload file with text'),
        checkboxInput('header', 'Header', FALSE),
        radioButtons('sep', 'Separator',
                     c(Dot='.',
                       Comma=',',
                       Semicolon=';',
                       Tab='\t'),
                       '.'),
        tags$hr(),      
        sliderInput ('x',"Choose N for n-gramms", value=1, min=1, max=5, step=1),
        checkboxInput("punct_rm", label = "Remove punctuation", value = FALSE),
        checkboxInput("space_rm", label = "Remove spaces", value = FALSE),
        numericInput('min_word_length','Minimum n-gram length to cut off', 0, min=1, max=100, step=1),
        numericInput('min_gram_freq','Minimum n-gramm frequency to cut off', 0, min=1, max=100, step=1),
        submitButton("Go!")    
    ),
    
    
    mainPanel(
      
        h4('Wordcloud of top n-gramms:'),
        plotOutput('Freq'),
        dataTableOutput("FreqTable"),
        h4("You can download the table with results"),
        downloadButton('downloadData', 'Download')
        
        )
    
)
)