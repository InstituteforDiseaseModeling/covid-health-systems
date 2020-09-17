# covid-health-systems

Welcome to IDM's COVID-19 Health Systems model. This model is intended to make projections for the number of AAC and ICU hospital beds needed for COVID-19 patients and to estimate the patient waiting
time for those beds.

[TOC numbered]: # ""

1. [Project architecture](#project-architecture)
1. [Installation](#installation)
   1. [Install prerequisites](#install-prerequisites)
      1. [SIMUL8 Professional](#simul8-professional)
      1. [R statistical package](#r-statistical-package)
      1. [RStudio](#rstudio)
   1. [Install the Health Systems model](#install-the-health-systems-model)
1. [Set up and run the Health Systems model](#set-up-and-run-the-health-systems-model)
1. [Open and run the R script analysis](#open-and-run-the-r-script-analysis)
1. [Review results](#review-results)
1. [Appendix 1 – Default parameter references](#appendix-1--default-parameter-references)
   1. [Population age mix](#population-age-mix)
   1. [Acuity by age](#acuity-by-age)
   1. [Length of stay](#length-of-stay)
   1. [Proportion of stay in ICU](#proportion-of-stay-in-icu)
   1. [Discharge delay](#discharge-delay)
   1. [Mortality](#mortality)
1. [Appendix 2 – Results files](#appendix-2--results-files)
   1. [Inputs](#inputs)
   1. [Inpatient bed occupancy](#inpatient-bed-occupancy)
   1. [Inpatient bed placement delays](#inpatient-bed-placement-delays)
   1. [Number of patients receiving care](#number-of-patients-receiving-care)
1. [Authors](#authors)
1. [Disclaimer](#disclaimer)


## Project architecture

The project structure uses a variation of the [ProjectTemplate] project structure.

```bash
├── config/
│   └── global.dcf	# Default configuration for the project
├── data/			# Input data
├── docs/			# Additional project documentation
├── lib/
│   ├── globals.R 	# Project-level configuration and variables
│   └── helpers.R	# Project-level functions
├── logs/			# Logs
├── model/			# Simul8 models and analysis summary script
├── output/			# Simul8 outputs
├── reports/		# Reports, graphs, plots, and any other re-generateable documents
├── src/			# Analysis R scripts
```

## Installation

The following steps walk through installation of prerequisite software and IDM's COVID-19 Health Systems model.

### Install prerequisites

You need the following software to run the COVID-19 Health Systems model:

* SIMUL8 Professional, discrete event simulation software.
* R, a free statistical program to run and analyze the model results using the provided scripts.
* (Optional) RStudio, a useful user interface for the R program.

#### SIMUL8 Professional

1. Contact sales@SIMUL8.com to get a license for SIMUL8 Professional.
2. In your message, indicate that you will be working on COVID-19. SIMUL8 is providing free 90-day licenses for analysts doing COVID-19 work.
3. Follow their instructions for installation.
4. If you run into difficulties, see their [help pages](https://support.simul8.com/) or contact [support@SIMUL8.com](mailto:support@SIMUL8.com).
5. Open and close the program once before opening the model file; this will override the automatically-generated new installation orientation.

#### R statistical package

1. Go to the [R website](https://www.r-project.org/).
2. Under **Download** > **CRAN**, select the mirror closest to your location.
3. Download R version 3.6 or higher for your operating system and run the installer.
4. If you run into difficulties, see their [help pages](https://www.r-project.org/help.html).
5. Additionally, download and install [Rtools 3.5](https://cran.r-project.org/bin/windows/Rtools/Rtools35.exe) so that any packages not available for Windows can be compiled on your local system.

#### RStudio

1. Go to the [RStudio website](https://rstudio.com/products/rstudio/download/).
2. Download the free open source version of RStudio Desktop and run the installer.
3. Open the R Console to install required packages. This can be the Windows R GUI, the command-line version, or the RStudio console.
4. Install [ProjectTemplate] for loading the project:

   ```R
   install.packages("ProjectTemplate")
   ```
5. Set your working directory to repository directory and load the project. This will install any additional packages needed to run the analysis scripts.

   ```R
   setwd("C:/path/to/covid-health-systems")
   ```

6. If you run into difficulties, see their [support pages](https://support.rstudio.com/hc/en-us).


### Install the Health Systems model

1. Clone or download the code from this repository into a convenient location on your computer.

## Set up and run the Health Systems model

1. Launch SIMUL8 and under **File** > **Open** > **Browse Computer** navigate to the model/model.S8 file to open the COVID-19 Health Systems model.

2. The first time you open this model, it will be preset with default values. You can use the **+/-** in the bottom right of the program if you need to adjust to fit your monitor.

   **Note:** If you make changes and then save the file, it will overwrite the defaults permanently so be cautious until you get comfortable with the model structure. You are able to save file
   versions or to manage changes through GitHub, just like any other document or script file. If you want to return to the original and did not keep a copy, you can simple download the files from
   GitHub again.

3. Use the three blue buttons (**Settings**, **Run**, and **Export**) on the left side of the screen to manage the simulation.

   **Warning:** Do not use the buttons on the upper ribbon, as they are not necessary and you run the risk of unintentional modifications to the model, which may change the results in unknown ways and
   result in incorrect projections. If you are curious about how to build a new model in SIMUL8, please see their [online tutorials](https://support.simul8.com/), but that is not necessary for using
   this model.

   a. **Settings** – Enter assumptions and input your desired modeling scenarios.
   + The settings dialog boxes walk you through all of the parameters that need to be reviewed and set prior to starting the simulation run. For details on each of the parameters built into the model, see this [model walkthrough video](https://youtu.be/AH3P_JmKQeY). Source data for the default parameters are listed in the
     appendix of this document. There are two ways to run the model:

     * Unlimited: Estimates how many inpatient beds you will need in order to serve your patient population.
     * Limited bed capacity: Projects the realistic experience for your hospital(s), given the realistically available bed capacity and the selected outbreak scenario(s).

   + After you click **OK** in the final dialog box, SIMUL8 will verify that all of the parameter values that you set are valid. For example, it checks that you didn't accidentally enter a negative
     number for beds available and that the total acuity mix sums to 100%. If there is a problem, the model will alert you with a pop-up box and you must resolve the issue before running the model.

   b. **Run** – Once the settings are configured, use the **Run** button to launch the model.
   + The model will begin running and you will see a simulation "Run number" and "Out of" number. This tells you how many iterations have been completed so far out of how many total runs will be
     completed. As the model runs, you will see the clock (in the upper left) tick forward. Once the model is finished running, it will alert you that the results are ready for export. Click **OK**.

   c. **Export** – Once the model has finished running, export the results to CSV files.
   + Click **Export**. A dialog box will appear that asks you to name the results and to input a save destination. We recommend using a unique name that includes the date and a understandable
     description, particularly if you think that you may rerun the model over time. This name will be used in the R script to determine which files to analyze and is also useful for you in the future
     to remember which model results were related to what scenario you were analyzing at the time.

     To set the save location, you must type in the file folder directly. You may optionally leave the program and open an explorer window, navigate to the folder where all of your model files reside,
     and then copy the location address from the navigation bar at the top of the explorer window. Click **OK** and the results files will be exported to CSV for use in the R analysis script.

## Open and run the R script analysis

1. Navigate to the folder where you saved the model and analysis files when you downloaded them from GitHub.
2. Double-click to open the R script; it should automatically open in RStudio.
3. Set the input results name (INPUTSET). Set this text description to be identical to the one set in the SIMUL8 **Export** dialog box.
4. Press **Ctrl+A** to select the full script.
5. Press **Ctrl+Enter** or the **Run** button in the upper right to run the full script. It may take a few minutes to complete the analysis, depending on how many repetitions of the model you ran.


If you have a preferred alternative to R for statistical analysis, you have the option to load the CSV files which contain the model results into whatever program you choose. However, the analytics
script included in this repository will not be usable in a different program. We recommend that you run the analysis script as in the R program first and then evaluate your needs for reanalysis. If
you would like to learn more about scripting in R, DataCamp offers an [Introduction to R course](https://www.datacamp.com/courses/free-introduction-to-r).

For more information on the raw results CSV files, see Appendix 2.

## Review results

Once you have run the R script, your summary results will be saved to the same folder as the rest of your files. There will be both graphical PDF summaries and also several aggregated CSV files that
report out confidence intervals.

## Appendix 1 – Default parameter references

### Population age mix

We utilize the United States population age bands per the [US Census Bureau](https://www.census.gov/newsroom/press-releases/2018/pop-characteristics.html).

### Acuity by age

We utilize data released by the CDC as part of the [morbidity and mortality weekly report](https://www.cdc.gov/mmwr/volumes/69/wr/mm6912e2.htm) on March 18, 2020 for inpatient and ICU utilization by
age band for symptomatic cases in the United States. Acuity by age is applied to the population age mix (above) and result in a weighted average of 18.4% of infections requiring hospitalization and
5.3% of infections resulting in severe illness that requires an ICU bed as part of an inpatient stay.

### Length of stay

There is still a high degree of uncertainty about the healthcare needs of COVID-19 patients in the United States, since the clinical care protocols are rapidly evolving and will depend substantially
on the comorbidities and level of opportunistic infections that are seen in a given patient population. With that in mind, we have triangulated between several published sources in order to estimate
parameters that fit reasonably well with what is currently known.

Length of stay estimates are highly variable. We extrapolated from those reported by [Bi et al. (2020)](https://www.medrxiv.org/content/10.1101/2020.03.03.20028423v1.full.pdf),
[Yang et al. (2020)](https://www.medrxiv.org/content/10.1101/2020.02.28.20028068v1.full.pdf), and [Sanche et al. (2020)](https://www.medrxiv.org/content/10.1101/2020.02.07.20021154v1). Each study uses
different definitions for length of stay, broken out by severity and symptoms.

Collectively, they indicate that severe cases have longer length of stay, and most ICU-bound patients start out in an AAC bed and eventually progress to more severe symptoms that require ICU care. We
reflect this in the model with length of stay for moderate cases of an average of 11 days with standard deviation of 5, and for severe cases of an average of 14 days with a standard deviation of 5. The model
uses a lognormal distribution to model length of stay.

### Proportion of stay in ICU

Based on limited clinical protocol recommendations from [Bouadma et al. (2020)](https://link.springer.com/article/10.1007/s00134-020-05967-x) in combination with expected length of stay, we assume
that for ICU-bound patients, approximately 50% of their length of stay is first in an AAC bed. It is likely that these assumptions will need to be updated as we learn more about care in the United
States.

### Discharge delay

Based on private data provided by Seattle-area hospitals to IDM for modeling COVID bed needs, we assume that 10% of patients will experience delays in discharge due to placement difficulties, and this
has a mean delay of 10 days for those patients, with a standard deviation of +/- 2 days.

### Mortality

Delays in care for those that require hospitalization can have several negative consequences. As has been documented in Italy and South Korea, patients may die at home waiting for a hospital bed to
become available.

Additionally, those that are admitted to the hospital may receive lower quality care; delays in being transferred to the ICU from the ER have been shown to increase mortality rates
(https://www.ncbi.nlm.nih.gov/pubmed/17440421). More generally, overcrowding has been well-studied and it is known to delay care and increase patient mortality
(https://link.springer.com/article/10.1007/s11606-016-3936-3). This is cause for concern, both for COVID-19 and non-COVID patients. In ICU patients, a delay of just six hours has been shown to
increase mortality rates by 27% (https://www.ncbi.nlm.nih.gov/pubmed/17440421).

## Appendix 2 – Results files

There are twelve results files that will export from the model, each with different information included in them. Each file contains the same row-by-row unique identifier in the form of the “run
number”. This allows the results from different files to be matched and combined as needed.

### Inputs

“SS_R_TRIAL_ASSUMPTIONS_TRACKER” – This file contains the key assumptions that went into the model run, such as which epidemiological curve was used, which capacity scenario was used, and the total
number of beds available.

### Inpatient bed occupancy

“SS_R_MEDSURG_OCCUPANCY_END_OF_DAY” – This file reports the daily census of COVID patients in adult acute care (AAC) beds at the end of the day. Each column represents the next day in the simulation
run. Each row represents an individual simulation run.

“SS_R_ICU_OCCUPANCY_END_OF_DAY” – This file reports the daily census of COVID patients in intensive care unit (ICU) beds at the end of the day. Each column represents the next day in the simulation
run. Each row represents an individual simulation run.

“SS_R_INPT_OCCUPANCY_END_OF_DAY” – This file reports the total daily census of COVID inpatients at the end of the day, including both AAC and ICU. Each column represents the next day in the simulation
run. Each row represents an individual simulation run.

### Inpatient bed placement delays

“SS_R_INPT_Q_TIME_NONICU_BY_DAY” – This file reports the mean number of minutes that a COVID patient waited to be placed in an inpatient bed, due to lack of availability of beds when they arrived to
the hospital. The daily value includes each patient who was placed into a bed on a given day. For example, if a patient arrived on day 8 and was placed on day 9, their wait time would be averaged into
the day 9 reporting. Each column represents the next day in the simulation run. Each row represents an individual simulation run.

“SS_R_INPT_Q_TIME_ICU_ELIGIBLE_BY_DAY” – This file reports the mean number of minutes that an acuity 5 (i.e. ICU-eligible) COVID patient waited to be placed in an inpatient bed, due to lack of
availability of beds when they arrived to the hospital. The daily value includes each patient who was placed into a bed on a given day. For example, if a patient arrived on day 8 and was placed on day
9, their wait time would be averaged into the day 9 reporting. Each column represents the next day in the simulation run. Each row represents an individual simulation run.

“SS_R_INPT_Q_CONTENTS_END_OF_DAY” – This file reports the total number of patients waiting for an inpatient bed due to lack of availability at the end of each day. Each column represents the next day
in the simulation run. Each row represents an individual simulation run.

### Number of patients receiving care

“SS_R_OUTCOME_COUNTS” – This file reports the total number of patients who received each type of care over the duration of the simulation run.

“SS_R_OUTPATIENT_COMPLETED_BY_DAY” – This file reports the number of patients who received outpatient care on a given day. Each column represents the next day in the simulation run. Each row
represents an individual simulation run. By default, these are all patients of level acuity 3.

“SS_R_HOME_CARE_COMPLETED_BY_DAY” – This file reports the number of patients who received home care on a given day. Each column represents the next day in the simulation run. Each row represents an
individual simulation run. By default, these are all patients of level acuity 2.

“SS_R_TURNEDAWAY_COMPLETED_BY_DAY” – This file reports the number of patients who were turned away because the inpatient delays for placement exceeded the threshold. Each column represents the next
day in the simulation run. Each row represents an individual simulation run. By default, these are all patients of level acuity 4 or 5 who did not receive inpatient care even though they needed it.

“S_R_CARE_RECEIVED” – This file reports the total number of patients who received each type of care, broken out by where they sought care first. By default, all patients seek the most appropriate care
possible, given their level of acuity.

---

## Authors

* Brittany Hagedorn

---

## Disclaimer

The code in this repository was developed by IDM to support our research in disease transmission and managing epidemics. We’ve made it publicly available under the
[Creative Commons Attribution-ShareAlike 4.0 International License] to provide others with a better understanding of our research and an opportunity to build upon it for their own work.

We make no representations that the code works as intended or that we will provide support, address issues that are found, or accept pull requests. You are welcome to create your own fork and modify
the code to suit your own modeling needs as contemplated under the [Creative Commons Attribution-ShareAlike 4.0 International License].

![Creative Commons License][license-img]


<!-- References -->

[Creative Commons Attribution-ShareAlike 4.0 International License]: ./LICENSE
[ProjectTemplate]: http://projecttemplate.net
[license-img]: https://i.creativecommons.org/l/by-sa/4.0/88x31.png

