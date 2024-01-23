library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)

nb_train <- train(model_form
	, data = train_df
	, method = "naive_bayes"
	, metric = performance_metric
	, tuneGrid = nb_tunegrid
	, trControl = training_control
)
nb_train
model_name_ = "Naive bayes"
nb_train$model_name_ = model_name_

saveVars(nb_train
	, test_df
	, train_df
	, outcome_var
	, report_metric
	, problem_type
)
