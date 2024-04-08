library(shellpipes)
library(dplyr)
library(forcats)
library(ggplot2)

loadEnvironments()
startGraphics(height=10, width=12)
ggtheme()

if (problem_type=="classification") {
	roc_df <- (roc_df
		%>% left_join(
			metric_df %>% select(estimate, model)
			, by = c("model")
		)
		%>% mutate(model_new = paste0(model, " (", round(estimate,3), ")"))
	)

	ll <- unique(roc_df$model)
	roc_plot <- (ggplot(roc_df, aes(x = x, y = y, group = model, colour = model))
		+ geom_line()
		+ scale_x_continuous(limits = c(0, 1))
		+ scale_y_continuous(limits = c(0, 1))
	# 	+ scale_color_manual(breaks = ll, values = rainbow(n = length(ll))
	# 		, guide = guide_legend(override.aes = list(size=1), reverse=TRUE)
	# 	)
	# 	+ scale_linetype_discrete(guide = guide_legend(override.aes = list(size=1), reverse=TRUE))
	  + geom_abline(intercept = 0, slope = 1, colour = "darkgrey", linetype = 2)
		+ labs(x = "False positive rate"
			, y = "True positive rate"
			, colour = "Model"
		)
	+ theme(legend.position="right")
	)
	print(roc_plot)
	csvSave(roc_df)
} else {
	csvSave(data.frame())
}
