
diff_plot <- function(data) {
  
  plot_data <- data
  
  #flatten any missing slopes
  plot_data$slope <- replace(plot_data$slope, is.na(plot_data$slope), 0)
  
  background.color <- rgb(240,240,240,maxColorValue=255)
  
  plot <- ggplot(data = plot_data, aes(x = measurement_id, y = rank)) + 
    theme_bw() +
    theme(
      plot.background = element_rect(fill = "white", colour ="white")
      ,panel.background = element_rect(fill=background.color)
      ,panel.grid.major = element_blank()
      ,panel.grid.minor = element_blank()
      ,panel.margin = unit(c(0,0,0,0), "lines")
      ,panel.border = element_blank()
      ,axis.title.x=element_blank()
      ,axis.title.y=element_blank()
      ,axis.text.x=element_blank()
      ,axis.text.y=element_blank()
      ,axis.ticks=element_blank()
      ,axis.ticks.length = unit(0,"null")
      ,axis.ticks.margin = unit(0,"null")
      ,legend.position = "none"
      ,plot.title = element_text(lineheight=.8, face="italic", color='dark gray')
      ,plot.margin = unit(c(0,0,0,0), "lines")
      
    ) +
    scale_x_discrete(expand=c(0.1, 0)) +
    
    geom_line( aes( group = id, colour = sign(slope) * sqrt( abs(slope) ), alpha=( 0.5 + abs(slope) / 72) ), size=1) +
    geom_point( aes(fill = transient), shape = 21, color="transparent" , size = 2 ) +
    scale_color_gradient2( limits = c(-6, 6), mid=background.color, high=muted("blue"), low=muted("red"))  +
    scale_fill_manual( values=c("transparent","black") )

  return(plot)
  
}