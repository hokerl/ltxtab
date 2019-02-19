#' Format coefficients
#'
#' @param coef coefficient value
#' @param stars significance stars
#' @param digits number of decimal places (default=2)
#' @param latex format stars as math exponents? (default: FALSE)
#'
#' @return formatted coefficients as string
#' @export
#'
format_coef <- function(coef, stars, digits=2, latex=FALSE){
  if(latex){
    paste0(sprintf(paste0("%2.",digits,"f"), coef + 0), "$^{", stars, "}$")
  } else {
    paste0(sprintf(paste0("%2.",digits,"f"), coef + 0), sprintf("%-3s", stars))
  }
}
