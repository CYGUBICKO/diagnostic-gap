library(shellpipes)
library(caret)

loadEnvironments()

set.seed(seed)

problem_type = model_params$problem_type
performance_metric = ifelse(problem_type=="classification", model_params$classification_metric, model_params$regression_metric)
report_metric = ifelse(problem_type=="classification", model_params$classification_report_metric, model_params$regression_report_metric)

train_df = train_recipe$df_processed
test_df = test_recipe$df_processed
preprocess_steps = train_recipe$preprocess_steps
preprocess_steps$removed_vars = NULL
preprocess_steps$project_description = project_description
preprocess_steps$train_test_ratio = paste0(scales::percent(train_test_ratio), " of the data was used as training data while the rest as test data.")

training_control <- trainControl(method = model_params$cv_method
	, repeats = model_params$cv_repeats
	, number = model_params$folds
	, search = model_params$cv_search
	, classProbs = ifelse(problem_type=="classification", TRUE, FALSE)
	, summaryFunction = ifelse(problem_type=="classification", twoClassSummary, defaultSummary)
	, seeds = NULL
)
preprocess_steps$cv_method = paste0(model_params$cv_method, " resampling method was used in model training.")
preprocess_steps$folds = paste0(model_params$folds, " folds cross-validation was used.")
preprocess_steps$cv_repeats = paste0(model_params$cv_repeats, " repeats during cross-validation.")
preprocess_steps$cv_search = paste0(model_params$cv_search, " parameter search was used to determine hyperparameters.")
preprocess_steps$metrics = paste0(performance_metric, " was used as a performance metric during cross-validation while ", report_metric, " was used to compared the performance of models and choose the best performing one.")

preprocess_steps
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
	, preprocess_steps
)
