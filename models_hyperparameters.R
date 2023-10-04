library(shellpipes)
library(readxl)
library(dplyr)

loadEnvironments()

file_name <- fileSelect(ext="xlsx", pat="models_hyperparameters")
sheets <- excel_sheets(file_name)
models_hyperparameters <- sapply(sheets, function(x){
	readxl::read_excel(file_name, sheet = x)
}, simplify = FALSE)

models_hyperparameters <- get_excel_param_all(models_hyperparameters)

saveVars(models_hyperparameters
	, training_control
	, problem_type
	, performance_metric
	, report_metric
	, train_df
	, test_df
	, seed
	, model_form
	, outcome_var
	, descriptive_plots
	, model_params
	, check_missing
	, factor2numeric
	, get_excel_param
	, get_excel_param_all
	, get_file_ext
	, labelall
	, labelsfun
	, na_codes
	, preprocessFun
	, seqx
)
