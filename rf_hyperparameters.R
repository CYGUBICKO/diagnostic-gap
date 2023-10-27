library(shellpipes)

loadEnvironments()

rf_param <- models_hyperparameters$rf
num.trees <- rf_param$num.trees
regularization.factor <- rf_param$regularization.factor

if (default_params) {
	rf_tunegrid <- NULL
} else {
	mtry <- rf_param$mtry
	min.node.size <- rf_param$min.node.size
	splitrule <- rf_param$splitrule
	rf_tunegrid <- expand.grid(
		mtry = floor(seq(mtry[1], mtry[2], length.out=mtry[3]))
		, splitrule = splitrule
		, min.node.size = min.node.size
	)
}

saveVars(rf_tunegrid
	, num.trees
	, regularization.factor
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
