library(shellpipes)

loadEnvironments()

if (default_params) {
	lasso_tunegrid <- NULL
} else {
	lasso_param <- models_hyperparameters$lasso
	alpha <- lasso_param$alpha
	lambda <- lasso_param$lambda
	lasso_tunegrid <- expand.grid(
		.alpha = alpha
		, .lambda = exp(seq(lambda[1], lambda[2], length.out=lambda[3]))
	)
}

saveVars(lasso_tunegrid
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
