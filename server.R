source(file="global.R")

shinyServer(function(input, output, session) {
  
  
  
  session$onSessionEnded(stopApp)
})
