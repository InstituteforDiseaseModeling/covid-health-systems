# covid-health-systems

Welcome to IDM's COVID-19 Health Systems model!


## Project Architecture

The project structure is uses a variation of the [ProjectTemplate]
project structure.

```bash
├── config/
│   └── global.dcf	# Default configuration for the project
├── data/			# Input data
├── docs/			# Additional project documentation
├── lib/
│   ├── globals.R 	# Project-level configuration and variables
│   └── helpers.R	# Project-level functions
├── logs/			# Logs
├── model/			# Simul8 Models
├── output/			# Simul8 Outputs
│   ├── example/	## Sample Simul8 output
├── reports/		# Reports, graphs, plots, and any other re-generateable documents
├── src/			# Analysis R scripts
```

## How to Set Up, Run and Analyze Your Bed Capacity Model

The documentation is broken out into five sections, which will help you through the process.
1.	How to acquire the software you need to install in order to run the model.
2.	How to access and download the model onto your computer.
3.	How to set up and run the model (in SIMUL8).
4.	How to open and run the analysis script (in R Studio).
5.	How to review the results.

### Step 1: Acquire Software

You will need to have SIMUL8 Professional (a discrete event simulation software) and R (a statistical program) installed to run and analyze the model results using the pre-written scripts. We would also recommend that you install R Studio, which provides a useful user interface for the R program.

#### SIMUL8 Professional

You can acquire a license for SIMUL8 Professional by contacting sales@SIMUL8.com. As of this document’s writing, the company is providing free 90-day licenses for analysts working on COVID-19 preparation and you should inform them of this in your request. Follow their instructions to install the software on your computer. If you run into difficulties, see their [help pages][https://support.simul8.com/] or contact support@SIMUL8.com.

#### R Statistical Package

R is a free and open-source statistical analysis program. You can download the software from their website at https://www.r-project.org/. Click on <download R> and then select your preferred source, all of which should be freely available and on the same version of the software. If you run into difficulties, see their help pages at https://www.r-project.org/help.html.

#### R Studio

R Studio is a user interface for the R statistical program, with several tiers of software available. You can download the software from their website at https://rstudio.com/products/rstudio/download/. The free desktop version will work fine for these analyses. If you run into difficulties, see their support pages at https://support.rstudio.com/hc/en-us.

### Step 2: How to Acquire the Bed Capacity Model

Next, you will need to download the model itself. You can access this from the GitHub repository here:

____________________________________. You will want to download the entire package and save into a convenient location on your computer. Leave all of the files in one folder location, so that when you export your results files from the model after it has run, they will be automatically available to the R script for analysis.

###  Step 3: Set Up and Run the Bed Capacity Model

Once you have the files available on your computer and the software installed (see Step 1 and 2), you can run the model. The first time that you open the bed capacity model, it will be pre-set with default values.

Please Note: If you make changes and then save the file, it will overwrite the defaults permanently so please be cautious until you get comfortable with the model structure. You are able to save file versions or to manage changes through GitHub, just like any other document or script file. If for some reason you want to return to the original and did not keep a copy, you can simply return to step 2 and re-download the model files.

When you open the model, it will look similar to the screenshot below (Image 1). You can change the zoom using the +/- in the bottom right of the program if you need to adjust to fit your monitor.

You will use the three blue buttons located at the top right of the white model-build area to manage the simulation.

TBD ADD SCREENSHOT

Do not use the buttons on the ribbon above, as they are not necessary and you would run the risk of unintentional modifications to the model, which may change the results in unknown ways and result in incorrect projections. If you are curious about how to build a new model in SIMUL8, please see their online tutorials: https://support.simul8.com/, but that is not necessary for the purposes of this modeling exercise.

There are three buttons on the screen, which allow you to manage the modeling workflow:

    * Settings – This is where you enter assumptions and input your desired modeling scenarios.

    * Run – Once the settings are set up, use the run button to launch the model.

    * Export – Once the model has finished running, export the results to .csv files.

#### 1. Settings

The settings dialogues will walk you through all of the parameters that need to be reviewed and set prior to starting the simulation run. There are two ways to run the model: unlimited or limited bed capacity. The unlimited bed capacity model estimates how many inpatient beds you will need in order to serve your patient population. The limited bed capacity model projects the realistic experience for your hospital(s), given the realistically available bed capacity and the selected outbreak scenario(s).

For details on each of the parameters built into the model and its functionality, please see: _____VIDEO link_______. Source data for the default parameters are listed in the appendix of this document.

There is a series of checks that take place after you select “okay” on the final dialogue, which ensures that any parameters that you have changed in the model are still valid. For example, that you did not accidentally enter a negative number of beds available, or that the total acuity mix totals to 100%. If you select “okay” and there is a problem, the model will alert you with a pop-up box that indicates where the problem is. You will need to resolve this issue before you are able to run the model.

#### 2. Run

Click the run button once all of the settings have been reviewed and set up as you would like. Once you do so, the model will alert you to it’s progress on-screen. You will see a simulation “Run number” and also an “Out of” number. This tells you how many iterations have been completed so far out of how many total runs will be completed. As the model runs, you will see the clock (in the upper left) tick forward. This also tells you that the model is continuing to run and you need to be patient.

You must wait for the model to complete before exporting any results. Once the model is finished running, it will pop up an alert that the results are ready for export. Select okay when this message is displayed and move on to the next step.

#### 3. Export

Once the model completes, it will alert you with a message on-screen. Select okay and then click the Export button. A dialogue will pop up that asks you to name the results and to input a save destination.

Name the results something unique and understandable. Especially if you think that you may re-run the model over time, you will want to use a name such as the date and description. For example “March28-DemoRun”. This name will be used in the R script to determine which files to analyze and is also useful for you in the future to remember which model results were related to what scenario you were analyzing at the time.

To set the save location, you will need to type in the file folder directly. To make this easier, you may optionally leave the program and open an explorer window, navigate to the folder where all of your model files reside, and then copy the location address from the navigation bar at the top of the explorer window.

Select okay and the twelve results files will be exported to .csv for use in the R analysis script.

### Step 4: Open and run the R script analysis

Navigate to the folder where you saved the model and analysis files when you downloaded them from GitHub. Double-click to open the R script; it should automatically open in R Studio.

You must do three things to run the script and produce summary results.

    1. Set the input results name. Set this text description to be identical to the one set in the Export dialogue.

    2. Select the full script. While your cursor is still adjacent to the text you just modified, use the keyboard function of Ctrl+A to select all of the text in the window.

    3. Run the full script. Use Ctrl+Enter or the button indicated in the top right of the image below. It may take a few minutes to complete the analysis, depending on how many repetitions of the model you ran.

TBD ADD SCREENSHOT

If you have a preferred alternative to R for statistical analysis, you have the option to load the .csv files which contain the model results into whatever program you choose. However, the analytics script included in this repository will not be useable in a different program. We recommend that you run the analysis script as it is in the R program first and then evaluate your needs for reanalysis. If you would like to learn more about scripting in R, you can do so at https://www.datacamp.com/courses/free-introduction-to-r or use a search engine to locate a training course.

For more information on the raw results .csv files, see appendix 2.

### Step 5: Review results

Once you have run the R script, your summary results will be saved to the same folder as the rest of your files. There will be both graphical PDF summaries and also several aggregated .csv files that report out confidence intervals.

### Appendix 1 – Default parameter references

#### Population age mix

We utilize the USA’s population age bands per the US census bureau https://www.census.gov/newsroom/press-releases/2018/pop-characteristics.html.

#### Acuity by age

We utilize data released by the CDC as part of the morbidity and mortality weekly report on March 18, 2020 for inpatient and ICU utilization by age band for symptomatic cases in the United States https://www.cdc.gov/mmwr/volumes/69/wr/mm6912e2.htm. Acuity by age is applied to the population age mix (above) and result in a weighted average of 19.3% of infections requiring hospitalization and 5.8% of infections resulting in severe illness that requires an ICU bed as part of an inpatient stay.

#### Length of stay

There is still a high degree of uncertainty about the healthcare needs of COVID-19 patients in the United States, since the clinical care protocols are rapidly evolving and will depend substantially on the comorbidities and level of opportunistic infections that are seen in a given patient population. With that in mind, we have triangulated between several published sources in order to estimate parameters that fit reasonably well with what is currently known.

Length of stay estimates are highly variable. We extrapolated from those reported by Bi et al. (2020) https://www.medrxiv.org/content/10.1101/2020.03.03.20028423v1.full.pdf, Yang et al. (2020) https://www.medrxiv.org/content/10.1101/2020.02.28.20028068v1.full.pdf, and Sanche et al. (2020) https://www.medrxiv.org/content/10.1101/2020.02.07.20021154v1. Each study uses different definitions for length of stay, broken out by severity and symptoms.

Collectively, they indicate that severe cases have longer length of stay, and most ICU-bound patients start out in an AAC bed and eventually progress to more severe symptoms that require ICU care. We reflect this in the model with length of stay for moderate cases of 9.4-12.2 days, and for severe cases 12.5-16.2 days.

#### Proportion of stay in ICU

Based on limited clinical protocol recommendations from Bouadma et al. (2020) https://link.springer.com/article/10.1007/s00134-020-05967-x in combination with expected length of stay, we assume that for ICU-bound patients, approximately 50% of their length of stay is first in an AAC bed. It is likely that these assumptions will need to be updated as we learn more about care in the United States.

#### Discharge delay

Based on private data provided by Seattle-area hospitals to IDM for modeling COVID bed needs, we assume that 10% of patients will experience delays in discharge due to placement difficulties, and this has a mean delay of 10 days for those patients, with a standard deviation of +/- 2 days.

#### Mortality

Delays in care for those that require hospitalization can have several negative consequences. As has been documented in Italy and South Korea, patients may die at home waiting for a hospital bed to become available.

Additionally, those that are admitted to the hospital may receive lower quality care; delays in being transferred to the ICU from the ER have been shown to increase mortality rates (https://www.ncbi.nlm.nih.gov/pubmed/17440421). More generally, overcrowding has been well-studied and it is known to delay care and increase patient mortality (https://link.springer.com/article/10.1007/s11606-016-3936-3). This is cause for concern, both for COVID-19 and non-COVID patients. In ICU patients, a delay of just six hours has been shown to increase mortality rates by 27% (https://www.ncbi.nlm.nih.gov/pubmed/17440421).

### Appendix 2 – Results Files

There are twelve results files that will export from the model, each with different information included in them. Each file contains the same row-by-row unique identifier in the form of the “run number”. This allows the results from different files to be matched and combined as needed.

#### Inputs

“SS_R_TRIAL_ASSUMPTIONS_TRACKER” – This file contains the key assumptions that went into the model run, such as which epidemiological curve was used, which capacity scenario was used, and the total number of beds available.

#### Inpatient Bed Occupancy

“SS_R_MEDSURG_OCCUPANCY_END_OF_DAY” – This file reports the daily census of COVID patients in adult acute care (AAC) beds at the end of the day. Each column represents the next day in the simulation run. Each row represents an individual simulation run.

“SS_R_ICU_OCCUPANCY_END_OF_DAY” – This file reports the daily census of COVID patients in intensive care unit (ICU) beds at the end of the day. Each column represents the next day in the simulation run. Each row represents an individual simulation run.

“SS_R_INPT_OCCUPANCY_END_OF_DAY” – This file reports the total daily census of COVID inpatients at the end of the day, including both AAC and ICU. Each column represents the next day in the simulation run. Each row represents an individual simulation run.

#### Inpatient Bed Placement Delays

“SS_R_INPT_Q_TIME_NONICU_BY_DAY” – This file reports the mean number of minutes that a COVID patient waited to be placed in an inpatient bed, due to lack of availability of beds when they arrived to the hospital. The daily value includes each patient who was placed into a bed on a given day. For example, if a patient arrived on day 8 and was placed on day 9, their wait time would be averaged into the day 9 reporting. Each column represents the next day in the simulation run. Each row represents an individual simulation run.

“SS_R_INPT_Q_TIME_ICU_ELIGIBLE_BY_DAY” – This file reports the mean number of minutes that an acuity 5 (i.e. ICU-eligible) COVID patient waited to be placed in an inpatient bed, due to lack of availability of beds when they arrived to the hospital. The daily value includes each patient who was placed into a bed on a given day. For example, if a patient arrived on day 8 and was placed on day 9, their wait time would be averaged into the day 9 reporting. Each column represents the next day in the simulation run. Each row represents an individual simulation run.

“SS_R_INPT_Q_CONTENTS_END_OF_DAY” – This file reports the total number of patients waiting for an inpatient bed due to lack of availability at the end of each day. Each column represents the next day in the simulation run. Each row represents an individual simulation run.

#### Number of Patients Receiving Care

“SS_R_OUTCOME_COUNTS” – This file reports the total number of patients who received each type of care over the duration of the simulation run.

“SS_R_OUTPAIENT_COMPLETED_BY_DAY” – This file reports the number of patients who received outpatient care on a given day. Each column represents the next day in the simulation run. Each row represents an individual simulation run. By default, these are all patients of level acuity 3.

“SS_R_HOME_CARE_COMPLETED_BY_DAY” – This file reports the number of patients who received home care on a given day. Each column represents the next day in the simulation run. Each row represents an individual simulation run. By default, these are all patients of level acuity 2.

“SS_R_TURNEDAWAY_COMPLETED_BY_DAY” – This file reports the number of patients who were turned away because the inpatient delays for placement exceeded the threshold. Each column represents the next day in the simulation run. Each row represents an individual simulation run. By default, these are all patients of level acuity 4 or 5 who did not receive inpatient care even though they needed it.

“S_R_CARE_RECIEVED” – This file reports the total number of patients who received each type of care, broken out by where they sought care first. By default, all patients seek the most appropriate care possible, given their level of acuity.
x
## Authors
* Brittany Hagedorn

---
## Disclaimer

The code in this repository was developed by IDM to support our research in
disease transmission and managing epidemics. We’ve made it publicly available
under the [Creative Commons Attribution-Noncommercial-ShareAlike 4.0 License][license] to
provide others with a better understanding of our research and an opportunity to
build upon it for their own work. We make no representations that the code works
as intended or that we will provide support, address issues that are found, or
accept pull requests. You are welcome to create your own fork and modify the
code to suit your own modeling needs as contemplated under the Creative Commons
Attribution-Noncommercial-ShareAlike 4.0 License.

![Creative Commons License][license-img]


<!-- References -->
[ProjectTemplate]: http://projecttemplate.net
[Simul8]: https://www.simul8.com/

[contributing guide]: ./CONTRIBUTING.md
[Running the model]: ./docs/model.md
[analysis]: ./docs/analysis.md

[license]: ./LICENSE
[license-img]: https://i.creativecommons.org/l/by-sa/4.0/88x31.png

