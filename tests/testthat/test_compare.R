
# Data has 4 columns: rank, measurment/run id, id, measure being ranked

test_that("rank_diff_pair preserves the measurement names", {

  data(search_results)
  measurement.names <- c(first(as.character(measurement.1$mid)), 
                         first(as.character(measurement.2$mid)))
  test.result <- rank_diff_pair(measurement.1, measurement.2)
  
  expect_true( all( unique( as.character(test.result$mid) ) %in% measurement.names ) )
})


test_that("rank_diff_pair range matches input range", {
  
  data(search_results)
  test.result <- rank_diff_pair(measurement.1, measurement.2)

  expect_identical(range(test.result$rank), range(measurement.2$rank))  
})

