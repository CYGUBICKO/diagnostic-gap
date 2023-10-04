library(shellpipes)

loadEnvironments()

svm_param <- models_hyperparameters$svm
C <- svm_param$C
svm_tunegrid <- expand.grid(
	C = seqx(C)
)

saveVars(svm_tunegrid
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



