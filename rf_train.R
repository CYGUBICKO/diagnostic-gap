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
)
print(rf_train)

saveVars(rf_train
	, test_df
	, train_df
	, outcome_var
)
