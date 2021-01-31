## R-Shiny-application
## Visualizing the trend of School Enrolments in Australia
In this project, we are going to analyse the school enrolment data to
get an overview of the Primary and Secondary Education sector of Australia.

The focus of the visualization is to determine the trend in school enrolments according to the
gender of the student, the affiliation of the school and whether the student is Indigenous or
Non-Indigenous.

The following are the set of questions which would help to determine certain patterns and
visualize the current scenario -
- What are the most preferred school affiliation types for enrolment by Male and Female
(both indigenous and non-indigenous) students respectively? 
- Which school affiliation types have maximum number of Aboriginal and Torres Strait
Islander students across different states in Australia?
- Which state has the highest number of schools of different affiliations from 2010-2019?

### Design
The Five design Sheet (FdS) methodology was implemented in this project to come up with
the final visualization design. In this method, the whole design process is divided into five
sheets to clearly visualize each design and the features to be used to make that design
informative for the user.

### Implementation
The **R Shiny** application is developed on **R Studio** platform using the following packages -
- `Shiny` package for webapp development
- `ggplot2` & `plotly` libraries to make visualizations
- `dplyr` for dataframe manipulation
- `ozmaps` for Australian geographical data

To install any of the packges above, use the below given R command - <br>
`install.packages("package_name")`

The user-interface definition involved the addition of **sidebarPanel** of widgets for user
interaction and specification of the **mainPanel** output. 
The widgets used are – 
- `sliderInput` to let the user select the year range they want to visualize 
- `checkboxGroupInput` to let the user specify the school type and the student type they want to visualize with multiple
selection option.

The server definition involved all the data processing to get the desired output visualizations.
The **reactive** functions are used to filter the data according to the user widget interaction.

### User Guide
To completely explore the visualization, user should follow the following steps –

* Select the year the user wants to visualize the data for
* Select the type of School they want to visualize. The check boxes can be selected to
either one school or all of them.
* Select the type of student they want to visualize. The user can select whether, they
want to visualize the data for Indigenous or Non-Indigenous or both type of students.

## Conclusion

While doing this project, I learnt the fundamentals of data wrangling and data exploration
where I could analyse the real-world data from Government provided source to provide insights
into some of the key aspects. As this application was built using R Shiny, there were only
limited type of interactions that were employed, if any person has good knowledge of D3.js
then they can build a more interactive application from the data provided. To address the
knowledge gap, there were a lot of other performance parameters that could have been used to
determine the current state of Primary & Secondary Education sub-sector of Australia. Further
analysis of Tertiary Education sub-sector could be done to determine the type of courses taken
up Australian students after school.
