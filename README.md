# covid-health-systems

Welcome to IDM's COVID-19 Health Systems model!

[TOC levels=2-4 numbered hierarchy]: # ""

1. [Project Architecture](#project-architecture)
1. [How to Set Up, Run and Analyze Your Bed Capacity Model](#how-to-set-up-run-and-analyze-your-bed-capacity-model)
1. [Authors](#authors)


## Project Architecture

The project structure is uses a variation of the [ProjectTemplate] project structure.

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
├── reports/		# Reports, graphs, plots, and any other re-generateable documents
├── src/			# Analysis R scripts
```

## How to Set Up, Run and Analyze Your Bed Capacity Model

The [model documentation] is broken out into five sections, which will help you through the process.

1. How to acquire the software you need to install in order to run the model.
2. How to access and download the model onto your computer.
3. How to set up and run the model (in [SIMUL8]).
4. How to open and run the analysis script (in [RStudio]).
5. How to review the results.


## Authors

* Brittany Hagedorn

---

![Creative Commons License][license-img]

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License][license].


<!-- References -->

[ProjectTemplate]: http://projecttemplate.net
[RStudio]: https://rstudio.com
[Simul8]: https://www.simul8.com
[analysis]: ./docs/analysis.md
[license]: ./LICENSE
[license-img]: https://i.creativecommons.org/l/by-sa/4.0/88x31.png
[model documentation]: ./docs/model.docx

