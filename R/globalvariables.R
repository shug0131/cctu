utils::globalVariables(c("."))
# may well have to add "cctu_env" to the line above. But I can't get devtools::check() to work past installing,
#so impossible to check at the moment.
cctu_env <- new.env(parent= emptyenv())
cctu_env$number <- "0"
cctu_env$sumby_count <- 0
cctu_env$nested_run_batch <- FALSE

# Missing data report
cctu_env$missing_report_data <- setNames(data.frame(matrix(ncol = 8, nrow = 0)),
                                         c("form", "visit_var", "visit_label", 
                                           "visit", "variable", "label", "missing_pct",
                                           "subject_ID"))
# Setup DLU file                                           
cctu_env$dlu <- NULL

#.reserved <- character(0)

