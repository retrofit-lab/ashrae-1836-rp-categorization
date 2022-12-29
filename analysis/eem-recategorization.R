## -----------------------------------------------------------------------------------------------
## Title: EEM-recategorization.R
## Purpose: Categorizes EEM lists according to the standardized EEM categorization system using
## the categorization tags developed during 1836-RP
## Author: Apoorv Khanuja and Amanda Webb
## Date: December 28, 2022
## -----------------------------------------------------------------------------------------------


### Setup

# Load required packages
library(tidyverse)
library(tidytext)
library(tokenizers) # for 1-n gram tokenization


### Step 1: Import data 

# Load categorization tags
tag_list <- read_csv("../data/categorization-tags.csv")

# Load one of the two samples provided with the script or a custom EEM list
sample_eems <- read_csv("../data/sample-eems.csv") # 5% random sample of EEMs from the main list
#sample_eems <- read_csv("../data/building-sync.csv") # List of BuildingSync EEMs

# Load the manually assigned categories for the EEM samples (For calculating metrics 3 and 4)
#ground_truth_sample <- read_csv("../data/sample-eems-ground-truth.csv") # Ground truth for the 5% random sample 
ground_truth_bsync <- read_csv("../data/building-sync-ground-truth.csv") # Ground truth for the BuildingSync sample

### Step 2: Pre-processing

## Tokenize tags and count the range of number of tokens in the tag list
# This will help decide the range of n in n-grams to be used to tokenize the EEM names
tokenized_tag_list <- tag_list %>% 
  select(keyword) %>% 
  unnest_tokens(word, keyword, token = "words", drop = FALSE)

tag_token_counts <- tokenized_tag_list %>% 
  count(keyword)
range(tag_token_counts$n)
# The tags range from 1 to 5 words in length.
# So in order to look for these tags within the EEM names,  
# EEM names need to be tokenized as n-grams where n ranges from 1 to 5

## Tokenize EEM names
# Create a list of tokens for each EEM name
token_1_5grams <- tokenize_ngrams(sample_eems$eem_name, lowercase = TRUE, n = 5, n_min = 1)

# Map the list as a dataframe
eem_tokens <- map_df(token_1_5grams, ~as.data.frame(.x), .id="id")

eem_tokens$id <- as.numeric(eem_tokens$id)
eem_tokens <- dplyr::rename(eem_tokens, tokens = .x)


### Step 3: Search, Tag, and Categorize EEMs

# Tagging all tokens with relevant categorization tags
# and using them to re-categorize the EEMs according to UNIFORMAT

for (i in 1:nrow(tag_list)) {
  for (j in 1:nrow(eem_tokens)) {
    # Look for keywords (tag_list, column 1) in EEM name tokens (eem_tokens, column 2)
    # Add corresponding tags and associated UNIFORMAT category to the EEM name tokens
    if(grepl(paste0("^", tag_list[i,1]), eem_tokens[j,2], ignore.case=TRUE) == 1){
      eem_tokens[j,3] <- tag_list[i,1] # keyword
      eem_tokens[j,4] <- tag_list[i,2] # tag type
      eem_tokens[j,5] <- tag_list[i,3] # UNI code
      eem_tokens[j,6] <- tag_list[i,4] # UNI level 1 category
      eem_tokens[j,7] <- tag_list[i,5] # UNI level 2 category
      eem_tokens[j,8] <- tag_list[i,6] # UNI level 3 category
    }
  }
}


### Step 4: Export data

## Sheet 1: Tagged EEMs

# Extract tagged tokens from within EEM name tokens
tagged_tokens <- filter(eem_tokens, !is.na(eem_tokens$keyword)) %>% 
  select(- tokens) %>%
  unique() # this unique preserves only 1 instance of the tag within each EEM (even if that tag shows up multiple times)

# Merge these tokens with the original EEM sample
sheet_1_tagged_eems <- data.frame()

for (i in 1:nrow(tagged_tokens)){
  sheet_1_tagged_eems[i,1] <- sample_eems[tagged_tokens$id[i], 1]
  sheet_1_tagged_eems[i,2] <- sample_eems[tagged_tokens$id[i], 2]
  sheet_1_tagged_eems[i,3] <- sample_eems[tagged_tokens$id[i], 3]
  sheet_1_tagged_eems[i,4] <- sample_eems[tagged_tokens$id[i], 4]
  sheet_1_tagged_eems[i,5] <- sample_eems[tagged_tokens$id[i], 5]
  sheet_1_tagged_eems[i,6] <- tagged_tokens[i, 2]
  sheet_1_tagged_eems[i,7] <- tagged_tokens[i, 3]
  sheet_1_tagged_eems[i,8] <- tagged_tokens[i, 4]
  sheet_1_tagged_eems[i,9] <- tagged_tokens[i, 5]
  sheet_1_tagged_eems[i,10] <- tagged_tokens[i, 6]
  sheet_1_tagged_eems[i,11] <- tagged_tokens[i, 7]
}

sheet_1_tagged_eems <- dplyr::rename(sheet_1_tagged_eems, 
                           tags = V6, 
                           type = V7, 
                           uni_code = V8, 
                           uni_level_1 = V9, 
                           uni_level_2 = V10, 
                           uni_level_3 = V11)

# Export results as CSV
write_csv(sheet_1_tagged_eems, "../results/random-5-percent-sample/sheet-1-tagged-eems.csv") # For the 5% random sample 
#write_csv(sheet_1_tagged_eems, "../results/bsync-sample/sheet-1-tagged-eems.csv") # For the BSYNC sample

## Sheet 2: Un-tagged EEMs

tagged_eems <- sheet_1_tagged_eems %>% 
  select(eem_id, document, cat_lev1, cat_lev2, eem_name) %>% 
  unique()

sheet_2_untagged_eems <- anti_join(sample_eems, tagged_eems)

# Export results as CSV
write_csv(sheet_2_untagged_eems, "../results/random-5-percent-sample/sheet-2-untagged-eems.csv") # For the 5% random sample 
#write_csv(sheet_2_untagged_eems, "../results/bsync-sample/sheet-2-untagged-eems.csv") # For the BSYNC sample

## Sheet 3: Top tags in the EEM sample with counts

sheet_3_top_tags <- tagged_tokens %>% 
  select(keyword) %>% 
  count(keyword, sort = TRUE)

# Export results as CSV
write_csv(sheet_3_top_tags, "../results/random-5-percent-sample/sheet-3-top-tags.csv") # For the 5% random sample 
#write_csv(sheet_3_top_tags, "../results/bsync-sample/sheet-3-top-tags.csv") # For the BSYNC sample

## Sheet 4: Top untagged words in the EEM sample with counts

untagged_tokens <- filter(eem_tokens, is.na(eem_tokens$uni_code)) %>% 
  select(id, tokens)

sheet_4_untagged_words <- untagged_tokens %>% 
  filter(!str_detect(.$tokens, " ")) %>% 
  select(-id) %>% 
  count(tokens, sort = TRUE)

# Export results as CSV
write_csv(sheet_4_untagged_words, "../results/random-5-percent-sample/sheet-4-untagged-words.csv") # For the 5% random sample 
#write_csv(sheet_4_untagged_words, "../results/bsync-sample/sheet-4-untagged-words.csv") # For the BSYNC sample

## Sheet 5: Top untagged bigrams in the EEM sample with counts

sheet_5_untagged_bigrams <- untagged_tokens %>% 
  filter(str_detect(.$tokens, "^[:alnum:]+[:blank:][:alnum:]+$")) %>% 
  select(-id) %>% 
  count(tokens, sort = TRUE)

# Export results as CSV
write_csv(sheet_5_untagged_bigrams, "../results/random-5-percent-sample/sheet-5-untagged-bigrams.csv") # For the 5% random sample 
#write_csv(sheet_5_untagged_bigrams, "../results/bsync-sample/sheet-5-untagged-bigrams.csv") # For the BSYNC sample


### Step 5: Extract metrics of performance

## Metric 1: Percentage of EEMs that got tagged automatically

tagged_eem_count <- tagged_tokens$id %>% unique() %>% length()
total_eem_count <- sample_eems %>% nrow()
paste0("Percent EEMs tagged = ", round(100*tagged_eem_count/total_eem_count,1))

## Metric 2: Percentage of EEMs that got categorized automatically

categorized_tokens <- tagged_tokens %>% 
  #filter(uni_code != "X0000") # Use this if you want to calculate Metric 2 using both the descriptor and element tags
  filter(type == "Element") # Use this if you want to calculate Metric 2 using only element tags

categorized_eem_count <- categorized_tokens$id %>% unique() %>% length()
paste0("Percent EEMs categorized = ", round(100*categorized_eem_count/total_eem_count,1))

## Metric 3: Percentage of EEMs that got categorized manually
# @ALW: Do we also count the EEMs that were assigned a higher level category?

manually_categorized_count <- ground_truth_bsync %>% 
  filter(uni_code_manual != "NONE") %>% 
  nrow()

paste0("Percent EEMs categorized manually = ", round(100*manually_categorized_count/total_eem_count,1))

## Metric 4: Percentage of EEMs that got categorized correctly

# Using both element and descriptor tags
compare_auto_manual <- sheet_1_tagged_eems %>% 
  select(eem_id, uni_code) %>% 
  inner_join(ground_truth_bsync) %>% 
  mutate(is_correct = ifelse(uni_code == uni_code_manual, 1, 0))

correct_categorization_count <- compare_auto_manual %>% 
  select(eem_id, is_correct) %>% 
  unique() %>% 
  filter(is_correct == 1) %>% 
  nrow()

paste0("Percent EEMs categorized correctly using both element and descriptor tags = ", 
       round(100*correct_categorization_count/manually_categorized_count,1))

# Using only element tags
compare_auto_manual_2 <- sheet_1_tagged_eems %>% 
  filter(type == "Element") %>% 
  select(eem_id, uni_code) %>% 
  inner_join(ground_truth_bsync) %>% 
  mutate(is_correct = ifelse(uni_code == uni_code_manual, 1, 0))

correct_categorization_count_2 <- compare_auto_manual_2 %>% 
  select(eem_id, is_correct) %>% 
  unique() %>% 
  filter(is_correct == 1) %>% 
  nrow()

paste0("Percent EEMs categorized correctly using only element tags = ", 
       round(100*correct_categorization_count/manually_categorized_count,1))
