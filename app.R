options(repos = 'https://cran.rstudio.com/')

if(suppressMessages(suppressWarnings(!require(shiny)))){install.packages("shiny");library(shiny)}
if(suppressMessages(suppressWarnings(!require(digest)))){install.packages("digest");library(digest)}
if(suppressMessages(suppressWarnings(!require(flexdashboard)))){install.packages("flexdashboard");library(flexdashboard)}
if(suppressMessages(suppressWarnings(!require(shinydashboard)))){install.packages("shinydashboard");library(shinydashboard)}
if(suppressMessages(suppressWarnings(!require(shinyjs)))){install.packages("shinyjs");library(shinyjs)}
if(suppressMessages(suppressWarnings(!require(tidyverse)))){install.packages("tidyverse");library(tidyverse)}
if(suppressMessages(suppressWarnings(!require(shinyalert)))){install.packages("shinyalert");library(shinyalert)}
if(suppressMessages(suppressWarnings(!require(curl)))){install.packages("curl");library(curl)}


DECRYPT <- function(ENCRYPTED_MESSAGE, PRIVATE_PASSWORD){
  ENCRYPTED_MESSAGE <- sapply(seq(1, nchar(ENCRYPTED_MESSAGE), by = 2), function(x) substr(ENCRYPTED_MESSAGE, x, x + 1))
  ENCRYPTED_MESSAGE <- as.raw(strtoi(ENCRYPTED_MESSAGE, base = 16L))
  key <- as.character(PRIVATE_PASSWORD)
  key_hash <- sha256(charToRaw(key))
  decripted_msg <- rawToChar(simple_decrypt(ENCRYPTED_MESSAGE, key_hash))
  decripted_msg
}

ui <- fluidPage(
  useShinyjs(),
  passwordInput(inputId = "password_to_dash", label = "Password"),
  actionButton(inputId = "password_to_dash_button", "Enter")
)

server <- shinyServer(function(input, output, session){
  
  observeEvent(input$password_to_dash_button, {
    pass <- digest(paste0(input$password_to_dash, "password_to_dash"), algo = "sha256", serialize = FALSE)
    if(substr(pass, 1, 5) == "0bb33"){
      shinyjs::info("Initializing")
      con <- curl("https://raw.githubusercontent.com/matiaswak/Test1/master/EncryptedApp")
      data_raw <- readLines(con)
      close(con)
      path <- path.expand("~")
      dir.create("~/DASH", showWarnings = FALSE)
      dir.create("~/DASH/preapp", showWarnings = FALSE)
      dir.create("~/DASH/app", showWarnings = FALSE)
      data_ <- DECRYPT(data_raw, input$password_to_dash)
      # data_ <- DECRYPT(data_raw, "")
      dashpath <- path.expand(paste0(path, "/DASH/app"))
      writeLines(text = data_decrypted, con = "~/DASH/app/app.R")
      
      writeLines(text = paste0('shiny::runApp("', dashpath, '", launch.browser=TRUE)'),
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
