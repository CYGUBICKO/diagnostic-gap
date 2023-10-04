library(shellpipes)
library(dplyr)

loadEnvironments()

top_n <- 2
best_df <- (auc_df
	%>% arrange(desc(estimate))
	%>% mutate(.n = 1:n())
	%>% filter(.n <= top_n)
	%>% select(-.n)
)
print(best_df)

saveVars(best_df)
