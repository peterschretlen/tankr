
measurement.1 <- read.table("./data-raw/measurement_1.txt", quote="\"")
measurement.2 <- read.table("./data-raw/measurement_2.txt", quote="\"")

col.names <- c("rank", "measurement.id", "id", "measure")
names(measurement.1) <- col.names
names(measurement.2) <- col.names

save(measurement.1, measurement.2, file = "./data/search_results.RData")