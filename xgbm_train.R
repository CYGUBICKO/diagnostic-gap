library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)


xgbm_train <- train(model_form
	, data = train_df
	, method = "xgbTree"
	, metric = performance_metric
	, tuneGrid = xgbm_tunegrid
	, trControl = training_control
	, lambda = lambda
	, alpha = alpha
)
xgbm_train

saveVars(xgbm_train
	, test_df
	, train_df
	, outcome_var
	, report_metric
)
