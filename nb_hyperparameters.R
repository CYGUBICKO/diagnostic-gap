library(shellpipes)
library(dplyr)

loadEnvironments()

if (default_params) {
	nb_tunegrid <- NULL
} else {
	nb_param <- models_hyperparameters$nb
	laplace <- nb_param$laplace
	usekernel <- nb_param$usekernel
	adjust <- nb_param$adjust
	nb_tunegrid <- expand.grid(
		laplace = laplace
		, usekernel = usekernel==1
		, adjust = adjust
	)
}

saveVars(nb_tunegrid
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



