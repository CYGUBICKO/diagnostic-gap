library(shellpipes)

#### ---- Prediction uncertainities ----
bootMeasures <- function(df, model, outcome_var){
	x_df <- df[, colnames(df)[!colnames(df) %in% outcome_var]]
	y <- df[, outcome_var, drop=TRUE]
	preds <- predict(model, x_df, type = "prob")
	preds$pred <- factor(apply(preds, 1, function(x)colnames(preds)[which.max(x)]), levels=levels(y))
	preds$obs <- y
	ss <- twoClassSummary(preds, lev = levels(preds$obs))
	pp <- prSummary(preds, lev = levels(preds$obs))
	aa <- confusionMatrix(preds$pred, preds$obs)$overall[["Accuracy"]]
	scores_df <- data.frame(Accuracy = aa
		, AUCROC = ss[["ROC"]]
		, AUCRecall = pp[["AUC"]]
		, Sens = ss[["Sens"]]
		, Spec = ss[["Spec"]]
		, Precision = pp[["Precision"]]
		, Recall = pp[["Recall"]]
		, "F" = pp[["F"]]
	)

	## ROCs
	base_lev <- levels(preds$pred)[1]
	rocr_pred <- prediction(preds[[base_lev]]
		, preds$obs
	)
	model_roc <- performance(rocr_pred, "tpr", "fpr")
   roc_df <- data.frame(x = model_roc@x.values[[1]], y = model_roc@y.values[[1]])
	return(list(scores_df=scores_df, roc_df=roc_df, positive_cat = base_lev))
}

bootEstimates <- function(df, model, outcome_var, nreps = 500, report = c("Accuracy", "AUCROC", "AUCRecall", "Sens", "Spec", "Precision", "Recall", "F")) {
	all <- c("Accuracy", "AUCROC", "AUCRecall", "Sens", "Spec", "Precision", "Recall", "F") 
	if (!any(all %in% report)) {
		stop(c("The report options are ", paste0(all, collapse=", ")))
	}
	resamples <- createResample(1:nrow(df), times = nreps, list = TRUE)
	est <- lapply(resamples, function(x){
		bootMeasures(df[x, ], model, outcome_var)$scores_df
	})
	out <- do.call(rbind, est)
	out <- sapply(out, function(x){quantile(x, c(0.025, 0.5, 0.975))})
	out_metric <- out[, report, drop = FALSE]
	out_metric <- t(out_metric)
	colnames(out_metric) <- c("lower", "estimate", "upper")
	out_metric <- as.data.frame(out_metric)
	out_metric$metric <- rownames(out_metric)
	out <- t(out)
	colnames(out) <- c("lower", "estimate", "upper")
	out <- as.data.frame(out)
	out$metric <- rownames(out)
	out <- list(out_metric, out)
	names(out) <- c("specifics", "all")
	## Generate ROC
	roc <- bootMeasures(df, model, outcome_var)
	roc_df <- roc$roc_df
	out$roc_df <- roc_df
	positive_cat <- roc$positive_cat
	out$positive_cat <- positive_cat
	return(out)
}


saveEnvironment()
