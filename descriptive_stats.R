library(shellpipes)
library(stringr)
library(tidyr)
library(dplyr)
library(scales)
library(forcats)
library(ggplot2)
library(GGally)

loadEnvironments()
startGraphics()
ggtheme()

if (NROW(vars_renamed_df)) {
	plot_vars <- vars_selected_df$group_plot
	all_vars <- vars_selected_df$old_name
	var_labels <- vars_selected_df$var_label
	group_labels <- vars_selected_df$group_label
} else {
	plot_vars <- all_vars <- var_labels <- group_labels <- colnames(df)
}

descriptive_plots <- sapply(unique(plot_vars), function(x) {
	x <- grep(paste0(x, "$"), all_vars, value=TRUE)
	perc_check <- FALSE
	index <- all_vars %in% x
	.labs <- var_labels[index]
	if (length(x)==1) {
		if (is.character(df[[x]]) | is.factor(df[[x]])) {
			perc_check <- TRUE
		}
		p <- simplePlot(df
			, variable = x
			, show_percent_labels = perc_check
			, title = .labs
			, sort_x = perc_check
		)
		print(p)
	} else {
		labs <- x
		names(labs) <- .labs
		p <- multiresFunc(df
			, var_patterns = x
			, question_labels = labs
			, wrap_labels = 30
			, show_percent_labels = FALSE
			, xlabel = ""
			, shift_axis = TRUE
			, distinct_quiz = TRUE
			, sum_over_N = TRUE
			, NULL_label = "Nonsnsns"
			, title = unique(group_labels[index])
		)
		print(p)
	}
}, simplify=FALSE)

if (length(ses_vars) > 0) {
	descriptive_plots$ses_explained_plot <- ses_explained_plot
	descriptive_plots$ses_pc_plot <- ses_pc_plot
}


## Pairwise comparison
outcome_var <- model_params$outcome_var
compare_plot <- sapply(unique(all_vars), function(x) {
	index <- all_vars %in% x
   .labs <- var_labels[index]
	if (x != outcome_var) {
		p <- (ggbivariate(df %>% select_at(all_of(c(x, outcome_var)))
				, outcome=outcome_var
				, columnLabelsY = ""
			)
			+ theme(legend.position="bottom")
			+ labs(title=.labs)
		)
		print(p)
	}
})
descriptive_plots$compare_plot <- compare_plot

## Select variables needed for analysis only
df <- (df
	%>% select(all_of(all_vars))
)

saveVars(outcome_var
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
	, project_description
)
