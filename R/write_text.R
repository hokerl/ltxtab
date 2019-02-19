#' Append text to a file
#'
#' @param file text file (already existing)
#' @param ... one or multiple strings (to be pasted and written)
#'
#'
#' @keywords internal
#' @export
#'
#'
#' @examples write_text("test.txt", "hello", "world", "\n")
write_text <- function(file, ...){
  sink(file, append=T)
  cat(paste0(...))
  sink(NULL)
}