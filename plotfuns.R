library(ggplot2)
library(ggthemes)

ggtheme <- function(){
  theme_set(theme_bw() +
    theme(panel.spacing=grid::unit(0,"lines")
      , plot.title = element_text(hjust = 0.5)
      , legend.position = "bottom"
      , axis.ticks.y = element_blank()
      , axis.text.x = element_text(size = 11)
      , axis.text.y = element_text(size = 11)
      , axis.title.x = element_text(size = 12, face="bold")
      , axis.title.y = element_text(size = 12, face="bold")
      , legend.title = element_text(size = 12, face="bold")
      , legend.text = element_text(size = 12)
      , panel.grid.major = element_blank()
      #, panel.grid.minor = element_blank()
      , legend.key.size = unit(0.8, "cm")
      , legend.key = element_rect(fill = "white")
      , panel.spacing.y = unit(0.3, "lines")
      , panel.spacing.x = unit(1, "lines")
      , strip.background = element_blank()
      , panel.border = element_rect(colour = "grey"
        , fill = NA
        , size = 0.8
      )
      , strip.text.x = element_text(size = 11
        , colour = "black"
        , face = "bold"
      )
      , strip.text.y = element_text(size = 11
        , colour = "black"
        , face = "bold"
      )
    )
  )
}
palettes <- ggthemes_data[["tableau"]][["color-palettes"]][["regular"]][["Tableau 20"]]$value

saveEnvironment()
