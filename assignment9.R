# assignment9.R
# LIS4370 - Assignment #9: Visualization in R – Base Graphics, Lattice, and ggplot2
# Dataset: mtcars (from Rdatasets/datasets package)
# --------------------------------------------------
# This script creates at least one visualization from each system (base, lattice, ggplot2)
# and saves figures to a local "figs/" folder for screenshots/blog embedding.

# ---- setup ----
# Uncomment if not installed:
# install.packages(c("lattice", "ggplot2"))

library(lattice)
library(ggplot2)

# Use an Rdatasets dataset (mtcars lives in the 'datasets' package)
data("mtcars", package = "datasets")
mtcars$cyl_f <- factor(mtcars$cyl)
mtcars$gear_f <- factor(mtcars$gear)

if (!dir.exists("figs")) dir.create("figs")

# =========================
# 1) Base R Graphics
# =========================

# 1A. Scatterplot with regression line (MPG vs Weight)
png("figs/base_scatter_mpg_wt.png", width = 900, height = 600, res = 120)
plot(mtcars$wt, mtcars$mpg,
     pch = 19, col = "steelblue",
     xlab = "Weight (1000 lbs)", ylab = "Miles per Gallon (MPG)",
     main = "Base R: MPG vs Weight")
abline(lm(mpg ~ wt, data = mtcars), col = "firebrick", lwd = 2)
legend("topright", legend = c("Cars", "OLS fit"),
       pch = c(19, NA), lty = c(NA, 1), col = c("steelblue", "firebrick"), bty = "n")
dev.off()

# 1B. Histogram of MPG
png("figs/base_hist_mpg.png", width = 900, height = 600, res = 120)
hist(mtcars$mpg,
     breaks = 10, col = "gray85", border = "white",
     main = "Base R: Distribution of MPG", xlab = "MPG")
rug(mtcars$mpg)
dev.off()

# =========================
# 2) lattice Graphics
# =========================

# 2A. Conditional scatter (small multiples) MPG ~ WT | Cylinders
png("figs/lattice_xyplot_mpg_wt_by_cyl.png", width = 900, height = 600, res = 120)
print(
  xyplot(mpg ~ wt | cyl_f, data = mtcars,
         pch = 16,
         xlab = "Weight (1000 lbs)", ylab = "MPG",
         main = "lattice: MPG vs Weight by Cylinders",
         panel = function(x, y, ...) {
           panel.grid(h = -1, v = -1)
           panel.xyplot(x, y, ...)
           panel.lmline(x, y, col = "firebrick", lwd = 2)
         })
)
dev.off()

# 2B. Box-and-whisker plot of MPG by Gear
png("figs/lattice_bwplot_mpg_by_gear.png", width = 900, height = 600, res = 120)
print(
  bwplot(mpg ~ gear_f, data = mtcars,
        ylab = "MPG", xlab = "Gears",
        main = "lattice: MPG by Number of Gears")
)
dev.off()

# =========================
# 3) ggplot2 Graphics
# =========================

# 3A. Scatter with smoothing (colored by cylinders)
p1 <- ggplot(mtcars, aes(wt, mpg, color = cyl_f)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "ggplot2: MPG vs Weight (with linear trend)",
       x = "Weight (1000 lbs)", y = "MPG", color = "Cylinders") +
  theme_minimal(base_size = 13)
ggsave(filename = "figs/ggplot_scatter_mpg_wt.png", plot = p1, width = 9, height = 6, dpi = 120)

# 3B. Faceted histogram of MPG by Cylinders
p2 <- ggplot(mtcars, aes(mpg)) +
  geom_histogram(binwidth = 2) +
  facet_wrap(~ cyl_f, nrow = 1) +
  labs(title = "ggplot2: MPG Distribution by Cylinders", x = "MPG", y = "Count") +
  theme_classic(base_size = 13)
ggsave(filename = "figs/ggplot_hist_mpg_by_cyl.png", plot = p2, width = 12, height = 4, dpi = 120)

# Show what was saved (useful when running interactively)
print(list.files("figs", full.names = TRUE))
