# shiny::runGitHub(repo = "Test1", username = "matiaswak")
options(repos = 'https://cran.rstudio.com/')

if(suppressMessages(suppressWarnings(!require(shiny)))){install.packages("shiny");library(shiny)}
if(suppressMessages(suppressWarnings(!require(digest)))){install.packages("digest");library(digest)}
if(suppressMessages(suppressWarnings(!require(flexdashboard)))){install.packages("flexdashboard");library(flexdashboard)}
if(suppressMessages(suppressWarnings(!require(shinydashboard)))){install.packages("shinydashboard");library(shinydashboard)}
if(suppressMessages(suppressWarnings(!require(shinyjs)))){install.packages("shinyjs");library(shinyjs)}
if(suppressMessages(suppressWarnings(!require(tidyverse)))){install.packages("tidyverse");library(tidyverse)}
if(suppressMessages(suppressWarnings(!require(shinyalert)))){install.packages("shinyalert");library(shinyalert)}
if(suppressMessages(suppressWarnings(!require(curl)))){install.packages("curl");library(curl)}
if(suppressMessages(suppressWarnings(!require(sodium)))){install.packages("sodium");library(sodium)}
if(suppressMessages(suppressWarnings(!require(googledrive)))){install.packages("googledrive");library(googledrive)}


DECRYPT <- function(ENCRYPTED_MESSAGE, PRIVATE_PASSWORD, israw = FALSE){
  ENCRYPTED_MESSAGE <- sapply(seq(1, nchar(ENCRYPTED_MESSAGE), by = 2), function(x) substr(ENCRYPTED_MESSAGE, x, x + 1))
  ENCRYPTED_MESSAGE <- as.raw(strtoi(ENCRYPTED_MESSAGE, base = 16L))
  key <- as.character(PRIVATE_PASSWORD)
  key_hash <- sha256(charToRaw(key))
  if(israw){
    decripted_msg <- simple_decrypt(ENCRYPTED_MESSAGE, key_hash)
  }else{
    decripted_msg <- rawToChar(simple_decrypt(ENCRYPTED_MESSAGE, key_hash))
  }
  decripted_msg
}

ui <- fluidPage(
  useShinyjs(),
  passwordInput(inputId = "password_to_dash", label = "Password"),
  actionButton(inputId = "password_to_dash_button", "Enter")
)

server <- shinyServer(function(input, output, session){
  
  observeEvent(input$password_to_dash_button, {
    pass <- digest(paste0(input$password_to_dash, "password_to_dash"), algo = "sha512", serialize = FALSE)
    if(substr(pass, 1, 64) == "34079c9977819e8e88fb33763722eff2ad393b4b3e0dff6ed2f48ad0cf54dc90"){
      showNotification("Initializing...", type = "message", duration = 10)
      con <- curl("https://raw.githubusercontent.com/matiaswak/Test1/master/EncryptedApp")
      data_raw <- readLines(con)
      close(con)
      path <- path.expand("~")
      dir.create("~/DASH", showWarnings = FALSE)
      dir.create("~/DASH/preapp", showWarnings = FALSE)
      dir.create("~/DASH/app", showWarnings = FALSE)
      data_decrypted <- tryCatch(DECRYPT(data_raw, input$password_to_dash, israw = TRUE), error = function(e) NULL)
      if(!is.null(data_decrypted)){
        dashpath <- path.expand(paste0(path, "/DASH/app"))
        writeBin(object = data_decrypted, con = "~/DASH/app/app.R")
      }else{
        shinyjs::info("Could Not Decrypt App")
      }
      
      # con <- curl("https://github.com/matiaswak/Test1/blob/master/drive?raw=true")
      con <- curl("https://github.com/matiaswak/Test1/raw/master/drive")
      data_raw <- readLines(con)
      close(con)
      data_decrypted <- tryCatch(DECRYPT(data_raw, input$password_to_dash, israw = TRUE), error = function(e) NULL)
      if(!is.null(data_decrypted)){
        writeBin(object = data_decrypted, con = "~/DASH/app/drive")
      }else{
        shinyjs::info("Could Not Decrypt Drive")
      }
      
      con <- curl("https://raw.githubusercontent.com/matiaswak/Test1/master/SendOnEnter.js")
      data_js <- readLines(con, warn = FALSE)
      close(con)
      writeLines(text = data_js, con = "~/DASH/app/SendOnEnter.js")
      
      con <- curl("https://raw.githubusercontent.com/matiaswak/Test1/master/shinychat.css")
      data_js <- readLines(con, warn = FALSE)
      close(con)
      writeLines(text = data_js, con = "~/DASH/app/shinychat.css")
      
      writeLines(text = paste0('shiny::runApp("', gsub("\\\\", "/", dashpath), '", launch.browser=TRUE)'),
                 con = "~/DASH/app/exe")
      
      exe <- paste0('R CMD BATCH  "', paste0(dashpath, "/exe"),'"')
      system(exe, wait = FALSE)
    }else{
      shinyjs::info("Incorrect")
    }
  })
  
  session$onSessionEnded(stopApp)
})

shinyApp(ui, server)
