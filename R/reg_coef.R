#' Get regression coefficients and significance stars
#'
#' @param reg regression object
#' @param vcov covariance matrix, defaults to OLS
#' @param sig cutoff values for significance stars
#'
#' @return data frame with coefficients and statistics
#' @export
#'

reg_coef <- function(reg, vcov=NULL, sig = c(0.1, 0.05, 0.01)){
  res <- summary(reg)
  coef <- lmtest::coeftest(reg, vcov)
  coef <- as.data.frame(coef[,,drop=F])
  coef <- tibble::rownames_to_column(coef, var="term")
  coef <- dplyr::rename(coef,
                        estimate = "Estimate",
                        std.error = "Std. Error",
                        statistic = "t value",
                        p.value = "Pr(>|t|)")
  coef <- dplyr::mutate(coef, stars = get_stars(coef$p.value, sig))
  coef
}

