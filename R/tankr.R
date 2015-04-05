
#' Compare rankings between two measurements in long (plot-friendly) form
#' 
#' Each measurement is a dataframe with these columns:
#' \itemize{
#' \item rank: numeric value of ranking
#' \item measurement_id: an identifier for the measurement. This can by a character string or number
#' \item id: an identifier for the item holding the ranking
#' \item measure: a description of the measurement, e.g. "non-fiction bestsellers" 
#' }
#' 
#' @param m1 data frame with first measurement
#' @param m2 data frame with second measurement
#' @return A dataframe with the changes in ranking between the two measurements.
#' @examples
#' todo
#'
rank_diff_pair <- function( m1, m2 ){
  
  m1id.name <- first( m1$measurement_id )
  m2id.name <- first( m2$measurement_id )
  
  m1$measurement_id <- "m1"
  m2$measurement_id <- "m2"
  
  m.pair <- rbind( m1, m2 )
  
  #convert to long
  m.pair.long <- dcast( m.pair, measure+rank~measurement_id, value.var="id")
  
  compare <- m.pair.long %>% 
              group_by( measure ) %>% 
              mutate( new.rank.relative.old = rank-match( m1, m2 )) %>%
              mutate( old.rank.relative.new = match( m2, m1 ) - rank ) %>%
              mutate( rm = is.na( new.rank.relative.old )) %>% 
              mutate( add = is.na( old.rank.relative.new ))
            
  #Now convert wide back to long
  compare.names <- c("measure","rank","id","transient", "slope", "measurement_id")
  compare.before <- compare %>% select(measure, rank, m1, rm, new.rank.relative.old)
  compare.before$measurement_id <- m1id.name
  names(compare.before) <- compare.names
  
  compare.after <- compare %>% select( measure, rank, m2, add, old.rank.relative.new)
  compare.after$measurement_id <- m2id.name
  names(compare.after) <- compare.names
  
  comparison <- rbind(compare.before, compare.after)
  
  return( comparison )
}

#' Compare each pair of measurments in a series
#' 
#' The measurements are dataframe with columns:
#' \itemize{
#' \item rank: numeric value of ranking
#' \item measurement_id: an identifier for the measurement. This can by a character string or number
#' \item id: an identifier for the item holding the ranking
#' \item measure: a description of the measurement, e.g. "non-fiction bestsellers" 
#' }
#' 
#' @param m data frame with the measurements, ordered from first to last
#' @return A dataframe with the changes in ranking between the two measurements.
#' @examples
#' todo
#'
rank_diff_series <- function( m ){
  
  measurement_series <- generate_diff_ids( m )

  #convert factors to strings
  measurement_series$measurement_id <- as.character(measurement_series$measurement_id)
  
  #Group by diff_ids
  diff_set_1 <- ddply( measurement_series, .(diff_id1), function(x) rank_diff_pair_df(x,"1"), .progress = "text" )
  diff_set_2 <- ddply( measurement_series, .(diff_id2), function(x) rank_diff_pair_df(x,"2"), .progress = "text" )
  
  names(diff_set_1)[1] <- "set_id"
  names(diff_set_2)[1] <- "set_id"
  
  diff_series <- rbind(diff_set_1, diff_set_2)
  
  return(diff_series)
}

rank_diff_pair_df <- function( df, id ){
  
  set_id <- unique( df[[paste('diff_id', id, sep='')]] )
  if(is.na(set_id)){
    return(data.frame())
  }
  
  #split the data frame by measurement_id
  measurements <- split( df, df$measurement_id )
  return( rank_diff_pair( measurements[[1]], measurements[[2]] ))
  
}


# Internal - assign numbers for each diff that will be generated
generate_diff_ids <- function( m ){
  
  measurement_series <- m
  
  # Each measurement is diff twice (with exception of first and last)
  # Assign a number to the diff, to be used for grouping the pairs of measurements to diff
  
  measurement_factor <- factor( measurement_series$measurement_id )
  
  measurement_series$diff_id1 <- as.numeric( measurement_factor )
  measurement_series$diff_id2 <- as.numeric( measurement_factor ) - 1
  
  even <- ( measurement_series$diff_id1 %% 2 ) == 0
  odd <- ( measurement_series$diff_id2 %% 2 ) == 1
  highest_id <- max( measurement_series$diff_id1 )
  
  measurement_series <- within(measurement_series, {
    
    diff_id1[ even ] <- diff_id1[ even ] - 1
    diff_id2[ odd ] <- diff_id2[ odd ] + 1
    
    diff_id1[ diff_id1 == highest_id ] <- NA
    diff_id2[ diff_id2 == highest_id ] <- NA
    diff_id2[ diff_id2 == 0 ] <- NA
    
  })
  
}


#' Generate a wide version of ranking comparison.
#' 
#' This form is useful when viewing changes in ranking in a table view. 
#' Each rank has it's own column, and each measurement it's own row
#' 
#' @param comparison the long form of the comparions (output from rank_diff_pair)
#' @return A wide dataframe with one column per ranking, one row per measurement
#' @examples
#' todo
#'
diff_wide <- function(comparison){
  
  wide_form <- dcast(comparison, measure+measurement_id~rank, value.var="id")

  #replace NA with blanks
  wide_form <- replace(wide_form, is.na(wide_form), "")

}
