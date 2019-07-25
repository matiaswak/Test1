dashboardPage(skin = "black",
              dashboardHeader(title = "Crypto Dash"
                              # dropdownMenuOutput("messageMenu"), dropdownMenuOutput("taskMenu")
              ),
              dashboardSidebar(
                sidebarMenu(
                  menuItem(text = "Home", tabName = 'home', icon = icon('home'))
                )
              ),
              
              # CONTENIDO ####
              dashboardBody(
                useShinyjs(),
                useShinyalert(),
                
                tabItems(
                  tabItem(tabName = "home",
                          "HOME"
                  )
                )
              ) 
) 

