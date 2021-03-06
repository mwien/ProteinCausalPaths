disCItest_given_nmin <- function(n_min) {
  return(function(x, y, S, stat) {
    stat$dm <- replace_with_numbers(stat$dm)
    gSquareDis(x, y, S, dm = stat$dm, nlev = stat$nlev, 
                                            adaptDF = stat$adaptDF, n.min = n_min, verbose = TRUE)})
}
# staggered <- function(measure, ...){
#   return( function(x) applyStaggered(x, measure, ...) )
# }
#### disCItest_nmin <- disCItest_given_nmin(1000)
# disCItest_nmin_1000 <- function(x, y, S, stat) {
#   gSquareDis(x, y, S, dm = stat$dm, nlev = stat$nlev, adaptDF = stat$adaptDF, n.min = 1000, verbose = TRUE)
# }

# ## TODO: Wrapper für ci.test schreiben und hier verwenden
# ci_test_wrapper <- function() {
# }

ci_test_pc <- function(test, ...) {
  if (missing(test)) {
    return(function(x, y, S, stat, ...) {
      colnames(stat$dm) <- paste("P", seq(1:dim(stat$dm)[2]), sep = "")
      if (length(S) == 0) {
        result <- ci.test(x = paste("P", x, sep = ""), y = paste("P", y, sep = ""), data = data.frame(stat$dm), debug = TRUE, ...)
      } else {
        z = paste("P", S, sep = "")
        result <- ci.test(x = paste("P", x, sep = ""), y = paste("P", y, sep = ""), z = z, data = data.frame(stat$dm), debug = TRUE, ...)
      }
      return(result$p.value)
    })
  } else {
    return(function(x, y, S, stat, ...) {
      # colnames(stat$dm) <- paste("P", seq(1:dim(stat$dm)[2]), sep = "")
      if (length(S) == 0) {
        result <- ci.test(x = paste("P", x, sep = ""), y = paste("P", y, sep = ""), data = data.frame(stat$dm), test = test, debug = TRUE, B = 1, ...)
      } else {
        z = paste("P", S, sep = "")
        result <- ci.test(x = paste("P", x, sep = ""), y = paste("P", y, sep = ""), z = z, data = data.frame(stat$dm), test = test, debug = TRUE, ...)
      }
      return(result$p.value)
    })
  }
}

ci_test_pc_chi_square <- ci_test_pc("x2")

ci_test_cor <- ci_test_pc("cor")
