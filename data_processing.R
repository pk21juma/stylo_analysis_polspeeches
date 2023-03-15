# data import
politicians_dat <- readRDS("./data/raw/4745895")
speeches_dat <- readRDS("./data/raw/4745978")
factions_dat <- readRDS("./data/raw/4549634")

# no need for further processing
electoralterms_dat <- readRDS("./data/raw/4549631")
saveRDS(electoralterms_dat, "./data/processed/electoral_terms.rds")

# 1. removal of irrelevant collums
# 2. filtering of all speeches not linked to a politicianId
# 3. filtering of all speeches by Presidum of Parliament/Guests
# 4. filtering speeches containing less than 100 chars
# 5. removal of politicians with less than 3 speeches
speeches_dat_filtered <- speeches_dat[-c(2, 9, 11, 12)] %>%
    filter(politicianId != "NaN") %>%
    filter(positionShort != "Presidium of Parliament") %>%
    filter(positionShort != "Guest") %>%
    filter(nchar(speechContent) > 1000) %>%
    group_by(politicianId) %>%
    filter(n() >= 100) %>%
    ungroup()

# removal of all ID notations in speeches linked
# to a contribution table in the original dataset
speeches_dat_filtered$speechContent <- gsub(
    "\\s*\\{\\d+\\}", "", speeches_dat_filtered$speechContent)

# removal of the introduced ()
speeches_dat_filtered$speechContent <- gsub(
    "\\(\\)\\s*", "", speeches_dat_filtered$speechContent)

saveRDS(speeches_dat_filtered, "./data/processed/speeches_processed.rds")

# 1. removal of irrelevant collums
# 2. filtering all politicians without speeches
politicians_dat_filtered <- politicians_dat[-c(4, 5, 6, 7, 9, 10, 11)] %>%
    semi_join(speeches_dat_filtered, join_by(id == politicianId))

saveRDS(politicians_dat_filtered, "./data/processed/politicians_processed.rds")

# filtering factions withoput speeches
factions_dat_filtered <- factions_dat %>%
    semi_join(speeches_dat_filtered, join_by(id == factionId))

saveRDS(factions_dat_filtered, "./data/processed/factions_processed.rds")