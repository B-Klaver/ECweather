


testthat::test_that("errors", {

  testthat::expect_error(

    getECdata(stations = 52,
              year_start = 2020,
              year_end = 2023,
              timeframe = "annually"),

    "That timeframe is not an option, please select one of: hourly, daily, or monthly."

  )

  testthat::expect_error(

    getECdata(stations = 52,
              year_start = 2020,
              year_end = 2023,
              timeframe = c("daily", "monthly")),

    "Please select one time frame at a time: hourly, daily, or monthly."

  )


  testthat::expect_error(

    getECdata(stations = 52,
              year_start = 2020,
              year_end = 2023,
              timeframe = c("daily"),
              download = TRUE),

    "Please provide a folder location to write the data to."

  )

  testthat::expect_error(

    getECdata(stations = 52,
              year_start = 2020,
              year_end = 2023,
              timeframe = c("daily"),
              download = TRUE,
              folder = "C:/Users/Braeden/Documents/Projects/abcd"),

    "Folder path doesn't exist."

  )




})


