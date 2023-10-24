library(shellpipes)
library(dplyr)

loadEnvironments()

if (default_params) {
	mlp_tunegrid <- NULL
} else {
	mlp_param <- models_hyperparameters$mlp
	layer1 <- mlp_param$layer1
	layer2 <- mlp_param$layer2
	layer3 <- mlp_param$layer3
	decay <- mlp_param$decay

	mlp_tunegrid <- expand.grid(
		layer1 = c(0, seqx(layer1))
		, layer2 = seqx(layer2)
		, layer3 = seqx(layer3)
		, decay = decay
	)
}

saveVars(mlp_tunegrid
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



