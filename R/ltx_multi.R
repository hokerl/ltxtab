#' Join table cells for LaTeX export
#'
#' @param df data frame
#' @param start top-left coordinate (2-dim vector, or 4-dim vector)
#' @param end bottom-right coordinate (2-dim vector or NULL)
#' @param align horizontal alignment of multicol (defaults to "c")
#'
#' @return data frame
#' @export
#'
#' @examples \dontrun{
#' ltx.multi(df, c(2,2), c(3,4))
#' }
ltx_multi <- function(df, start, end=NULL, align="c"){
  names <- colnames(df)
  df <- as.matrix(df)


  if(is.numeric(start) && length(start) == 4){
    end <- start[3:4]
    start <- start[1:2]
  } else if (!is.numeric(start) | !is.numeric(end) | length(start) != 2 | length(end) != 2){
    stop("Invalid parameters")
  }

  i1 <- start[1]
  i2 <- end[1]
  j1 <- start[2]
  j2 <- end[2]

  N.row <- 1 + i2 - i1
  N.col <- 1 + j2 - j1

  for(i in i1:i2){
    for(j in j1:j2){
      if(i==i1 && j==j1){
        if(N.row > 1){
          df[i,j] <- paste0("\\multirow{", N.row, "}[0]{*}{",
                           df[i,j], "}")
        }
        if(N.col > 1){
          df[i,j] <- paste0("\\multicolumn{", N.col, "}{", align, "}{",
                           df[i,j], "}")
        }
      } else if(j>j1){
        df[i,j] <- "[MULTI]"
      } else if(i>i1 && j==j1 && N.row > 1 && N.col > 1){
        df[i,j] <- paste0("\\multicolumn{", N.col, "}{", align, "}{}")
      } else {
        df[i,j] <- " "
      }
    }
  }
  df <- data.frame(df)
  colnames(df) <- names
  return(df)
}