# How Much Are Manager Getting Paid Around the World?

![img](https://images.pexels.com/photos/392018/pexels-photo-392018.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1)
Photo by Vojtech Okenka: https://www.pexels.com/photo/person-holding-apple-magic-mouse-392018/


## Motivation

Target audience: Employees (managers or otherwise) who might be curious how much managers in their field are getting paid.

Despite the rise in popularity of sites such as Glassdoors, disclosing salary information is still often consider taboo. The lack of transparency around salary and compensation not only prevents people from knowing whether they are being compensated fairly for their work, but can often have a disproportionate negative effect on historically disadvantaged/marginalized groups.

## Data Source

The raw data used in this project come from the [Ask a Manager](https://www.askamanager.org/) blog run by Alison Green. The survey collected around 24,000 anonymous participant responses on questions such as their salary/compensation, location, years of relevant experience, as well as demographic information (e.g., age, race, gender, etc.). 

The current version of the survey used was compiled by the [tidytuesday](https://github.com/rfordatascience/tidytuesday) community on GitHub. The data are loaded externally from the raw data posted on GitHub. Additional information on the data can be found [here](https://github.com/rfordatascience/tidytuesday). 

## App Description

The app is live on [shinyapp.io](https://monazhu.shinyapps.io/ManagerSalary/)!

![](img/demo.mp4)


## Installation Instructions

In order to run the app locally, you will need to ensure that [R](https://cran.r-project.org) and [RStudio](https://posit.co/download/rstudio-desktop/) are installed on your local machine.

1. Clone this repository onto your local machine. See [here](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) for more details if you are not familiar with the process.

2. Double click on the `.RProj` file in the root directory of the project folder.

3. Once RStudio is open, type `renv::activate()` to ensure that the R environment is active.

4. Navigate to the `R` folder in the project directory and open `app.R`. On the top right hand corner of the script panel, click `Run App`.




