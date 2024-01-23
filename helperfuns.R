library(shellpipes)

## Use this call to make helperfuns.Rout independently
rpcall("helperfuns.Rout helperfuns.pipestar helperfuns.R requirements.Rout")


### Convert labels to NA
na_codes <- function(x, ...) {
  x[x %in% c(...)] <- NA
  x
}

### Recode value labels
labelsfun <- function(file, var) {
  all_labs <- file[[var]]
  labs <- as.character(all_labs$old_label)
  names(labs) <- as.character(all_labs$new_label)
  return(labs)
}

### Multiple labeling
labelall <- function(x, file=NULL) {
  var_name <- rlang::as_label(substitute(x))
  if (is.null(file)) file <- recode_files
  x <- fct_recode(as.factor(as.character(x)), !!!labelsfun(var=var_name, file=file))
  x <- fct_drop(x)
  return(x)
}

factor2numeric <- function(x) {
	as.numeric(as.character(x))
}

### Create a vector of length n
seqx <- function(x) {
	check <- all(x >= 1)
	x <- seq(x[1], x[2], length.out=x[3])
	check <- all(x >= 1)
	if (check) x <- floor(x)
	return(x)
}

## Extract parameters from excel file
get_excel_param <- function(x) {
	if (!is.numeric(x)) {
		check <- grepl("\\[|\\]", x)
		x <- strsplit(gsub("\\[|\\]|\\(|\\)", "", x), ",")[[1]]
		if (length(x) > 1) {
			x <- trimws(x)
			if (check) {
				x <- as.numeric(x)
			} 
		}
	}
	return(x)
}

get_excel_param_all <- function(param_file) {
	out <- sapply(names(param_file), function(p) {
		p <- param_file[[p]]
		params <- sapply(colnames(p), function(x){
			out <- get_excel_param(p[[x]])
			return(out)
		}, simplify=FALSE)
		return(params)
	}, simplify=FALSE)
	return(out)
}

check_missing <- function(x) {
	is.na(x)
}

get_file_ext = function(file) {
	(strsplit(basename(file), split="\\.(?=[^\\.]+$)", perl = TRUE)[[1]])[2]
}

preprocessFun <- function(df, model_form, corr, handle_missing, exclude=NULL) {
	df_out = recipe(model_form, data=df)
	preprocess_result = list()
	if (anyNA.data.frame(df)) {
		if (handle_missing == "omit") {
			df_out = (df_out
				%>% step_naomit(all_predictors())
			)
			preprocess_result$handle_missing = "Delete missing values"
		} else if (handle_missing== "missing_mean") {
			df_out = (df_out
				%>% step_unknown(all_nominal(), new_level = "_Missing_")
				%>% step_impute_mean(all_numeric())
			)
			preprocess_result$handle_missing = c("missing values in categorical variables recorded as _Missing_", "missing values in numeric variables replaced by the mean.")
		} else if (handle_missing=="missing_median") {
			df_out = (df_out
				%>% step_unknown(all_nominal(), new_level = "_Missing_")
				%>% step_impute_median(all_numeric())
			)
			preprocess_result$handle_missing = c("missing values in categorical variables recorded as _Missing_", "missing values in numeric variables replaced by the median.")
		} else if (handle_missing=="mode_median") {
			df_out = (df_out
				%>% step_impute_mode(all_nominal())
				%>% step_impute_median(all_numeric())
			)
			preprocess_result$handle_missing = c("missing values in categorical variables replacesd by modal value", "missing values in numeric variables replaced by the median.")
		} else if (handle_missing=="mode_mean") {
			df_out = (df_out
				%>% step_impute_mode(all_nominal())
				%>% step_impute_mean(all_numeric())
			)
			preprocess_result$handle_missing = c("Categorical -> Mode", "Numeric -> Mean")
			preprocess_result$handle_missing = c("missing values in categorical variables replacesd by modal value", "missing values in numeric variables replaced by the mean.")
		} else if (handle_missing=="bag") {
			df_out = (df_out
				%>% step_impute_bag(all_predictors(), all_outcomes())
			)
			preprocess_result$handle_missing = c("Bagging")
		} else if (handle_missing=="knn") {
			df_out = (df_out
				%>% step_impute_knn(all_predictors(), all_outcomes())
			)
			preprocess_result$handle_missing = c("missing values imputed using KNN.")
		} else if (handle_missing=="knn_linear") {
			df_out = (df_out
				%>% step_impute_knn(all_nominal())
				%>% step_impute_linear(all_numeric())
			)
			preprocess_result$handle_missing = c("missing values in categorical variables replacesd by KNN", "missing values in numeric variables replaced by linear reg/ression.")
		}
	}
	df_out = (df_out
		%>% step_center(all_numeric_predictors())
		%>% step_scale(all_numeric_predictors())
	)
	if (is.null(exclude)) {
		df_out = (df_out
			%>% step_nzv(all_predictors())
		)
	} else {
		df_out = (df_out
			%>% step_nzv(all_predictors(), -all_of(exclude))
		)
	}
	preprocess_result$handle_predictors = c("All numeric variables were centered and scaled and variables with near zero variance removed.")
	if (corr > 0) {
		if (is.null(exclude)) {
			df_out = (df_out
				%>% step_corr(all_predictors(), threshold=corr)
			)
		} else {
			df_out = (df_out
				%>% step_corr(all_predictors(), -all_of(exclude), threshold=corr)
			)
		}
		preprocess_result$correlated_predictors = paste0("One of the variables which had a bivariate correlation of at least ", corr, " were droped.")
	}
	df_out = (df_out
		%>% prep(df)
		%>% bake(new_data=NULL)
	)
	removed_vars = colnames(df)[!colnames(df) %in% colnames(df_out)]
	preprocess_result$n_removed_vars = if(length(removed_vars)) paste0(length(removed_vars), " variabels were removed after preprocessing.") else  NULL 
	preprocess_result$removed_vars = if(length(removed_vars)) paste0(removed_vars, collapse=",") else NULL
	preprocess_result$predictors_for_analysis = paste0(outcome_var, " was used as an outcome variable, while the following were used as predictors: ", paste0(colnames(df_out)[!colnames(df_out) %in% outcome_var], collapse=", "), ".")
	return(list(df_processed=df_out, df_original=df, preprocess_steps=preprocess_result))
}

saveEnvironment()
