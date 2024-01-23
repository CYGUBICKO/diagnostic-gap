library(shellpipes)
library(dplyr)
library(recipes)
library(caret)

loadEnvironments()

set.seed(seed)


corr_threshold = model_params$corr_threshold
handle_missing = model_params$handle_missing

train_recipe = preprocessFun(df = train_df, model_form = model_form, corr = corr_threshold, handle_missing=handle_missing)
test_recipe = preprocessFun(df = test_df, model_form = model_form, corr = corr_threshold, handle_missing=handle_missing, exclude=colnames(train_recipe$df_processed))

saveVars(train_recipe
	, test_recipe
	, seed
	, model_form
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
	, train_test_ratio
	, project_description
)
