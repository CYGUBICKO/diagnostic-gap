library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)

gbm_train <- train(model_form
	, data = train_df
	, method = "gbm"
	, distribution = ifelse(problem_type=="classification", "bernoulli", "gaussian")
	, metric = performance_metric
	, tuneGrid = gbm_tunegrid
	, trControl = training_control
)
gbm_train
model_name_ = "Gradient boosting"
gbm_train$model_name_ = model_name_

saveVars(gbm_train
	, test_df
	, train_df
	, outcome_var
	, report_metric
	, problem_type
	, preprocess_steps
)
