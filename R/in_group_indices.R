
#' Group a data frame and add in-group indices as a column.
#'
#' @param .data data.frame
#' @param ... force later arguments to bind by name.
#' @param groupingVars character vector of column names to group by.
#' @param arrangeTerms character vector of column expressions to arrange by.
#' @param orderColumn character name of column to add in-group order marks to.
#' @return .data with in group order indices added (no ties).
#'
#' @examples
#'
#'
#' groupingVars = c("cyl", "gear")
#' datasets::mtcars %>%
#'   # dplyr doesn't currently export tibble::rownames_to_column()
#'   { mutate(., CarName = rownames(.) ) } %>%
#'   select_se(c('CarName', 'cyl', 'gear', 'hp', 'wt')) %>%
#'   add_group_indices(groupingVars = groupingVars,
#'                     indexColumn = 'groupID') %>%
#'   add_group_sub_indices(groupingVars = groupingVars,
#'                        arrangeTerms = c('desc(hp)', 'wt'),
#'                        orderColumn = 'orderInGroup') %>%
#'   arrange_se(c('groupID', 'orderInGroup'))
#'
#'
#' @export
#'
add_group_sub_indices <- function(.data,
                                 ...,
                                 groupingVars,
                                 arrangeTerms = NULL,
                                 orderColumn) {
  .data <- ungroup(.data) # just in case
  if(length(list(...))>0) {
    stop("seplyr::add_group_sub_indices unexpected arguments")
  }
  `:=` <- NULL # don't let look like an unbound reference to CRAN checker
  if(is.null(arrangeTerms)) {
    arrangeTerms <- colnames(.data)
  }
  # from: https://github.com/tidyverse/rlang/issues/116
  arrangeTerms <- lapply(arrangeTerms,
                         function(si) { rlang::parse_expr(si) })
  .data <- arrange(.data, !!!arrangeTerms)
  # add ordered row-ids globally
  d <- mutate(.data, !!orderColumn := 1 )
  d <- mutate(d, !!orderColumn := cumsum(!!rlang::sym(orderColumn)) )
  # use that to compute grouped ranks
  d <- group_by_se(d, groupingVars)
  d <- mutate(d, !!orderColumn := rank(!!rlang::sym(orderColumn)) )
  d <- ungroup(d)
  d
}
