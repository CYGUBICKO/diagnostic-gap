library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)

svm_train <- train(model_form
	, data = train_df
	, method = "svmLinear"
	, metric = performance_metric
	, tuneGrid = svm_tunegrid
	, trControl = training_control
)

saveVars(svm_train
	, test_df
	, train_df
	, outcome_var
	, report_metric
)
