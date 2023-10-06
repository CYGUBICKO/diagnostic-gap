library(shellpipes)
library(foreach)
library(ranger)
library(gbm)
library(xgboost)
library(naivebayes)
library(caret)

loadEnvironments()

nreps <- 100
varimp_df <- sapply(ls(pattern = "_train$"), function(x){
	modname <- gsub("\\_train", "", x)
	x <- get(x)
	out <- get_vimp(x
		, type="perm"
		, newdata=train_df
		, outcome_var = outcome_var
		, problem_type=problem_type
		, estimate = "quantile"
		, nrep=nreps
		, modelname=modname
		, parallelize=FALSE
	)
	return(out)
}, simplify=FALSE)

varimp_all_df <- do.call("rbind", varimp_df)

saveVars(varimp_all_df
	, plot.varimp
)
