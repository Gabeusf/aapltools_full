# Assignment #9 – Visualization in R (Base, lattice, ggplot2)

**Dataset:** `mtcars` (Rdatasets / `datasets` package)  
**Goal:** Make one visualization in each system (base, lattice, ggplot2), show code, and share takeaways.

---

## 1) Base R

### A) Scatter: MPG vs Weight + OLS
```r
plot(mtcars$wt, mtcars$mpg,
     pch = 19, col = "steelblue",
     xlab = "Weight (1000 lbs)", ylab = "Miles per Gallon (MPG)",
     main = "Base R: MPG vs Weight")
abline(lm(mpg ~ wt, data = mtcars), col = "firebrick", lwd = 2)
legend("topright", legend = c("Cars", "OLS fit"),
       pch = c(19, NA), lty = c(NA, 1), col = c("steelblue", "firebrick"), bty = "n")
```

### B) Histogram: MPG
```r
hist(mtcars$mpg,
     breaks = 10, col = "gray85", border = "white",
     main = "Base R: Distribution of MPG", xlab = "MPG")
rug(mtcars$mpg)
```

---

## 2) lattice

### A) Small multiples: MPG ~ WT by cylinders
```r
xyplot(mpg ~ wt | cyl_f, data = mtcars,
       pch = 16,
       xlab = "Weight (1000 lbs)", ylab = "MPG",
       main = "lattice: MPG vs Weight by Cylinders",
       panel = function(x, y, ...) {
         panel.grid(h = -1, v = -1)
         panel.xyplot(x, y, ...)
         panel.lmline(x, y, col = "firebrick", lwd = 2)
       })
```

### B) Boxplot: MPG by gears
```r
bwplot(mpg ~ gear_f, data = mtcars,
       ylab = "MPG", xlab = "Gears",
       main = "lattice: MPG by Number of Gears")
```

---

## 3) ggplot2

### A) Scatter + smooth
```r
ggplot(mtcars, aes(wt, mpg, color = cyl_f)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "ggplot2: MPG vs Weight (with linear trend)",
       x = "Weight (1000 lbs)", y = "MPG", color = "Cylinders") +
  theme_minimal(base_size = 13)
```

### B) Faceted histogram
```r
ggplot(mtcars, aes(mpg)) +
  geom_histogram(binwidth = 2) +
  facet_wrap(~ cyl_f, nrow = 1) +
  labs(title = "ggplot2: MPG Distribution by Cylinders", x = "MPG", y = "Count") +
  theme_classic(base_size = 13)
```

---

## Discussion (short)

- **Workflow:** Base = direct functions + add-ons; lattice = formula + conditioning; ggplot2 = layered grammar.  
- **Best "publication-ready" quickly:** ggplot2 (themes + scales are consistent).  
- **Where each shines:** lattice for small multiples; base for quick one-offs; ggplot2 for polished output.  
- **Gotchas:** `abline()` vs `panel.lmline()` vs `geom_smooth(method="lm")` when adding trend lines.

---

**How to reproduce:** Save and run `assignment9.R`, which also writes PNGs to a `figs/` folder for screenshots.
