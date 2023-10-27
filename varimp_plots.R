library(shellpipes)
library(dplyr)
library(ggplot2)

loadEnvironments()
startGraphics(height=12, width=10)
ggtheme()

top_n <- 3
best_model <- best_df$model

varimp_topn_df <- (varimp_all_df
	%>% filter(model %in% best_model)
)

p1 <- plot(varimp_topn_df)
print(p1)

best_vars <- (varimp_topn_df
	%>% group_by(model)
	%>% arrange(desc(Overall), .by_group=TRUE)
	%>% mutate(.n = 1:n())
	%>% filter(.n <= min(top_n, length(unique(varimp_topn_df$terms))))
	%>% pull(terms)
	%>% unique()
)
top_n = length(best_vars)

preprocess_steps$variable_importance = paste0("A permutation-based variable importance score was used to identify the top ", top_n, " most important features, which included ", paste0(best_vars, collapse=", "), ".")

csvSave(varimp_all_df)

saveVars(preprocess_steps)
