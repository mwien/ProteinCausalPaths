graph_normal_0.01 <- protein_causality_G(combined_plot = TRUE)$pc@graph
graph_cons_0.01 <- protein_causality_G(pc_conservative = TRUE, combined_plot = TRUE)$pc@graph
graph_maj_0.01 <- protein_causality_G(pc_maj_rule = TRUE, combined_plot = TRUE)$pc@graph

graph_normal_0.05 <- protein_causality_G(alpha = 0.05, combined_plot = TRUE)$pc@graph
graph_cons_0.05 <- protein_causality_G(alpha = 0.05, pc_conservative = TRUE, combined_plot = TRUE)$pc@graph
graph_maj_0.05 <- protein_causality_G(alpha = 0.05, pc_maj_rule = TRUE, combined_plot = TRUE)$pc@graph
cat("alpha = 0.01")
cat("\n")

graphics.off()
par(mfrow = c(2,3))
barplot(unlist(conflict_edges((graph_normal_0.01))), col = c("red", "green", "yellow"), main = "normal")
barplot(unlist(conflict_edges((graph_cons_0.01))), col = c("red", "green", "yellow"), main = "conservative")
barplot(unlist(conflict_edges((graph_maj_0.01))), col = c("red", "green", "yellow"), main = "majority_rule")
cat("\n")
barplot(unlist(conflict_edges((graph_normal_0.05))), col = c("red", "green", "yellow"), main = "normal")
barplot(unlist(conflict_edges((graph_cons_0.05))), col = c("red", "green", "yellow"), main = "conservative")
barplot(unlist(conflict_edges((graph_maj_0.05))), col = c("red", "green", "yellow"), main = "majority_rule")



print(unlist(conflict_edges(graph_normal_0.01)))
print(unlist(conflict_edges(graph_cons_0.01)))
print(unlist(conflict_edges(graph_maj_0.01)))
cat("alpha = 0.05")
cat("\n")
print(unlist(conflict_edges(graph_normal_0.05)))
print(unlist(conflict_edges(graph_cons_0.05)))
print(unlist(conflict_edges(graph_maj_0.05)))