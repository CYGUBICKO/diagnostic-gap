library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)

enet_train <- train(model_form
	, data = train_df
	, method = "glmnet"
	, metric = performance_metric
	, family = ifelse(problem_type=="classification", "binomial", "gaussian")
	, tuneGrid = enet_tunegrid
	, trControl = training_control
)
enet_train

saveVars(enet_train
	, test_df
	, train_df
	, outcome_var
	, report_metric
	, problem_type
)
