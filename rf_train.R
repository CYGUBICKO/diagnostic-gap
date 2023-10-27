library(shellpipes)
library(caret)

loadEnvironments()

set.seed(seed)

rf_train <- train(model_form
	, data = train_df
	, method = "ranger"
	, metric = performance_metric
	, tuneGrid = rf_tunegrid
	, trControl = training_control
	, num.trees = num.trees
	, importance = 'permutation'
	, regularization.factor = regularization.factor
	, regularization.usedepth = FALSE
	, save.memory=TRUE
)
print(rf_train)
model_name_ = "Random forest"
rf_train$model_name_ = model_name_

saveVars(rf_train
	, test_df
	, train_df
	, outcome_var
	, problem_type
	, preprocess_steps
)
