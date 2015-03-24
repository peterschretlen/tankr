
rank_diff_pair <- function( m1, m2 ){
  
  m1id.name <- first( m1$measurement.id )
  m2id.name <- first( m2$measurement.id )
  
  m1$measurement.id <- "m1"
  m2$measurement.id <- "m2"
  
  m.pair <- rbind( m1, m2 )
  
  #convert to long
  m.pair.long <- dcast( m.pair, measure+rank~measurement.id, value.var="id")
  
  compare <- m.pair.long %>% 
              group_by( measure ) %>% 
              mutate( new.rank.relative.old = rank-match( m1, m2 )) %>%
              mutate( old.rank.relative.new = match( m2, m1 ) - rank ) %>%
              mutate( rm = is.na( new.rank.relative.old )) %>% 
              mutate( add = is.na( old.rank.relative.new ))
            
  #Now convert wide back to long
  compare.names <- c("measure","rank","id","transient", "slope", "measurement.id")
  compare.before <- compare %>% select(measure, rank, m1, rm, new.rank.relative.old)
  compare.before$measurement.id <- m1id.name
  names(compare.before) <- compare.names
  
  compare.after <- compare %>% select( measure, rank, m2, add, old.rank.relative.new)
  compare.after$measurement.id <- m2id.name
  names(compare.after) <- compare.names
  
  comparison <- rbind(compare.before, compare.after)
  
  return( comparison )
}


