library(shellpipes)
library(dplyr)
library(ggplot2)

loadEnvironments()
startGraphics(height=12, width=10)
ggtheme()

best_model <- best_df$model

varimp_topn_df <- (varimp_all_df
	%>% filter(model %in% best_model)
)

p1 <- plot(varimp_topn_df)
print(p1)

csvSave(varimp_all_df)
