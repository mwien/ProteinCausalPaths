source("compute_DAG_numerical.R")
source("general_functions.R")
source("evaluate_DAG.R")
## set working directory from configuration.R
source("configuration.R")

sink.reset()

## Data parameters

## available data
## TODO

numerical = TRUE
protein = "GTB"
type_of_data = "NMR-2"

## state of the protein
# state = "allstates"
# state = "all"
# state = "acc"
state = "don+acc"
# state = "all"
nuclei = "all" # "all" "1H", "13C"
position_numbering = ""

if (grepl("NMR", type_of_data)) {
  transpose = TRUE
} else {
  transpose = FALSE
}

## Analysis parameters
# TODO:
# remove_cols <- c(210) 
only_cols = NULL
only_cols_label = ""
## alpha is the level of significance
alpha = 0.2
## ## if rank is TRUE instead of the numerical NMR data simply the ranking of the positions will be used
ranked = TRUE

## TODO: explain stages
stages <- c("orig") # "sub"
plot_types <- c("localTests", "graphs")


## Graphical parameters
## choose one of the graph layouts Rgraphviz offers
graph_layout <- "dot" # "dot", "circo", "fdp", "neato", "osage", "twopi"
## what are the options here?
coloring = "auto"
colors = "auto"

## plot with clusters
plot_as_subgraphs = FALSE
## plot only cluster
plot_only_subgraphs = NULL


## Technical parameters
## those options are either set to FALSE or to TRUE (unused/used option)
## analyse DAG using dagitty
analysis = FALSE
## do not print the dagitty analysis, but save it somewhere?
print_analysis = TRUE
## plot the dagitty analysis
plot_analysis = FALSE
## compute new dag/analysis (TRUE) or use precomputed one (FALSE)
compute_pc_anew <- TRUE
compute_localTests_anew <- FALSE
## what is this doing, more information to info file?
unabbrev_r_to_info <- FALSE
## and this?
print_r_to_console <- FALSE
lines_in_abbr_of_r <- 20


# rem_apo <- c(84, 104, 120, 134, 173, 207, 224, 225, 232, 254, 256, 280, 319, 336, 339)
# rem <- c(rem_apo, rem_other)
if (type_of_data == "NMR") {
  rem_don_acc <- c(143, 175, 184, 189, 266, 329)
  rem_don <- c(210)
  if (state == "all") {
    rem <- c(rem_don_acc, rem_don)
  } else if (state == "don+acc") {
    rem <- rem_don_acc
  } else if (state == "don") {
    rem <- rem_don
  } else if (state == "acc") {
    rem <- c()
  }
} else if (type_of_data == "NMR-2") {
  rem_acc <- c(288, 329)
  rem_don <- c(210)
  rem_don_acc <- c(143, 175, 184, 189, 210, 266, 329)
  if (state == "all") {
    rem <- c(rem_don_acc, rem_don, rem_acc)
  } else if (state == "don+acc") {
    rem <- rem_don_acc
  } else if (state == "don") {
    rem <- rem_don
  } else if (state == "acc") {
    rem <- rem_acc
  }
}

# bind_donor <- c(121, 123, 126, 213, 346, 352)
# bind_acceptor <- c(233, 245, 303, 326, 348)
# intersect(bind_donor, colnames(data))
## [1] "123"
# intersect(bind_acceptor, colnames(data))
## character(0)

# Computation of Output-Location and Output Infos
# if (state == "allstates") {
#   data_list <- list()
#   for (state in c("don", "acc", "don+acc")) {
#     source_of_data = paste(protein, type_of_data, state, sep = "-")
#     filename <- paste("../Data/", source_of_data, ".csv", sep = "")
#     var <- read_data(filename, transpose = transpose)
#     rownames(var) <- paste(rownames(var), state, sep = "-")
#     data_list[state][[1]] <- var
#   }
#   data <- do.call(rbind, data_list)
# } else {

  source_of_data = paste(protein, type_of_data, state, sep = "-")
  filename <- paste("../Data/", source_of_data, ".csv", sep = "")
  data <- read_data(filename, transpose = transpose)
# }
colnames(data) <- sapply(strsplit(colnames(data), " "), function(x) x[1])

data <- rem_cols_by_colname(data, rem)

if (!is.null(nuclei) && !(nuclei == "all") && !(nuclei == "")) {
  # if (only_H) {
  #   data <- data[grepl("1H", rownames(data)), ]
  # }
  # if (only_C) {
  #   data <- data[grepl("13C", rownames(data)), ]
  # }
  data <- data[grepl(nuclei, rownames(data)), ]
  if (dim(data)[1] == 0) {
    stop("No data for these nuclei!")
  }
  state <- paste(state, nuclei, sep = "-")
  source_of_data <- paste(source_of_data, nuclei, sep = "-")
  # source_of_data <- paste(protein, type_of_data, state, sep = "-")  # sollte das gleiche liefern
}


if (ranked) {
  # if (rank) {
  # data <- cbind(apply(data, 2, rank))
  data <- t(apply(data, 1, rank))
  # }
  # if (state == "all") {
  #   stop("Data not available (ranked).")
  # } else {
  type_of_data <- paste(type_of_data, "ranked", sep = "-")
  # }
} 

filename <- paste(only_cols_label, source_of_data, "-alpha=", alpha, sep = "")
output_dir <- paste("../Outputs/", protein, "/", type_of_data, "/", filename, sep = "")
# print(paste("Output will be written to ", getwd(), "/", substring(outpath, 0, nchar(outpath)), "...", sep = ""))
if (!dir.exists(output_dir)) {
  dir.create(output_dir, showWarnings = TRUE, recursive = TRUE, mode = "0777")
  print("Directory created.")
}
outpath <- paste(output_dir, filename, sep = "/")
 
caption <- caption(protein = protein, data = paste(state, " (", type_of_data, ")", sep = ""), alpha = alpha, chars_per_line = 45)
parameters_for_info_file <- parameters_for_info_file(protein = protein, type_of_data = type_of_data, alpha = alpha, position_numbering = position_numbering, only_cols = only_cols, coloring = coloring, colors = colors, outpath = paste(output_dir, filename, sep = "/")) 

results <- protein_causal_graph(data = data, protein = protein, type_of_data = type_of_data, source_of_data = source_of_data, position_numbering = position_numbering, 
                                output_dir = output_dir, filename = filename, parameters_for_info_file = parameters_for_info_file,
                                alpha = alpha, caption = caption, analysis = analysis, stages = stages, plot_types = plot_types, coloring = coloring, colors = colors, 
                                graph_layout = graph_layout, plot_as_subgraphs = plot_as_subgraphs, plot_only_subgraphs = plot_only_subgraphs,
                                unabbrev_r_to_info = unabbrev_r_to_info, print_r_to_console = print_r_to_console, lines_in_abbr_of_r = lines_in_abbr_of_r,
                                compute_pc_anew = compute_pc_anew, compute_localTests_anew = compute_localTests_anew, 
                                print_analysis = print_analysis, plot_analysis = plot_analysis)

plot_connected_components_in_pymol(protein = protein, graph = results$orig$graph$NEL, outpath = outpath, no_colors = FALSE, only_dist = FALSE)

paths <- paths_between_nodes(graph = results$orig$graph$NEL, from = c(123, 310), to = c(207, 336), all_paths = FALSE)
plot_paths_in_pymol(protein = protein, graph = results$orig$graph$NEL, outpath = outpath, paths = paths, no_colors = FALSE, label = TRUE, show_positions = FALSE)