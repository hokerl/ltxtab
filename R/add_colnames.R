#' Insert column names as new row
#'
#'
#' @param df data frame
#' @param pos position of new row
#' @param filter.columns do not insert column names starting with a dot
#' @param wrap if TRUE, column names are enclosed in braces
#'
#' @return data frame with character columns and one additional row
#' @export
#'
add_colnames <- function(df, pos=1, filter.columns=TRUE, wrap=FALSE) {
  df <- dplyr::mutate_all(df, as.character)
  names <- colnames(df)
  if(filter.columns){
    names[substr(names,1,1) == "."] <- NA_character_
  }
  if(wrap){
    names <- ifelse(is.na(names), names, paste0("{", names, "}"))
  }
  out <- rbind(df[iseq(1,pos-1),], names, df[iseq(pos,nrow(df)),])
  out
}
