
measurement_1 <- read.table("./data-raw/measurement_1.txt", quote="\"")
measurement_2 <- read.table("./data-raw/measurement_2.txt", quote="\"")

col.names <- c("rank", "measurement_id", "id", "measure")
names(measurement_1) <- col.names
names(measurement_2) <- col.names

save(measurement_1, measurement_2, file = "./data/search_results.RData")