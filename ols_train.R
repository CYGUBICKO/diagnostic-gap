library(shellpipes)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)

performance_metric
ols_train <- train(model_form
	, data = train_df
	, method = ifelse(problem_type=="classification", "glm", "lm")
	, metric = performance_metric
	, family = ifelse(problem_type=="classification", "binomial", "gaussian")
	, trControl = training_control
)
print(ols_train)

saveVars(ols_train
	, train_df
	, test_df
	, outcome_var
	, report_metric
)
