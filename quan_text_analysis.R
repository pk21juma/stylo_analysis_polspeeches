# import data
speeches_dat_qta <- readRDS("./data/processed/speeches_processed.rds")

speeches_et_grouped <- speeches_dat_qta %>%
    group_by(electoralTerm) %>%
    filter(any(electoralTerm == 1 | electoralTerm == 15)) %>%
    summarise(speechContent = paste(speechContent, collapse = " "))

# building the corpus
et_corpus <- corpus(speeches_et_grouped, docid_field = "electoralTerm", text_field = "speechContent")

# extracting and reshaping term 1 as corpus
et_corpus_1 <- corpus_reshape(et_corpus["1"], to = "paragraphs")

# removing stopwords and punctuation
et_corpus_1 <- tokens(et_corpus_1, remove_punct = TRUE, remove_numbers = TRUE) %>% 
  tokens_remove(pattern = stopwords("de", source = "marimo")) %>% 
  tokens_keep(pattern = "^[\\p{script=Latn}]+$", valuetype = "regex")

# analysing term 1
et_corpus_1_dfm <- dfm(et_corpus_1)
textplot_wordcloud(et_corpus_1_dfm, min_count = 10, max_words = 100)

et_corpus_1_topwords <- topfeatures(et_corpus_1_dfm, 50)
topDf_1 <- data.frame(
    list(
        term = names(et_corpus_1_topwords),
        frequency = unname(et_corpus_1_topwords)
    )
)
topDf_1$term <- with(topDf_1, reorder(term, -frequency))

ggplot(topDf_1) + geom_point(aes(x=term, y=frequency)) +
    theme(axis.text.x=element_text(angle=90, hjust=1))

ggsave(
    "et_1_frq.png",
    plot = last_plot(),
    path = "./output/plots/",
    bg = "white",
)

# extracting and reshaping term 15 as corpus
et_corpus_15 <- corpus_reshape(et_corpus["15"], to = "paragraphs")

# removing stopwords and punctuation
et_corpus_15 <- tokens(et_corpus_15, remove_punct = TRUE, remove_numbers = TRUE) %>% 
  tokens_remove(pattern = stopwords("de", source = "marimo")) %>% 
  tokens_keep(pattern = "^[\\p{script=Latn}]+$", valuetype = "regex")

# # analysing term 15
et_corpus_15_dfm <- dfm(et_corpus_15)
textplot_wordcloud(et_corpus_15_dfm, min_count = 10, max_words = 100)

et_corpus_15_topwords <- topfeatures(et_corpus_15_dfm, 50)
topDf_15 <- data.frame(
    list(
        term = names(et_corpus_15_topwords),
        frequency = unname(et_corpus_15_topwords)
    )
)
topDf_15$term <- with(topDf_15, reorder(term, -frequency))

ggplot(topDf_15) + geom_point(aes(x=term, y=frequency)) +
    theme(axis.text.x=element_text(angle=90, hjust=1))

ggsave(
    "et_15_frq.png",
    plot = last_plot(),
    path = "./output/plots/",
    bg = "white",
)