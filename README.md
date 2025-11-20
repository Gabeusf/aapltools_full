# aapltools_full

## Overview
This R package was developed as the final project for LIS4370: Data Mining. The package provides utilities for analyzing Apple (AAPL) financial time series data, including daily returns, rolling volatility, price visualization, and summary statistics.

The project demonstrates:
- Proper R package structure
- Use of `DESCRIPTION`, `NAMESPACE`, and roxygen2 documentation
- Custom R functions with S3 method implementation
- Inclusion of a clean dataset
- Creation of help files in /man
- A reproducible GitHub repository for peer review

## Package Functions
1. `aapl_daily_returns()` – Calculates daily log returns from AAPL closing prices.  
2. `aapl_rolling_volatility()` – Computes rolling volatility over a chosen window.  
3. `aapl_plot_prices()` – Plots AAPL price history using ggplot2.  
4. `aapl_summary()` – S3 summary method for the returns object.

## Dataset
The package includes:
- `aapl_sample` – A curated dataset of Apple stock price history.

The dataset is stored in the `data/` directory and is available after loading the package.

## Installation
You can install the package from GitHub using:

```r
# install.packages("devtools")
devtools::install_github("Gabeusf/aapltools_full")
```

## Basic Usage Example

```r
library(aapltools_full)

data(aapl_sample)

# Daily returns
returns <- aapl_daily_returns(aapl_sample)

# Rolling volatility
vol <- aapl_rolling_volatility(returns, window = 20)

# Plot prices
aapl_plot_prices(aapl_sample)

# Summary
summary(returns)
```

## Author
Gabriel Myles  
University of South Florida  
LIS4370 – Fall 2025
