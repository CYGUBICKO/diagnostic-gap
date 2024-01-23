library(shellpipes)
library(dplyr)

loadEnvironments()

if (default_params) {
	dt_tunegrid <- NULL
} else {
	dt_param <- models_hyperparameters$dt
	cp <- dt_param$cp
	dt_tunegrid <- expand.grid(
		cp = seqx(cp)
	)
}

saveVars(dt_tunegrid
	, performance_metric
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
	, preprocess_steps
)



