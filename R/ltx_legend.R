#' Return legend for significance stars
#'
#' @param width number of columns to be spanned
#' @param align text alignment (l, c, r)
#' @param size text size (defaults to "\\scriptsize")
#' @param sig cutoff values for significance stars
#'
#' @return string
#' @export
ltx_legend <- function(width, align="r", size="\\scriptsize", sig = c("0.01", "0.05", "0.10")){
  return(paste0("\\multicolumn{",
                width,
                "}{",
                align,
                "}{",
                size,
                "$^{***}\ p<",
                sig[1],
                "$; $^{**}\ p<",
                sig[2],
                "$; $^{*}\ p<",
                sig[3],
                "$}")
  )
}
