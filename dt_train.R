library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)

dt_train <- train(model_form
	, data = train_df
	, method = "rpart"
	, metric = performance_metric
	, tuneGrid = dt_tunegrid
	, trControl = training_control
)
dt_train
model_name_ = "Decision trees"
dt_train$model_name_ = model_name_

saveVars(dt_train
	, test_df
	, train_df
	, outcome_var
	, report_metric
	, problem_type
)
