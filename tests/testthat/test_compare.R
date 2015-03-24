
# Data has 4 columns: rank, measurment/run id, id, measure being ranked

test_that("rank_diff_pair preserves the measurement names", {

  data(search_results)
  measurement.names <- c(first(as.character(measurement_1$mid)), 
                         first(as.character(measurement_2$mid)))
  test.result <- rank_diff_pair(measurement_1, measurement_2)
  
  expect_true( all( unique( as.character(test.result$mid) ) %in% measurement.names ) )
})


test_that("rank_diff_pair range matches input range", {
  
  data(search_results)
  test.result <- rank_diff_pair(measurement_1, measurement_2)

  expect_identical(range(test.result$rank), range(measurement_2$rank))  
})

test_that("we can generate the wide form of a diff", {
  
  data(search_results)
  test_result <- rank_diff_pair(measurement_1, measurement_2)
  wide_form <- diff_wide(test_result) 
  
  expect_equal( ncol(wide_form), max(test_result$rank) + 2 )  
})
