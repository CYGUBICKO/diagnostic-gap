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
	out <- bootEstimates(df=test_df, outcome_var=outcome_var, model=x, nreps=nreps, report=report_metric)
	out$specifics$model <- modname
	out$all$model <- modname
	out$roc_df$model <- modname
	return(out)
}, simplify=FALSE)


scores <- do.call("rbind", scores)
auc_df <- do.call("rbind", scores[, "specifics"])
roc_df <- do.call("rbind", scores[, "roc_df"])
metrics_df <- do.call("rbind", scores[, "all"])
positive_class <- do.call("rbind", scores[, "positive_cat"])

auc_df

saveVars(auc_df
	, roc_df
	, metrics_df
	, positive_class
	, report_metric
)
