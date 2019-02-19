#' Increasing integer sequences
#'
#' Generate integer sequence from a to b, but return an empty sequence if a > b
#'
#' @param a start value
#' @param b end value
#' @param ... parameters passed to seq
#'
#' @return a, a+1, ..., b
#' @export
#'
iseq <- function(a,b, ...){
  seq(a, b, len=max(0, b-a+1), ...)
}
