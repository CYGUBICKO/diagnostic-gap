library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)

ols_train <- train(model_form
	, data = train_df
	, method = ifelse(problem_type=="classification", "glm", "lm")
	, metric = performance_metric
	, family = ifelse(problem_type=="classification", "binomial", "gaussian")
	, trControl = training_control
)
print(ols_train)
model_name_ = ifelse(problem_type=="classification", "logistic", "linear")
ols_train$model_name_ = model_name_


saveVars(ols_train
	, train_df
	, test_df
	, outcome_var
	, report_metric
	, problem_type
	, preprocess_steps
)
