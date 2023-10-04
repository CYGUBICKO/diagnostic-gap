library(shellpipes)

loadEnvironments()

enet_param <- models_hyperparameters$enet
alpha <- enet_param$alpha
lambda <- enet_param$lambda
enet_tunegrid <- expand.grid(
	.alpha = seq(alpha[1], alpha[2], length.out=alpha[3])
	, .lambda = exp(seq(lambda[1], lambda[2], length.out=lambda[3]))
)


saveVars(enet_tunegrid
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
