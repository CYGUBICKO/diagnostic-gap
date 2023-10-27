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
	x <- get(x)
	modname <- x$model_name_
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
preprocess_steps$model_evaluation = paste0("To evaluate the sensitivity and uncertainty of the predictive performance measures, we applied bootstrap resampling to estimate the 2.5%, 50% and 97.5% quantiles of the distribution of the scores. We used ",  nreps, " bootstrap resamples of the test data", ".")
metric_df[, c("lower", "estimate", "upper")] = sapply(metric_df[, c("lower", "estimate", "upper")], function(x){round(x, 3)})

metric_df$model_score = paste0(metric_df$model, " with ", metric_df$metric, " score of ", metric_df$estimate, "[", metric_df$lower, ", ", metric_df$upper, "]")

preprocess_steps$all_models = paste0("We applied and compared the following models: ", paste0(unique(metric_df$model_score), collapse=", "), ".")

saveVars(metric_df
	, roc_df
	, all_metrics_df
	, positive_class
	, report_metric
	, problem_type
	, preprocess_steps
)
