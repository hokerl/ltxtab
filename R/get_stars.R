#' Get significance stars from p values
#'
#' @param p p values
#' @param sig cutoff values for significance stars
#'
#' @return stars
#' @export
#'
get_stars <- function(p, sig = c(0.1, 0.05, 0.01)){
  ifelse(p<sig[3], "***",
         ifelse(p<sig[2], "**",
                ifelse(p<sig[1], "*", "")))
}
