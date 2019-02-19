#' Export data frame to LaTeX file
#'
#'
#' @param df table data
#' @param file file name
#' @param eol named vector of end-of-line strings
#' @param footer string to be added after the bottom rule
#' @param col.types string of column types
#' @param full.size use tabularx if TRUE, else tabular
#' @param demo create demo latex document (ready-to-compile), disables full.size export
#' @param outer.rules add top and bottom rule automatically (otherwise: specify in eol parameter)
#' @param filter.columns remove column names starting with a dot
#' @param split.column create multiple tables based on the distinct values of this column, NA entries correspond to global headers/footers.
#'
#' @export
#'
#' @examples \dontrun{
#' ltx.write(mtcars, "mtcars.tex")
#' }
ltx_export <- function(df, file, eol=c("1"="\\midrule"), footer=NA_character_,
                      col.types = paste0(rep("l", ncol(df)), collapse=""), full.size=F,
                      demo=F, outer.rules=TRUE, filter.columns=TRUE,
                      split.column = NULL){

  if(demo){
    full.size=FALSE
  }

  # add expanding column if not specified
  if(full.size && ncol(df) > 1 && !grepl("@", col.types, fixed=T) &&
     !grepl("X", col.types, fixed=T)){
    col.types <- paste0("@{}",
                        substr(col.types, 1, 1),
                        "@{\\extracolsep\\fill}",
                        substr(col.types, 2, nchar(col.types)),
                        "@{}")
  }

  df[] <- lapply(df, as.character)
  df <- dplyr::mutate_all(df, trimws)

  if(filter.columns){
    N.space <- 1
    for(i in 1:length(colnames(df))){
      if(substr(colnames(df)[i], 1, 1) == "." && (is.null(split.column) || colnames(df)[i] != split.column)){
        colnames(df)[i] <- strrep(" ", N.space)
        N.space <- N.space + 1
      }
    }
  }



  # add separators

  if(!is.null(split.column)){
    split.col <- dplyr::pull(df, split.column)
    df <- df[, names(df) != split.column, drop=F]
  }

  df <- as.matrix(df)
  df[is.na(df)] <- ""
  for(i in 1:nrow(df)){
    for(j in 2:ncol(df)){
      if(df[i,j] != "[MULTI]"){
        df[i,j] <- paste0("& ", df[i,j])
      } else {
        df[i,j] <- ""
      }
    }

    if(df[i, ncol(df)] == "[MULTI]"){
      df[i, ncol(df)] <- ""
    }

    if(!is.na(eol[as.character(i)])){
      df[i, ncol(df)] <- paste0(df[i, ncol(df)], " \\\\", eol[as.character(i)])
    } else {
      df[i, ncol(df)] <- paste0(df[i, ncol(df)], " \\\\")
    }

  }

  file.base <- gsub(pattern = ".tex", replacement = "", x = file, fixed = TRUE)
  MM <- df

  write.file <- function(M, file){

    file.create(file)
    if(demo){
      ltxtab::write_text(file, paste0("\\documentclass[border=5pt]{standalone}\n",
                                        "\\usepackage{booktabs,amsmath,multirow,rotating,siunitx}\n",
                                        "\\begin{document}\n"))
    }

    if(full.size){
      tabular <- "tabularx}{\\linewidth"
    } else {
      tabular <- "tabular"
    }

    write_text(file, paste0("\\begin{",
                                      tabular,
                                      "}{",
                                      col.types,
                                      "}\n"))
    if(outer.rules){
      ltxtab::write_text(file, "\\toprule\n")
    }
    if (!requireNamespace("gdata", quietly = TRUE)){
      utils::write.table(M, file, append=T, sep=" ", quote = F, row.names = F, na = "", col.names = F, eol = "\n")
    } else {
      gdata::write.fwf(M, file, append=T, sep=" ", quote=F, rownames=F, na = "",
                colnames=F, eol="\n")
    }

    if(outer.rules){
      ltxtab::write_text(file, "\\bottomrule\n")
    }
    if(!is.na(footer)){
      ltxtab::write_text(file, footer, "\n")
    }

    if(full.size){
      ltxtab::write_text(file, "\\end{tabularx}\n")
    } else {
      ltxtab::write_text(file, "\\end{tabular}\n")
    }

    if(demo){
      ltxtab::write_text(file, "\\end{document}\n")
    }
  }


  if(!is.null(split.column)){
    keys <- as.vector(unique(split.col))
    keys <- keys[!is.na(keys)]

    for(key in keys){
      df <- MM[which(split.col == key | is.na(split.col)),,drop=F]
      file <- paste0(file.base, "_", gsub('[^a-zA-Z0-9]', '_', key), ".tex")
      write.file(df, file)
    }

  } else {
    write.file(df, file)

  }
}

