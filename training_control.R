library(shellpipes)
library(caret)

loadEnvironments()

set.seed(seed)

problem_type = model_params$problem_type
performance_metric = ifelse(problem_type=="classification", model_params$classification_metric, model_params$regression_metric)
report_metric = ifelse(problem_type=="classification", model_params$classification_report_metric, model_params$regression_report_metric)

train_df = train_recipe$df_processed
test_df = test_recipe$df_processed

training_control <- trainControl(method = model_params$cv_method
	, repeats = model_params$cv_repeats
	, number = model_params$folds
	, search = model_params$cv_search
	, classProbs = ifelse(problem_type=="classification", TRUE, FALSE)
	, summaryFunction = ifelse(problem_type=="classification", twoClassSummary, defaultSummary)
	, seeds = NULL
)

saveVars(training_control
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
