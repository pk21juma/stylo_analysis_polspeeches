# data import
speeches_dat <- readRDS("./data/processed/speeches_processed.rds")
politicians_dat <- readRDS("./data/processed/politicians_processed.rds")
factions_dat <- readRDS("./data/processed/factions_processed.rds")

# grouping speeches by politicianId and concatenate speechContent
speeches_dat_grouped <- speeches_dat %>%
    group_by(politicianId) %>%
    summarise(speechContent = paste(speechContent, collapse = " "))

# looping through speeches_dat and:
#   1. extracting speeches into politiciansId.txt files
#   2. creating metadata.csv
for (i in seq_along(speeches_dat_grouped$politicianId)) {
    # get politicianId
    politician_id <- speeches_dat_grouped$politicianId[i]
    speeches <- speeches_dat_grouped$speechContent[i]
    author <- paste(
        politicians_dat$firstName[i],
        politicians_dat$lastName[i],
        sep = " "
        )
    gender <- politicians_dat$gender[i]
    faction <- speeches_dat$factionId[i]

    write.table(
        speeches,
        file = paste0("./data/corpus/", politician_id, ".txt"),
        sep = " ",
        row.names = FALSE,
        col.names = FALSE,
        quote = FALSE
    )

    df <- data.frame(
        filename = c(politician_id),
        author = c(author),
        gender = c(gender),
        faction = c(faction)
    )

    write.table(
        df,
        append = TRUE,
        file = "./data/metadata.csv",
        row.names = FALSE,
        col.names = FALSE,
        quote = FALSE,
        sep = ","
    )
}
