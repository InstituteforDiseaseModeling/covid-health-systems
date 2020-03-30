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
The information in the [Documentation File] is broken out into five sections, which will help you through the process. 
1.	How to acquire the software you need to install in order to run the model.
2.	How to access and download the model onto your computer.
3.	How to set up and run the model (in SIMUL8).
4.	How to open and run the analysis script (in R Studio).
5.	How to review the results.


## Authors
* Brittany Hagedorn

---

![Creative Commons License][license-img]

This work is licensed under a [Creative Commons Attribution-ShareAlike
4.0 International License][license].


<!-- References -->
[ProjectTemplate]: http://projecttemplate.net
[Simul8]: https://www.simul8.com/

[contributing guide]: ./CONTRIBUTING.md
[Running the model]: ./docs/model.md
[analysis]: ./docs/analysis.md

[license]: ./LICENSE
[license-img]: https://i.creativecommons.org/l/by-sa/4.0/88x31.png

