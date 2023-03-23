library(dplyr)

distSummary <- data.frame(dist = seq(1, 5), test_val = c("a", "b", "c", "d", "e"))

campFin <- data.frame(
  dist = c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5),
  party = c("R", "D", "R", "D", "R", "D", "R", "D", "R", "D"),
  candidate = c("Ricky", "Drake", "Ryan", "Dennis", "Robert", "Drew", "Richard", "Dylan", "Ronald", "Donald"),
  cash = c(500, 200, 400, 300, 250, 250, 100, 1000, 50, 350)
)

camFin_summary <- campFin %>%
  group_by(dist, party) %>%
  summarise(total_cash = sum(cash), candidate = first(candidate)) %>%
  pivot_wider(names_from = party, values_from = c(total_cash, candidate), names_sep = "_")

output <- merge(distSummary, camFin_summary, by = "dist", all = TRUE)
output
