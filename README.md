# ltxtab
Export LaTeX Tables from R. In principle, it can export anything that can be casted to a data frame.

## Simple example

```R
library(ltxtab)
library(tidyverse)
mtcars %>% 
  head() %>% 
  add_colnames() %>% 
  ltx_export("mtcars.tex")
```
generates a LaTeX file _mtcars.tex_ with the following contents:
```LaTeX
\begin{tabular}{lllllllllll}
\toprule
mpg  & cyl & disp & hp  & drat & wt    & qsec  & vs & am & gear & carb \\\midrule
21   & 6   & 160  & 110 & 3.9  & 2.62  & 16.46 & 0  & 1  & 4    & 4 \\            
21   & 6   & 160  & 110 & 3.9  & 2.875 & 17.02 & 0  & 1  & 4    & 4 \\            
22.8 & 4   & 108  & 93  & 3.85 & 2.32  & 18.61 & 1  & 1  & 4    & 1 \\            
21.4 & 6   & 258  & 110 & 3.08 & 3.215 & 19.44 & 1  & 0  & 3    & 1 \\            
18.7 & 8   & 360  & 175 & 3.15 & 3.44  & 17.02 & 0  & 0  & 3    & 2 \\            
18.1 & 6   & 225  & 105 & 2.76 & 3.46  & 20.22 & 1  & 0  & 3    & 1 \\            
\bottomrule
\end{tabular}
```

## Regression tables
The package also provides helper functions to produce customized regression tables:

```R
library(ltxtab)
library(tidyverse)

mtcars %>% 
  nest() %>% 
  mutate("{(1)}" = map(data, ~ lm(mpg ~ cyl, .)),
         "{(2)}" = map(data, ~ lm(mpg ~ disp, .)),
         "{(3)}" = map(data, ~ lm(mpg ~ cyl + disp, .))) %>% 
  select(-data) %>% 
  gather(model, result) %>% 
  mutate(result = map(result, ~ reg_coef(.))) %>% 
  unnest(result) %>% 
  transmute(model, .term = term, coef = format_coef(estimate, stars, latex = TRUE)) %>% 
  spread(model, coef) %>% 
  add_colnames() %>% 
  add_row("{(1)}" = "Regression model", .before = 1) %>% 
  ltx_multi(c(1,2,1,4)) %>% 
  ltx_export(file = "regression.tex",
             col.types = "lSSS",
             eol = c("1" = "\\cmidrule{2-4}",
                     "2" = "\\midrule"), 
             demo = TRUE)
```
which generates the following output:
```LaTeX
\documentclass[border=5pt]{standalone}
\usepackage{booktabs,amsmath,multirow,rotating,siunitx}
\begin{document}
\begin{tabular}{lSSS}
\toprule
            & \multicolumn{3}{c}{Regression model}                  \\\cmidrule{2-4}
            & {(1)}                                 & {(2)}         & {(3)} \\\midrule
(Intercept) & 37.88$^{***}$                         & 29.60$^{***}$ & 34.66$^{***}$ \\
cyl         & -2.88$^{***}$                         &               & -1.59$^{**}$ \\
disp        &                                       & -0.04$^{***}$ & -0.02$^{*}$ \\
\bottomrule
\end{tabular}
\end{document}
```
