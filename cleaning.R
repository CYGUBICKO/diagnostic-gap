library(shellpipes)
library(forcats)
library(readxl)
library(dplyr)
library(tidyr)

loadEnvironments()

### Rename variables
vars_renamed_df <- data_processing_file$renamed_vars
vars_renamed <- vars_renamed_df$old_name

### Variables to drop from the analysis
vars_droped <- data_processing_file$droped_vars$var_name

### Remove droped variables from the renamed df 
vars_renamed_df <- (vars_renamed_df
	%>% filter(!old_name %in% vars_droped)
)
vars_renamed <- vars_renamed[!vars_renamed %in% vars_droped]

### Relabel value labels
vars_relabeled <- data_processing_file$vars_to_relabel
vars_relabeled <- split(vars_relabeled, vars_relabeled$var_name)

### Category to recode to missing 
vals_missing <- data_processing_file$missing_vals$miss_value

### Set of variables with similar patterns
vars_set <- grep("\\_set$|\\_set\\_", sheets, value=TRUE)
temp_set <- data_processing_file[vars_set]
data_processing_file[vars_set] <- NULL

#### Identify and recode all varibles in a group
if (length(vars_set)) {
	for (v in vars_set) {
		.x1 <- grep(gsub(".*\\_", "", v), vars_renamed, value=TRUE)
		if (length(.x1)) {
			data_processing_file[.x1] <- temp_set[v]
			vars_remain <- vars_renamed[!vars_renamed %in% .x1]
		} else {
			vars_remain <- vars_renamed
			.x1 <- grep(gsub("\\_set$", "", v), vars_remain, value=TRUE)
			data_processing_file[.x1] <- temp_set[v]
		}
	}
}
vars_recode <- names(data_processing_file)

### Model params
model_params <- data_processing_file$model_params

#### Exclude sheets which do not need recoding
vars_recode <- vars_recode[!vars_recode %in% c("data_source", "data_path", "droped_vars", "renamed_vars", "drop_vars", "missing_vals", "ses_vars", "vars_to_numeric", "generated_vars", "outcome_var", "vars_to_relabel", "model_params", "missing_value_category")]

if (length(vars_recode)) {
	recode_files = data_processing_file
	df <- (df
		%>% mutate_at(vars_recode, labelall)
	)
}

if (length(vars_relabeled)) {
	recode_files = vars_relabeled
	df <- (df
		%>% mutate_at(names(vars_relabeled), labelall)
      %>% mutate_at(names(vars_relabeled), function(x){
         var_name <- rlang::as_label(substitute(x))
         x <- fct_relevel(x, vars_relabeled[[var_name]][["new_label"]])
      })
	)
}

### Numeric vars
vars_to_numeric <- data_processing_file$vars_to_numeric$var_name

### SES vars
ses_vars <- data_processing_file$ses_vars$var_name

#### Recode missing::impute to NA
if (length(vals_missing)) {
	df <- (df
		%>% mutate_at(colnames(.), function(x){
			x <- na_codes(x, vals_missing)
		})
	)
}

#### Convert factor numerics to numeric
if (length(vars_to_numeric)) {
	df <- (df
		%>% mutate_at(vars_to_numeric, factor2numeric)
	)
}

#### Selected vars
if (length(vars_droped)) {
	df <- (df
		%>% select(-all_of(vars_droped))
	)
}

#### Create prediction template
readr::write_csv(sample_n(df, 1), file="prediction_template.csv")

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
