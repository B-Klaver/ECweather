

testthat::test_that("errors", {

  testthat::expect_error(

    getECurls(id = 1,
              year_start = 2020,
              year_end = 2023,
              timeframe = "annually"),

    "That timeframe is not an option, please select one of: hourly, daily, or monthly."

  )

  testthat::expect_error(

    getECurls(id = 1,
              year_start = 2020,
              year_end = 2023,
              timeframe = c("daily", "monthly")),

    "Please select one time frame at a time: hourly, daily, or monthly."

  )


  testthat::expect_error(

    getECurls(id = c(1, 3, 4),
              year_start = 2020,
              year_end = 2023,
              timeframe = c("daily")),

    "Please select one weather station ID at a time."

  )

})













test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})
