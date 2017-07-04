# all the functions that would be useful in an R package; top level computing functions

library(pcalg)
library(Rgraphviz)
library(grid)
library(bnlearn)
library(stringr)

# setwd("~/Viren/R/Code")

# eqivalent to estimateDAG for numerical, Gauss-distributed data instead of an MSA
estimate_DAG_from_numerical_data <- function(data, alpha, outpath, solve_conflicts = TRUE, u2pd) {
  # if (!length(only_cols) == 0) {
  #   data = data[as.character(only_cols)]
  # }
  
  n <- nrow(data)
  V <- colnames(data)
  
  suffStat <- list(C = cor(data), n=n, adaptDF = FALSE) #dm = dat$x        ### WHY COR?!
  
  sink(paste(outpath, "-pc.txt", sep = ""))
    # pc <- pc(suffStat, indepTest = ci_test_cor, alpha = alpha, labels = V, verbose = TRUE) #p=dim(MSA)[2]
    # without solve.confl = true, cycles can emerge in the final CPD"A"G.
    pc <- pc(suffStat, indepTest = gaussCItest, alpha = alpha, labels = V, verbose = TRUE, 
             solve.confl = solve_conflicts, u2pd = "retry") #p=dim(MSA)[2]
  sink()
 
  return(pc)
}