## `R` and `make` pipeline for automl

This repo uses the power of `make` to provide an En-to-End workflow for implementing **classification** and **regression** tasks using R.

### Requirements

- **R** installation 
- **Linux** or **Mac**
- For **Windows**, you can use Windows Subsystem for Linux (WSL) by following the steps outlined in [wsl-setup](https://github.com/CYGUBICKO/wsl-setup).

### Setup

For fresh installation, run (from terminal):

```
make linux_requirements
```

For automatic draft manuscript generation, the pipeline uses [Google Generate AI API](https://developers.generativeai.google/tutorials/text_quickstart). You'll need to create [Google API KEY](https://developers.generativeai.google/tutorials/setup) and then create configuration file `api_config.ini` with the content:

```
[GAI]
api_key = YOUR KEY HERE

```


### Usage

- Open and update Excel files 
	- `data_processing_files.xlsx`
	- `models_hyperparamets.xlsx`

- Once you've updated the Excel files pased on your data and target outcome. From the `command line`:
	- To generate comparison plots based on metric set in the Excel files, run
		- `make auc_plots.Rout.pdf`
	- To generate comparison ROC curves (for classification problems), run
		- `make roc_plots.Rout.pdf`
	- To generate variable importance plot based on top 2 performing models, run:
		- `make varimp_plots.Rout.pdf`
	- To generate a plot ranking all the variables, run:
		- `make varimp_rank_plots.Rout.pdf`

- You can also generate all the required outputs and save them automatically in the `project_name` folder (set in data_processing_files.xlsx), which is automatically added to git, by:
	- `make cp_op`

