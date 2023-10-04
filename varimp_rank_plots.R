library(shellpipes)
library(forcats)
library(ggplot2)

loadEnvironments()
startGraphics()

theme_set(
	theme_bw(base_size=12)
	+ theme(
		strip.background = element_blank()
		, panel.border = element_rect(colour = "grey"
			, fill = NA
			, size = 0.8
		)
		, strip.text.x = element_text(size = 11
			, colour = "black"
			, face = "bold"
		)
	)
)

varfreq_plot <- (ggplot(varfreq_df, aes(x=pos, y=fct_reorder(new_terms, -pos, .fun=mean), fill=n))
	+ geom_tile(color="black")
	+ scale_fill_distiller(palette = "Greens", direction=1)
	+ scale_y_discrete(expand=c(0,0))
	+ scale_x_continuous(
		breaks=function(x){1:max(x)}
		, labels=function(x){
			m <- max(x)
			v <- as.character(1:m)
			v[[m]] <- paste0(">", m-1)
			return(v)
		}
		, expand=c(0,0)
	)
	+ labs(y="", x="Rank", fill="Frequency")
)

print(varfreq_plot)





