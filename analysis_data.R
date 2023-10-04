library(shellpipes)
library(forcats)
library(dplyr)

loadEnvironments()

model_form <- as.formula(paste0(outcome_var, "~."))

if (length(ses_vars)) {
	vars_renamed_df <- (vars_renamed_df
		%>% filter(!old_name %in% ses_vars)
	)
}
old_name <- vars_renamed_df$old_name
new_name <- vars_renamed_df$new_name

if (length(ses_vars)) {
	df <- (df
		%>% select(-all_of(ses_vars))
	)
}

if (length(new_name)) {
	df <- (df
		%>% rename_at(vars(old_name), ~new_name)
		%>% droplevels()
	)
}

saveVars(model_form
	, outcome_var
	, descriptive_plots
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
