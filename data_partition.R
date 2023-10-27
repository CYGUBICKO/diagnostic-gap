library(shellpipes)
library(caret)

loadEnvironments()

seed <- model_params$seed
train_test_ratio <- model_params$train_test_ratio
set.seed(seed)

# Create training and test datasets
index <- createDataPartition(df[[outcome_var]]
	, p = train_test_ratio
	, list = FALSE
)
train_df <-  df[index, ]
test_df <- df[-index, ]

saveVars(train_df
	, test_df
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
