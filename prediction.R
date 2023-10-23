library(shellpipes)
library(caret)
library(ROCR)
library(ranger)
library(naivebayes)
library(gbm)

set.seed(911)

loadEnvironments()

file_name = fileSelect(ext="csv", pat="prediction_template")
pred_df <- readr::read_csv(file_name)

preds <- sapply(ls(pattern = "_train$"), function(x){
	modname <- gsub("\\_train", "", x)
	x <- get(x)
	out <- predict(x, newdata=pred_df)
	pred_df[[outcome_var]] <- out
	pred_df$model <- modname
	return(pred_df)
}, simplify=FALSE)
preds <- do.call("rbind", preds)
csvSave(preds, target = targetname())
