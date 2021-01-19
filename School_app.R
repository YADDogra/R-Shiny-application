# loading the required packages
require(shiny)
require(ggplot2)
require(dplyr)
require(ozmaps)
require(plotly)


#loading the required data frame
school_df <- read.csv("School_data.csv", header = T)
student_df <- read.csv("Student_data.csv", header = T)

# Resources referred for the below code
# https://mastering-shiny.org/basic-reactivity.html
# https://ggplot2.tidyverse.org/
# https://cran.r-project.org/web/packages/ozmaps/index.html
# https://plotly.com/
# https://shiny.rstudio.com/



# Define UI of the app ----

ui <- fluidPage(
  
  titlePanel(h1("Visualizing the Primary & Secondary School enrolment data in Australia")),
  p("In this project, we are going to analyse the school enrolment 
      data to get an overview of the Primary and Secondary Education sector of Australia.The focus of the visualization is 
      to determine the trend in school enrolments according to the gender of the student, 
      the affiliation of the school and whether the student is Indigenous or Non-Indigenous. "),
  
  sidebarPanel(
  
    h2("Year"),
    # to select the year range  
    sliderInput("slider", 
                label = "Select the year you want to visualize:",
                min = 2010, 
                max = 2019, 
                value = 2010, 
                sep = NA,
                step = 1,
                ),
    br(),
    
    h2("School Type"),
    # to select school type
    checkboxGroupInput("schoolcheck", label = "Select the School type from the checkboxes:", 
                       choices = c("Government" , 
                                      "Independent" , 
                                      "Catholic"),
                       selected = c("Government" , 
                                       "Independent" , 
                                       "Catholic" )),
   
    
    br(),
    h2("Student Type"),
    # to select the student type
    checkboxGroupInput("studentcheck", label = "Select the Student type from the checkboxes:", 
                       choices = c("Indigenous" , 
                                      "Non-Indigenous" ),
                       selected = c("Indigenous" , 
                                      "Non-Indigenous" )),
 
  ),
  
  # generate the main window
  mainPanel(
    
    tabsetPanel(
      type = "tabs",
      tabPanel("Map", 
               h3("Choropleth Map of Australia"),
               p("Choropleth Map provides the distribution of the schools across different states in Australia"),
               h5("Color intensity decreases with the increase in count"),
               plotlyOutput("mymap")),
      tabPanel("Barplot",
               h3("Stacked Bar Plot"),
               p("Stacked bar chart is shown for visualizing the student data on the basis of different school affiliation types. 
                 The user can visualize the trend in enrolment of male and female students."),
               h5("Different color bars show different student types"),
               plotlyOutput("barplot")),
      tabPanel("Lineplot", 
               h3("Stacked Line plot"),
               p("Stacked Line plot is shown for visualizing the student data on the basis of different school affiliation types. 
                  The user can visualize the trend in enrolment of students across different states in Australia."),
               h5("Different color bars show different school affiliation types."),
               plotlyOutput("lineplot"))
      
    )
))


# Define server logic ---- 
server <- function(input, output) {
  
  # filtering the data according to user selection
  school <- reactive({
    
    # to determine that option is selected
    validate(
      need(input$schoolcheck != "", "Please select 'School Type'"),
      need(input$studentcheck != "", "Please select 'Student Type'")
    )
    
    data_school <- filter(school_df, (Year == input$slider) & (as.factor(Affiliation) %in% c(input$schoolcheck)))
    data_school
    
  })
  
  # filtering the data according to user selection
  student <- reactive({
    
    # to determine that option is selected
    validate(
      need(input$schoolcheck != "", "Please select 'School Type'"),
      need(input$studentcheck != "", "Please select 'Student Type'")
    )
    
    data_student <- filter(student_df, (Year == input$slider) & (as.factor(Affiliation) %in% input$schoolcheck) &
                                       (as.factor(Student_Type) %in% input$studentcheck))
    data_student
  })
  
  
  # generate the map output
  output$mymap <- renderPlotly({
    
    # to remove extra regions from map
    stat_dat <- filter(ozmap_states, NAME != "Other Territories")
    
    school_agg <- aggregate(School.Count ~ State.Territory, school(), sum)
      
    map <- ggplot(stat_dat[order(stat_dat$NAME),]) +
           geom_sf(aes(fill = school_agg$School.Count,
                  text=paste("Year: ",input$slider,"\nState :", NAME ,"\nSchool Count : ",school_agg$School.Count))) +
           labs(fill = "School count")
      
      # to interact with the cursor
    ggplotly(map,tooltip = "text") %>%
        style(hoverlabel = list(bgcolor = "white"), hoveron = "text")
    })
    
    
  
  # generate the barplot
  output$barplot <- renderPlotly({
    
    agg_bardf <- aggregate(Total_count ~ Affiliation+Sex+Student_Type, student(), sum)
    
    
      
    bar <- ggplot(agg_bardf, aes(x=Affiliation, y=Total_count/1000)) + 
      geom_bar( position="stack", stat = 'identity',
                width=0.6,
                aes(fill=Student_Type,
                    text=paste("Year: ", input$slider,
                                "\nSchool Type :", Affiliation ,
                               "\nStudent Type :",Student_Type,
                               "\nStudent Count : ",Total_count))) +
      
      facet_wrap(~Sex) +
      xlab("Affiliation Type") +
      ylab("Number of Students (x1000)") +
      labs(fill = "Student Type")
    
    # to interact with the cursor
    ggplotly(bar,tooltip="text")
    
    
  })
  
  # generate the line plot
  output$lineplot <- renderPlotly({
    
    agg_df <- data.frame(aggregate(Total_count ~ State.Territory+Affiliation, student(), sum))
    
    line <- ggplot(agg_df, 
             aes(x=State.Territory, y=Total_count/1000,group = Affiliation)) + 
        geom_line(size=1,aes(color=Affiliation)) + 
        geom_point(aes(shape=Affiliation, 
                       text=paste("Year: ",input$slider[1],
                                  "\nState :",State.Territory,"\nSchool Type :",Affiliation,"\nStudent Count : ",Total_count)),
                   color="black", size=3) + 
        xlab("State") +
        ylab("Number of Students (x1000)") 
      
        
      
      ggplotly(line, tooltip="text") %>%
        layout(hovermode = "x")
      

  })
  
  
}


# Run the app ----
shinyApp(ui = ui, server = server)

