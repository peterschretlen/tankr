
load_all_measurements <- function() {
  
  measurement_files <- list.files( pattern = "output.*\\.txt", full.names=TRUE, recursive=TRUE )
  return( ldply(measurement_files, load_measurement, .progress = "text") )
  
}

load_measurement <- function( path ) {
  
  info = file.info( path )
  if(info$size == 0) {
    return( data.frame() )
  }
  
  measurement <- read.table(path, quote="\"")
  names( measurement ) <- c("rank", "measurement_id", "id", "measure")

  return( measurement )
  
}