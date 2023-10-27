library(shellpipes)
library(dplyr)

loadEnvironments()

top_n <- 2
best_df <- (metric_df
	%>% arrange(desc(estimate))
	%>% mutate(.n = 1:n())
	%>% filter(.n <= top_n)
	%>% select(-.n)
)
print(best_df)
preprocess_steps$best_model = paste0("Out of all trained models, the top ", top_n, " best performing models were: ", paste0(best_df$model_score, collapse=", "), ".")

saveVars(best_df
	, preprocess_steps
)
