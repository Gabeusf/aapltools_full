# Core analysis functions for the aapltools package

#' Calculate Daily Returns for AAPL
#'
#' Computes simple daily returns for the Apple stock sample dataset or
#' any data frame with a date and price column.
#'
#' @param data A data frame containing at least a date column and a price column.
#' @param price_col Name of the column to use as the price variable.
#'   Defaults to "close".
#'
#' @return A data frame with columns date, price, and return, where return
#'   is the simple daily return.
#'
#' @examples
#' returns <- aapl_daily_returns(aapl_sample)
#' head(returns)
aapl_daily_returns <- function(data, price_col = "close") {
  if (!"date" %in% names(data)) {
    stop("Data must contain a 'date' column.")
  }

  if (!price_col %in% names(data)) {
    stop("Column '", price_col, "' not found in data.")
  }

  df <- data[order(data$date), ]
  price <- df[[price_col]]

  if (!is.numeric(price)) {
    stop("Price column must be numeric.")
  }

  ret <- c(NA, diff(price) / head(price, -1))

  out <- data.frame(
    date   = df$date,
    price  = price,
    return = ret
  )

  out
}

#' Rolling Volatility of AAPL Returns
#'
#' Calculates rolling volatility (standard deviation) of daily returns
#' over a specified window.
#'
#' @param data A data frame, ideally the output of aapl_daily_returns(),
#'   containing a return column.
#' @param window Integer size of the rolling window in days. Default is 20.
#'
#' @return A data frame with columns date and volatility.
#'
#' @examples
#' returns <- aapl_daily_returns(aapl_sample)
#' vol <- aapl_rolling_volatility(returns, window = 20)
#' head(vol)
aapl_rolling_volatility <- function(data, window = 20) {
  if (!"return" %in% names(data)) {
    stop("Data must contain a 'return' column, e.g., from aapl_daily_returns().")
  }

  ret <- data$return

  if (!is.numeric(ret)) {
    stop("'return' column must be numeric.")
  }

  n <- length(ret)
  vol <- rep(NA_real_, n)

  for (i in seq_len(n)) {
    if (i >= window) {
      window_vals <- ret[(i - window + 1):i]
      vol[i] <- stats::sd(window_vals, na.rm = TRUE)
    }
  }

  data.frame(
    date       = data$date,
    volatility = vol
  )
}

#' Plot AAPL Price History
#'
#' Creates a ggplot line chart of the specified price column (default: closing
#' price) over time.
#'
#' @param data A data frame containing at least date and a price column.
#' @param price_col Name of the price column to plot. Defaults to "close".
#'
#' @return A ggplot object that can be printed or further customized.
#'
#' @examples
#' aapl_plot_prices(aapl_sample)
aapl_plot_prices <- function(data, price_col = "close") {
  if (!"date" %in% names(data)) {
    stop("Data must contain a 'date' column.")
  }

  if (!price_col %in% names(data)) {
    stop("Column '", price_col, "' not found in data.")
  }

  p <- ggplot2::ggplot(data, ggplot2::aes(x = date, y = .data[[price_col]])) +
    ggplot2::geom_line() +
    ggplot2::labs(
      title = "Apple (AAPL) Price History",
      x = "Date",
      y = "Price (USD)"
    ) +
    ggplot2::theme_minimal()

  p
}

#' Summarize AAPL Price and Return Behavior
#'
#' Generates a simple summary object for the Apple stock data including
#' basic statistics on prices and returns.
#'
#' @param data A data frame, typically aapl_sample or the result of
#'   aapl_daily_returns().
#' @param price_col Name of the price column to summarize. Defaults to "close".
#'
#' @return An object of class "aapl_summary" containing summary statistics.
#'
#' @examples
#' returns <- aapl_daily_returns(aapl_sample)
#' s <- aapl_summary(returns)
#' s
aapl_summary <- function(data, price_col = "close") {
  if (!price_col %in% names(data)) {
    stop("Column '", price_col, "' not found in data.")
  }

  price <- data[[price_col]]

  if (!is.numeric(price)) {
    stop("Price column must be numeric.")
  }

  price_stats <- c(
    min   = min(price, na.rm = TRUE),
    mean  = mean(price, na.rm = TRUE),
    max   = max(price, na.rm = TRUE),
    sd    = stats::sd(price, na.rm = TRUE)
  )

  if ("return" %in% names(data) && is.numeric(data$return)) {
    ret <- data$return
    return_stats <- c(
      mean = mean(ret, na.rm = TRUE),
      sd   = stats::sd(ret, na.rm = TRUE)
    )
  } else {
    return_stats <- NA
  }

  out <- list(
    price_stats    = price_stats,
    return_stats   = return_stats,
    n_observations = nrow(data)
  )

  class(out) <- "aapl_summary"
  out
}

# Custom print method for aapl_summary objects
print.aapl_summary <- function(x, ...) {
  cat("=== AAPL Summary ===\n")
  cat("Number of observations:", x$n_observations, "\n\n")

  cat("Price statistics:\n")
  print(round(x$price_stats, 2))
  cat("\n")

  if (!all(is.na(x$return_stats))) {
    cat("Return statistics:\n")
    print(round(x$return_stats, 4))
  } else {
    cat("Return statistics: not available (no 'return' column).\n")
  }

  invisible(x)
}
