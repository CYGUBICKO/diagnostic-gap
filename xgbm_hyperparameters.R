library(shellpipes)

loadEnvironments()

xgbm_param <- models_hyperparameters$xgbm
lambda <- xgbm_param$lambda
alpha <- xgbm_param$alpha

if (default_params) {
	xgbm_tunegrid <- NULL	
} else {
	nrounds <- xgbm_param$nrounds
	eta <- xgbm_param$eta
	gamma <- xgbm_param$gamma
	max_depth <- xgbm_param$max_depth
	min_child_weight <- xgbm_param$min_child_weight
	colsample_bytree <- xgbm_param$colsample_bytree
	subsample <- xgbm_param$subsample
	xgbm_tunegrid <- expand.grid(
		nrounds = seqx(nrounds)
		, eta = seqx(eta)
		, gamma = gamma
		, max_depth = max_depth
		, min_child_weight = min_child_weight
		, colsample_bytree = colsample_bytree
		, subsample = subsample
	)
}

saveVars(xgbm_tunegrid
	, lambda
	, alpha
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
)



