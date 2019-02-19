#' Rotate LaTeX cell contents
#'
#' @param df table data
#' @param row row number
#' @param col column number
#'
#' @return table data
#' @export
#'
#' @examples \dontrun{
#' ltx.sideways(df, "test", 1)
#' }
ltx_sideways <- function(df, row, col){
  df <- as.data.frame(df)

  df[row, col] <- paste0("\\begin{sideways}", df[row, col], "\\end{sideways}")

  return(df)
}
