library(shellpipes)
library(forcats)
library(dplyr)

loadEnvironments()

top_n <- 5
total_n <- 20

## Mostly frequently identified variables
varfreq_df <- (varimp_all_df
	%>% group_by(model)
	%>% arrange(desc(Overall), .by_group=TRUE)
	%>% mutate(pos = 1:n())
	%>% ungroup()
	%>% mutate(NULL
		, pos=ifelse(pos<=top_n, pos, top_n+1)
		, new_terms=fct_reorder(terms, pos, mean)
	)
	%>% filter(as.numeric(new_terms) <= total_n)
	%>% group_by(new_terms, pos)
	%>% count()
	%>% droplevels()
)
print(varfreq_df)

saveVars(varfreq_df)
