library(shellpipes)

## Functions for permutation-based variable importance
vimp_model <- function(object, ...) {
	new_args <- list(...)
	new_args$object <- object
	out <- do.call("varImp", new_args)$importance
	out <- data.frame(Overall = out)
	return(out)
}


vimp_perm <- function(model, newdata, nrep = 20, estimate = c("mean", "quantile"), parallelize = TRUE, outcome_var, nclusters = parallel::detectCores(), ...){

	estimate <- match.arg(estimate)
	# Overall score
	xvars <- colnames(newdata)[!colnames(newdata) %in% outcome_var]
	y <- newdata[, outcome_var, drop=TRUE]
	overall_c <- confusionMatrix(predict(model, newdata, type="raw"), y)$overall[["Accuracy"]]
	N <- NROW(newdata)
	newdata <- newdata[, xvars, drop=FALSE]

	if (parallelize) {
		## Setup parallel because serial takes a lot of time. Otherwise you can turn it off
		nn <- min(parallel::detectCores(), nclusters)
		if (nn < 2){
			foreach::registerDoSEQ()
		} else{
			cl <-  parallel::makeCluster(nn)
			doParallel::registerDoParallel(cl)
			on.exit(parallel::stopCluster(cl))
		}

		x <- NULL
		vi <- foreach(x = xvars, .export = "confusionMatrix", .packages=c("ranger", "naivebayes", "caret")) %dopar% {
			set.seed(991)
			permute_df <- newdata[rep(seq(N), nrep), ]
			if (is.factor(permute_df[,x])) {
				permute_var <- as.vector(replicate(nrep, sample(newdata[[x]], N, replace = FALSE)))
				permute_var <- factor(permute_var, levels = levels(permute_df[,x]))
			} else {
				permute_var <- as.vector(replicate(nrep, sample(newdata[[x]], N, replace = FALSE)))
			}
			index <- rep(1:nrep, each = N)
			permute_df[, x] <- permute_var
			pred <- predict(model, newdata = permute_df, type = "raw")
			perm_c <- tapply(pred, index, function(r){
				confusionMatrix(r, y)$overall[["Accuracy"]]
			})
			if (estimate=="mean") {
				est <- mean((overall_c - perm_c)/overall_c)
				names(est) <- x
			} else {
				est <- quantile(abs(overall_c - perm_c)/overall_c, probs=c(0.025, 0.5, 0.975), type=8)
			}
			est
		}
		if (estimate=="quantile") {
			names(vi) <- xvars
			vi <- do.call("rbind", vi)
		}
	} else {
		set.seed(991)
		vi <- sapply(xvars, function(x){
			permute_df <- newdata[rep(seq(N), nrep), ]
			if (is.factor(permute_df[,x])) {
				permute_var <- as.vector(replicate(nrep, sample(newdata[[x]], N, replace = FALSE)))
				permute_var <- factor(permute_var, levels = levels(permute_df[,x]))
			} else {
				permute_var <- as.vector(replicate(nrep, sample(newdata[[x]], N, replace = FALSE)))
			}
			index <- rep(1:nrep, each = N)
			permute_df[, x] <- permute_var
			pred <- predict(model, newdata = permute_df, type = "raw")
			perm_c <- tapply(pred, index, function(r){
				confusionMatrix(r, y)$overall[["Accuracy"]]
			})
			if (estimate=="mean") {
				est <- mean((overall_c - perm_c)/overall_c)
			} else {
				est <- quantile(abs(overall_c - perm_c)/overall_c, probs=c(0.025, 0.5, 0.975), na.rm=TRUE)
			}
			return(est)
		}, simplify=TRUE)
		if (estimate=="quantile") {
			vi <- t(vi)
		}
	}
	if (estimate=="mean") {
		vi <- unlist(vi)
	} else {
		colnames(vi) <- c("lower", "Overall", "upper")
		vi <- data.frame(vi)
	}
	return(vi)
}

get_vimp <- function(model, type = c("model", "perm"), estimate=c("mean", "quantile"), relative=TRUE, newdata, nrep = 20, modelname="model", parallelize = TRUE, nclusters = parallel::detectCores(), ...){
	type <- match.arg(type)
	if (type == "perm") {
		out <- vimp_perm(model, newdata, nrep, estimate=estimate, parallelize = parallelize, nclusters = nclusters, ...)
		if (estimate=="mean") {
			out <- data.frame(Overall = out)
			out$terms <- rownames(out)
			out <- out[, c("terms", "Overall")]
		} else {
			out$terms <- rownames(out)
			out <- out[, c("terms", "lower", "Overall", "upper")]
		}
	} else {
		out <- vimp_model(model, ...)
		out$terms <- rownames(out)
		out <- out[, c("terms", "Overall")]
	}
	if (type=="model" | estimate=="mean") {
		out$sign <- sign(out$Overall)
		out$Overall <- abs(out$Overall)
	}
	out$model <- modelname
	rownames(out) <- NULL
	if (relative){
		if (estimate=="mean") {
			out$Overall <- out$Overall/sum(out$Overall, na.rm = TRUE)
		}
	}
	class(out) <- c("varimp", class(out))
	if (type=="perm") {
		attr(out, "estimate") <- estimate
	} else {
		attr(out, "estimate") <- "mean"
	}
	return(out)
}

plot.varimp <- function(x, ..., pos = 0.5, drop_zero = TRUE, top_n=NULL){
	xsign <- x$sign
	if (!is.null(xsign)) {
		x$sign <- ifelse(xsign==1, "+", ifelse(xsign==-1, "-", "0"))
	} else {
		xsign <- 1
	}
	est <- attr(x, "estimate")
# 	if (est=="quantile") {
# 		x[ "Overall"] <- x$estimate
# 	}
	x <- x[order(x$Overall), ]
	if (drop_zero){
		x <- x[x$Overall!=0, ]
	}
	x <- x[order(x$Overall, decreasing=TRUE), ]
	if (!is.null(top_n)) {
		x <- x[1:top_n, ]
	}
	x <- droplevels(x)

	Overall <- NULL
	lower <- NULL
	upper <- NULL
	nsigns <- unique(xsign)
   nmods <- unique(x$model)
   nsigns <- unique(x$sign)
   pos <- position_dodge(width = pos)
   if (length(nmods)==1) {
      p0 <- ggplot(x, aes(x = reorder(terms, Overall), y = Overall))
#      p0 <- ggplot(x, aes(x = terms, y = Overall))
   } else {
      p0 <- (ggplot(x, aes(x = reorder(terms, Overall), y = Overall, colour = model))
         + labs(colour = "Model")
      )
   }

	if (est=="quantile") {
		if (length(nsigns)>1) {
			p0 <- (p0
				+ geom_point(aes(shape=sign), position = pos)
				+ scale_shape_manual(name = "Sign", values=c(1,16, 15))
				+ geom_linerange(aes(ymin=lower, ymax=upper, lty = sign), position = pos)
				+ labs(linetype = "Sign")
			)
		} else {
			p0 <- (p0
				+ geom_point(position = pos)
				+ geom_linerange(aes(ymin=lower, ymax=upper), position=pos)
			)
		}
	} else {
		if (length(nsigns)>1) {
			p0 <- (p0
				+ geom_point(aes(shape=sign), position = pos)
				+ scale_shape_manual(name = "Sign", values=c(1,16, 15))
				+ geom_linerange(aes(ymin = 0, ymax = Overall, lty = sign), position = pos)
				+ labs(linetype = "Sign")
			)
		} else {
			p0 <- (p0
				+ geom_point(position = pos)
				+ geom_linerange(aes(ymin=0, ymax=Overall), position=pos)
			)
		}
	}
	p1 <- (p0
		+ scale_colour_viridis_d(option = "inferno")
		+ labs(x = "", y = "Importance")
		+ coord_flip(clip = "off", expand = TRUE)
	)
	return(p1)
}

saveEnvironment()
