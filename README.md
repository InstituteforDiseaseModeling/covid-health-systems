# covid-health-systems

Welcome to IDM's COVID-19 Health Systems model!


## Setup

### Pre Requisites

1. Access to [Simul8] Professional
2. R 3.6+
3. (Optional) RStudio

### R Project Setup

1. Install [ProjectTemplate] for loading the project:

   ```R
   install.packages("ProjectTemplate")
   ```
2. Install the packages required to run the analysis scripts:

   ```R
   install.packages(c('here', 'ggplot2', 'plyr', 'dplyr', 'scales', 'readxl', 'reshape2', 'gridExtra', 'RColorBrewer', 'viridis'))
   ```


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

## Getting Started

[Running the model]

[Analysis]


## Contributing

See our [contributing guide].


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

