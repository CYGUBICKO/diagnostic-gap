library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)

mlp_train <- train(model_form
	, data = train_df
	, method = "mlpWeightDecayML"
	, metric = performance_metric
	, tuneGrid = mlp_tunegrid
	, trControl = training_control
)
mlp_train
model_name_ = "Multi-layer neural network"
mlp_train$model_name_ = model_name_

saveVars(mlp_train
	, test_df
	, train_df
	, outcome_var
	, report_metric
	, problem_type
)
