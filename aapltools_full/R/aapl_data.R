# Sample Apple (AAPL) Daily Price Data
# This object is created when the package is loaded and can be accessed
# directly as `aapl_sample` after calling library(aapltools).

aapl_sample <- (function() {
  set.seed(123)
  n <- 120
  dates <- seq(as.Date("2023-01-01"), by = "day", length.out = n)

  base_price <- 150
  shocks <- rnorm(n, mean = 0.05, sd = 1.5)
  price <- base_price + cumsum(shocks)

  open <- price + rnorm(n, 0, 0.7)
  close <- price + rnorm(n, 0, 0.7)
  volume <- round(runif(n, min = 60000000, max = 120000000))

  data.frame(
    date   = dates,
    open   = round(open, 2),
    close  = round(close, 2),
    volume = volume
  )
})()
