library(shellpipes)
library(caret)
library(ROCR)
library(ranger)
library(naivebayes)
library(gbm)

set.seed(911)

loadEnvironments()

### Get metrics for all models
nreps <- 200
scores <- sapply(ls(pattern = "_train$"), function(x){
	modname <- gsub("\\_train", "", x)
	x <- get(x)
	out <- bootEstimates(df=test_df, outcome_var=outcome_var, problem_type=problem_type, model=x, nreps=nreps, report=report_metric)
	out$specifics$model <- modname
	out$all$model <- modname
	out$roc_df$model <- modname
	return(out)
}, simplify=FALSE)
scores <- do.call("rbind", scores)
metric_df <- do.call("rbind", scores[, "specifics"])
all_metrics_df <- do.call("rbind", scores[, "all"])

if (problem_type=="classification") {
	roc_df <- do.call("rbind", scores[, "roc_df"])
	positive_class <- do.call("rbind", scores[, "positive_cat"])
} else if (problem_type=="regression") {
	roc_df <- NULL 
	positive_class <- NULL 
}

saveVars(metric_df
	, roc_df
	, all_metrics_df
	, positive_class
	, report_metric
	, problem_type
)
