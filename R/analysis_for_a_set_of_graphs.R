# previously: analysis_find_good_graph.R
# previously: analysis_for_a_set_of_graphs.R
# next: partuning_alpha_by_mean_effects
source("~/.configuration_code.R")

source_all_function_scripts()

source("functions_analysis_for_a_set_of_graphs.R")
# source("functions_protein_causality.R")

# tests
source("tests_analysis_for_a_set_of_graphs.R")

# source("compute_DAG_G.R")
# source("compute_DAG_S.R")

source("configuration_data.R")

# debug(analyse_set_of_graphs)
# debug(determine_set_of_graphs)
# debug(compute_over_all_graphs)
# debug(causal_effects_ida)
# debug(score_for_effects)

new_whole = TRUE
save_whole = TRUE

new_single_runs = FALSE
save_single_runs = TRUE

# OBS!!
pc_cor_FUN = "none"
# mal einbauen, dass man das ändern kann
# ida_function = "IDA-reset"


# weitermaachen: DDG-all alpha = 0.004, min_pos_var = 0.0001

# measures <- c("DDS", "DDG-10", "DDG-5", "DDG-all", "DDDG-10", "DDDG-5", "DDDG-all")
# measures <- c("DDDG-5", "DDDG-all")

# richtige Reihenfolge von -5, -10 und -all:
# measures <- c("DDS", "DDG-5", "DDG-10", "DDG-all", "DDDG-5", "DDDG-10", "DDDG-all")
measures <- c("DDS")
# alphas <- c(1e-20, 1e-10, 1e-5, 0.0001, seq(0.001, 0.009, 0.001), seq(0.01, 0.09, 0.01), 0.1, 0.15, 0.2)
alphas <- c(0.0001, seq(0.001, 0.009, 0.001), seq(0.01, 0.09, 0.01), 0.1, 0.15, 0.2)
# alphas = c(0.001, 0.01, 0.05, 0.1)
# alphas <- c(1e-10, 1e-5, 0.0001)
min_pos_vars = c(0, 0.0000001, 0.000001, 0.00001, 0.0001, 0.001, 0.01)

file <- "RData/all_effects_corFUN-none_ida-reset_DDS.RData"

# measures <- c("DDG-5")
# alphas <- c(1e-20)
# min_pos_vars <- c(0.01)

if (new_whole || !file.exists(file)) {
  all_effects <- list()
  for (measure_type_sub in measures) {
    measure = str_sub(strsplit(measure_type_sub, "-")[[1]][1], start = -1)
    subtype_of_data = strsplit(measure_type_sub, "-")[[1]][2]
    if (is.na(subtype_of_data)) {
      subtype_of_data <- ""
    }
    # debug(analyse_set_of_graphs)
    # debug(determine_set_of_graphs)
    # debug(graph_to_results)
    # debug(causal_effects_ida)
    # debug(compute_over_all_graphs)
    # debug(mean_effects_min_max)
    
    all_effects[[measure_type_sub]] <- analyse_graphs_for_alphas_and_minposvars(measure = measure,
                                                    type_of_data = strsplit(measure_type_sub, "-")[[1]][1],
                                                    subtype_of_data = subtype_of_data,
                                                    alphas = alphas, min_pos_vars = min_pos_vars,
                                                    protein_causality_function = function_set_parameters(
                                                      get(paste0("protein_causality_", measure)), 
                                                      parameters = list(pc_cor_FUN = pc_cor_FUN)),
                                                    new = new_single_runs, save = save_single_runs)
  }
  if (save_whole) {
    save(all_effects, file = file)
  }
} else {
  load(file)
}


# do_for_measures <- function(FUN, measures) {
#   res <- list()
#   for (measure_type_sub in measures) {
#     measure = str_sub(strsplit(measure_type_sub, "-")[[1]][1], start = -1)
#     subtype_of_data = strsplit(measure_type_sub, "-")[[1]][2]
#     if (is.na(subtype_of_data)) {
#       subtype_of_data <- ""
#     }
#     res[[measure_type_sub]] <- FUN(measure = measure, type_of_data = strsplit(measure_type_sub, "-")[[1]][1],
#                                    subtype_of_data = subtype_of_data)
#     
#   }
#   return(res)
# }
# 
# 
# analyse_graphs_fct <- set_parameters(analyse_graphs_for_alphas_and_minposvars, parameters = list(alphas = alphas, min_pos_vars = min_pos_vars))
# all_effects_do <- do_for_measures(analyse_graphs_fct, measures)




