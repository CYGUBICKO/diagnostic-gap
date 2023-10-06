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

saveVars(mlp_train
	, test_df
	, train_df
	, outcome_var
	, report_metric
	, problem_type
)
