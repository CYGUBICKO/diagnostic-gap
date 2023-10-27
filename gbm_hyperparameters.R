library(shellpipes)

loadEnvironments()

if (default_params) {
	gbm_tunegrid <- NULL
} else {
	gbm_param <- models_hyperparameters$gbm
	n.trees <- gbm_param$n.trees
	interaction.depth <- gbm_param$interaction.depth
	shrinkage <- gbm_param$shrinkage
	n.minobsinnode <- gbm_param$n.minobsinnode
	gbm_tunegrid <- expand.grid(
		n.trees = n.trees 
		, interaction.depth = interaction.depth
		, shrinkage = shrinkage
		, n.minobsinnode = n.minobsinnode
	)
}

saveVars(gbm_tunegrid
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
