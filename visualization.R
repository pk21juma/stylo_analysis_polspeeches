# import data
speeches_dat <- readRDS("./data/processed/speeches_processed.rds")
politicians_dat <- readRDS("./data/processed/politicians_processed.rds")
factions_dat <- readRDS("./data/processed/factions_processed.rds")
electoralterms_dat <- readRDS("./data/processed/electoral_terms.rds")

# visualisation of distribution gender of politicians
politicians_dat %>%
    ggplot(aes(x = gender, fill = gender)) +
    geom_bar() +
    labs(x = "", y = "") +
    geom_text(aes(label=..count..), stat = "count", vjust = -1) +
    scale_fill_manual(values = c("#9a3333", "#ff5d5d", "#787878"),
                        labels = c("Männlich", "Weiblich", "keine Angabe")) +
    theme(
        legend.key.size = unit(0.5, "cm"),
        legend.key = element_rect(colour = "black", size = 0.6),
        legend.justification = NULL,
        legend.position = c(0.9, 0.9),
        legend.title = element_blank(),
        axis.title =  element_blank(),
        axis.text = element_blank(),
        axis.line = element_blank(),
        panel.background = element_blank(),
    )

# saving into ./output/
ggsave(
    "gender_distribution.png",
    plot = last_plot(),
    path = "./output/plots/",
    bg = "white",
)

# visualisation of speeches per gender
speeches_dat %>%
    group_by(politicianId) %>%
    summarise(speeches = n()) %>%
    left_join(politicians_dat, by = c("politicianId" = "id")) %>%
    ggplot(aes(x = gender, y = speeches, fill = gender)) +
    geom_bar(stat = "identity") +
    labs(x = "Geschlecht", y = "Anzahl der Reden") +
    scale_fill_manual(values = c("#9a3333", "#ff5d5d", "#787878"),
                        labels = c("Männlich", "Weiblich", "keine Angabe")) +
    theme_minimal() +
    theme(
        legend.key.size = unit(0.5, "cm"),
        legend.key = element_rect(colour = "black", size = 0.6),
        legend.justification = NULL,
        legend.position = c(0.9, 0.9),
        legend.title = element_blank(),
    )

# saving into ./output/
ggsave(
    "gender_distribution_speeches.png",
    plot = last_plot(),
    path = "./output/plots/",
    bg = "white",
)

# visualisation of speeches per faction
speeches_dat %>%
    group_by(factionId) %>%
    summarise(speeches = n()) %>%
    left_join(factions_dat, by = c("factionId" = "id")) %>%
    ggplot(aes(
        x = reorder(abbreviation, speeches, FUN = desc),
        y = speeches, fill = abbreviation)) +
    geom_bar(stat = "identity") +
    labs(x = "Fraktion", y = "Anzahl der Reden") +
    scale_fill_manual(
        values = c(
            "#2a2a2a",
            "#2a2a2a",
            "#da33c1",
            "#825b0d",
            "#787878",
            "#feef47",
            "#2b2b2b",
            "#8d8b13",
            "#b59a23",
            "#24c40b",
            "#e718b7",
            "#787878",
            "#2d8bf6",
            "#fc1ec0",
            "#be1717",
            "#fffc3e",
            "#535353"
        ),
        labels = c(
            "CDU/CSU",
            "DA",
            "DIE LINKE.",
            "DP",
            "fraktionslos",
            "FDP",
            "FU",
            "FVP",
            "GB/BHE",
            "GRÜNE",
            "KPD",
            "nicht angegeben",
            "NR",
            "PDS",
            "SPD",
            "WAV",
            "Z"
        )) +
    theme_minimal() +
    theme(
        legend.key.size = unit(0.5, "cm"),
        legend.key = element_rect(colour = "black", size = 0.6),
        legend.justification = NULL,
        legend.position = c(0.9, 0.8),
        legend.title = element_blank(),
        axis.title.x =  element_blank(),
        axis.text.x = element_blank(),
    )

# saving into ./output/
ggsave(
    "faction_distribution_speeches.png",
    plot = last_plot(),
    path = "./output/plots/",
    bg = "white",
)

# visualisation of speeches per electoral term
speeches_dat %>%
    group_by(electoralTerm) %>%
    summarise(speeches = n()) %>%
    left_join(electoralterms_dat, by = c("electoralTerm" = "id")) %>%
    ggplot(aes(
        x = as.factor(electoralTerm),
        y = speeches, fill = factor(electoralTerm)
    )) +
    geom_bar(stat = "identity") +
    scale_x_discrete(labels = 1:19) +
    scale_fill_manual(
        values = c(
            "#ff5d5d",
            "#787878",
            "#787878",
            "#787878",
            "#787878",
            "#787878",
            "#787878",
            "#787878",
            "#787878",
            "#787878",
            "#787878",
            "#787878",
            "#787878",
            "#787878",
            "#ff5d5d",
            "#787878",
            "#787878",
            "#787878",
            "#787878"
        ),
        labels = c(
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19"
        )) +
    labs(x = "Wahlperiode", y = "Anzahl der Reden", fill = "Wahlperiode") +
    theme_minimal() +
    theme(legend.position = "none")

# saving into ./output/
ggsave(
    "electerm_distribution_speeches.png",
    plot = last_plot(),
    path = "./output/plots/",
    bg = "white",
)