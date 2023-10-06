library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)

lasso_train <- train(model_form
	, data = train_df
	, method = "glmnet"
	, metric = performance_metric
	, family = ifelse(problem_type=="classification", "binomial", "gaussian")
	, tuneGrid = lasso_tunegrid
	, trControl = training_control
)
lasso_train

saveVars(lasso_train
	, test_df
	, train_df
	, outcome_var
	, report_metric
	, problem_type
)
