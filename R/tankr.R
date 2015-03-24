
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
