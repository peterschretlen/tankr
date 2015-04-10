
diff_plot <- function(data, debug = F ) {
  
  plot_data <- data
  
  #flatten any missing slopes
  plot_data$slope <- replace(plot_data$slope, is.na(plot_data$slope), 0)
  
  max_y = round( max(plot_data$rank), -1 )
  y_breaks <- seq( -max_y, 0, 5 )
  y_labels <- as.character( seq( max_y, 0, -5 ) )
  
  plot <- ggplot(data = plot_data, aes(x = measurement_id, y = -rank)) + 
    adjust_theme( debug ) +
    scale_x_discrete(expand=c(0.1, 0)) +
    scale_y_continuous( breaks = y_breaks, labels = y_labels, limits = c(-max_y, 0) ) +
    geom_line( aes( group = id, colour = sign(slope) * sqrt( abs(slope) ), alpha = 1 ), size = 1) +
    geom_point( aes(fill = transient), shape = 21, color="transparent" , size = 2 ) +
    scale_color_gradient2( limits = c(-6, 6), mid=get_background_color(), high=muted("blue"), low=muted("red"))  +
    scale_fill_manual( values=c("transparent","black") )

  plot <- plot + ggtitle(first(data$measure))
  
  return(plot)
  
}

adjust_theme <- function( debug ){
  
  if(debug){
    plot_theme <- theme(axis.text.x = element_text(angle = 45, hjust = 1)
                        ,plot.background = element_rect(fill = "white", colour ="white")
                        ,panel.background = element_rect(fill=get_background_color())
                        ,panel.grid.minor = element_blank()
                        ,legend.position = "none"
                        ,axis.title.x = element_blank()
                        ,axis.title.y = element_blank())
  } else {
    plot_theme <- theme_bw() +
       theme(
         plot.background = element_rect(fill = "white", colour ="white")
         ,panel.background = element_rect(fill=get_background_color())
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
         
       )    
  }

  return(plot_theme)
  
}

get_background_color <- function() {
  background.color <- rgb(240,240,240,maxColorValue=255)
  return(background.color)
}

#split the data by measure and create a plot for each
diff_plot_grid <- function(data, debug = F ) {
  
  plots <- dlply( data, .(measure), function(x) diff_plot(x, debug) )
  return(plots)
  
}
