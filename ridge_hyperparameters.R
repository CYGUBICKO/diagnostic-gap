library(shellpipes)

loadEnvironments()

ridge_param <- models_hyperparameters$ridge
alpha <- ridge_param$alpha
lambda <- ridge_param$lambda
ridge_tunegrid <- expand.grid(
	.alpha = alpha
	, .lambda = exp(seq(lambda[1], lambda[2], length.out=lambda[3]))
)

saveVars(ridge_tunegrid
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
