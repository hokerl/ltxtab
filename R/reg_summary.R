#' Get some regression summary statistics
#'
#' @param reg regression object
#' @param vcov covariance matrix
#' @param sig cutoff values for significance stars
#' @param f.test run f-test (disabled by default)
#'
#' @return regression summary
#' @export

reg_summary <- function(reg, vcov=NULL, sig = c(0.1, 0.05, 0.01), f.test=FALSE){
  res <- summary(reg)

  if(f.test){
    wald <- lmtest::waldtest(reg, vcov=vcov)

    Fstat <- wald$F[2]
    numdf <- -wald$Df[2]
    dendf <- wald$Res.Df[1]
    p.val <- wald$`Pr(>F)`[2]

    out <- data.frame(r.squared = res$r.squared,
                      adj.r.squared = res$adj.r.squared,
                      n.obs = as.integer(stats::nobs(reg)),
                      f.stat = Fstat,
                      numdf=numdf,
                      dendf=dendf,
                      p.val = p.val,
                      stars = get_stars(p.val)
                      )
  } else {
    out <- data.frame(r.squared = res$r.squared,
                      adj.r.squared = res$adj.r.squared,
                      n.obs = as.integer(stats::nobs(reg)))
  }
  out
}
