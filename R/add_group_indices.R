
#' Group a data frame and add per-group indices as a column.
#'
#' @param .data data.frame
#' @param groupingVars character vector of column names to group by.
#' @param indexColumn character name of column to add indices to.
#' @return .data with group identifying column added.
#'
#' @examples
#'
#' add_group_indices(datasets::mtcars, c("cyl", "gear"), 'groupID')
#'
#' @export
#'
add_group_indices <- function(.data, groupingVars, indexColumn) {
  .data <- ungroup(.data) # just in case
  `:=` <- NULL # don't let look like an unbound reference to CRAN checker
  d <- distinct(select_se(.data, groupingVars))
  d <- mutate(d, !!indexColumn := 1 )
  d <- arrange_se(d, groupingVars)
  d <- mutate(d, !!indexColumn := cumsum(!!rlang::sym(indexColumn)) )
  left_join(.data, d, by = groupingVars)
}
