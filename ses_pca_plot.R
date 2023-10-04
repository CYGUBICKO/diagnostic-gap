library(shellpipes)
library(factoextra)
library(ggfortify)

loadEnvironments()

startGraphics()

if (length(ses_vars)) {
	## Variance explained plot
	ses_explained_plot <- fviz_screeplot(ses_pca, addlabels = TRUE)
	print(ses_explained_plot)

	## PC plots
	ses_pc_plot <- (autoplot(ses_pca
			, alpha = 0.2
			, shape = FALSE
			, label = FALSE
			, frame = TRUE
			, frame.type = 'norm'
			, frame.alpha = 0.1
			, show.legend = FALSE
			, loadings = TRUE
			, loadings.colour = "gray"
			, loadings.label.size = 3
			, loadings.label.repel = TRUE
		)
		+ geom_vline(xintercept = 0, lty = 2, colour = "gray")
		+ geom_hline(yintercept = 0, lty = 2, colour = "gray")
	)
	print(ses_pc_plot)
	saveVars(ses_pc_plot
		, ses_index
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
