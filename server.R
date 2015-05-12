library(shiny)
library(RTextTools)
library(tau)
library(wordcloud)
i <- 1

shinyServer(
    function(input, output){
    
        output$ngram <- renderPrint({input$x})
        output$Freq <- renderPlot({
            
                #File uploading        
                inFile <- input$file1
                if (is.null(inFile))
                    return(NULL)
                Sentance <- read.delim(inFile$datapath,as.is=TRUE, header=input$header, sep=input$sep) 
                temp <- c()
                if (ncol(Sentance)>1) {
                    for (i in 1:ncol(Sentance)) temp <- c(temp,as.vector(Sentance[[i]]))
                    Sentance <- temp
                }
               

                #Text cleaning
                if (input$punct_rm==TRUE) Sentance <- gsub("[—–,-./!$%?§±<>;]","",Sentance)
                if (input$space_rm==TRUE) Sentance <- gsub(" ","",Sentance)
            
            
                ngram <- input$x
                min_length <- input$min_word_length #min n-gramm length
                min_freq <-input$min_gram_freq  #min n-gram frequency
                temp1 <- textcnt(as.character(Sentance), method="string", n=ngram, decreasing=TRUE, split = "[[:space:][:punct:][:digit:]]+",tolower = TRUE)
                FreqTerm <- as.data.frame(unclass(temp1))
                FreqTerm$words <- row.names(FreqTerm)
                row.names(FreqTerm) <- NULL
                colnames(FreqTerm)[1] <- 'Freq'
                FreqTerm <- FreqTerm[,c(2,1)]
                FreqTerm <- FreqTerm[nchar(FreqTerm$words)>min_length,]
                FreqTerm <- FreqTerm[FreqTerm$Freq>min_freq,]
            
                wordcloud(FreqTerm$words, FreqTerm$Freq, random.order=FALSE, max.words = 15, 
                      colors=brewer.pal(8, "Dark2"), random.color=TRUE)
            
                output$FreqTable <- renderDataTable({
                    FreqTerm     
                 })
            
                output$downloadData <- downloadHandler(
                    filename = function() { 
                        paste("FreqTerm_",ngram,'_gramm.csv', sep='') 
                },
                content = function(file) {
                    write.csv(FreqTerm, file,row.names=FALSE,sep="\t",quote = FALSE)
                }
            )
            
             
        })            
    }
    )