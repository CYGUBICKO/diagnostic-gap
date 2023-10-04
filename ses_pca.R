library(shellpipes)
library(dplyr)

loadEnvironments()

if (length(ses_vars)) {
	ses_df <- (df
		%>% select_at(ses_vars)
	) 
	### Perform PCA

	ses_pca <- prcomp(ses_df, center = TRUE, scale. = TRUE)
	pca_summ <- summary(ses_pca)
	print(pca_summ)
	ses_index <- ses_pca$x[, 1, drop=TRUE]

	loadings <- pca_summ$rotation[, 1, drop=TRUE]

	if(min(sign(loadings)) != max(sign(loadings))){
		stop("PC1 is not a positively signed index")
	}

	df <- (df
		%>% mutate(ses_index = ses_index)
	)
	
	vars_selected_df <- do.call("rbind"
		, list(vars_selected_df, vars_generated_df)
	)

	saveVars(ses_index
		, ses_pca
		, df
		, model_params
		, vars_renamed_df
		, ses_vars
		, sheets
		, data_processing_file
		, check_missing
		, factor2numeric
		, get_excel_param
		, get_excel_param_all
		, get_file_ext
		, labelall
		, labelsfun
		, na_codes
		, preprocessFun
		, seqx
	)
} else {
	saveVars(df
		, model_params
		, vars_renamed_df
		, ses_vars
		, sheets
		, data_processing_file
		, check_missing
		, factor2numeric
		, get_excel_param
		, get_excel_param_all
		, get_file_ext
		, labelall
		, labelsfun
		, na_codes
		, preprocessFun
		, seqx
	)
}
