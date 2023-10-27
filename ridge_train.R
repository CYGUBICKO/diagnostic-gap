library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)

ridge_train <- train(model_form
	, data = train_df
	, method = "glmnet"
	, metric = performance_metric
	, family = ifelse(problem_type=="classification", "binomial", "gaussian")
	, tuneGrid = ridge_tunegrid
	, trControl = training_control
)
ridge_train
model_name_ = "Ridge"
ridge_train$model_name_ = model_name_

saveVars(ridge_train
	, test_df
	, train_df
	, outcome_var
	, report_metric
	, problem_type
	, preprocess_steps
)
