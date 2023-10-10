library(shellpipes)
library(ggplot2)

loadEnvironments()
startGraphics()

ggtheme()

pos <- position_dodge(0.05)
metric_plot <- (ggplot(metric_df, aes(x=reorder(model, -estimate), y=estimate))
	+ geom_point(position = pos)
	+ geom_errorbar(aes(ymin = lower, ymax = upper)
		, position = pos
		, width = .2
	)
	+ theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
	+ labs(y = report_metric
		, x = "Model"
	)
)
print(metric_plot)
csvSave(metric_df)
csvSave(all_metrics_df, target = paste0("all_", targetname()))
