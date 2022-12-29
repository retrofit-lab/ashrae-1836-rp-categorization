# Developing a standardized categorization system for energy efficiency measures (1836-RP)
This repository contains the data and code for the paper "Developing a standardized categorization system for energy efficiency measures (1836-RP)" submitted to *Science and Technology for the Built Environment*. This study was conducted as part of ASHRAE Research Project 1836, Developing a standardized categorization system for energy efficiency measures.

## Contents  
- [Repository Structure](#repository-structure)  
- [Objective](#objective)  
- [Data](#data)  
    - [ASHRAE 1836-RP categorization tags](#ashrae-1836-rp-categorization-tags)
    - [ASHRAE 1836-RP 5% sample of EEMs](#ashrae-1836-rp-5-sample-of-eems)
    - [BuildingSync list of EEMs](#buildingsync-list-of-eems)   
    - [ASHRAE 1836-RP 5% sample ground truth](#ashrae-1836-rp-5-sample-ground-truth)
    - [BuildingSync ground truth](#buildingsync-ground-truth) 
    - [User-defined data](#user-defined-data)  
- [Analysis](#analysis)  
    - [Setup](#setup)  
    - [Search, tag, and categorize](#search-tag-and-categorize)  
    - [Results](#results) 
    - [Troubleshooting](#troubleshooting) 

## Repository Structure
The repository is divided into three directories:
- `/data/`: List(s) of EEMs to be categorized (or re-categorized) and related data  
- `/analysis/`: R script for EEM categorization
- `/results/`: Output produced by R script

## Objective
Energy Efficiency Measures (EEMs) play a central role in building energy modeling, energy auditing, and energy data collection and exchange. Despite their importance, there is currently no standardized way to describe or categorize EEMs in industry. This lack of standardization severely limits the ability to communicate the intent of an EEM clearly and consistently, and to perform “apples-to-apples” comparisons of measure savings and cost effectiveness. The goal of this study was to develop and test a standardized system for categorizing EEMs. 

The standardized categorization system developed in 1836-RP consists of a three-level hierarchy of building elements based on UNIFORMAT, a standard classification system for building elements and related sitework. An individual EEM is categorized on the hierarchy using an element “tag” (i.e., keyword) present in the EEM name that links the EEM with a single UNFORMAT category.  The EEM name may also contain one or more descriptor tags that are not used for categorization, but may provide useful additional information for sorting and analyzing a group of EEMs.

## Data
There are five datasets associated with this project: one set of categorization tags, two example lists of EEMs to be re-categorized, and two corresponding ground truth files that contain manually assigned re-categorizations for each EEM.    

### ASHRAE 1836-RP categorization tags
To categorize the list of EEMs, the R script uses a seed list of categorization tags that was developed during 1836-RP. The file [categorization-tags.csv](data/categorization-tags.csv) contains the element and descriptor type tags, along with their associated UNIFORMAT categories. The CSV file containing the categorization tags consists of six columns, as shown in Table 1. The column `keyword` contains the tags to be used for categorization. The column `type` provides information regarding whether the tag is an element tag or a descriptor tag. The remaining columns `uni_code`, `uni_level_1`, `uni_level_2`, and `uni_level_3` contain the UNIFORMAT category associated with that tag. 

Some descriptor tags like "cool roof" will always belong to a single UNIFORMAT category and are therefore assigned to that category (in this case B3010 Roof Coverings). Other descriptor tags like "insulation" could belong to multiple categories depending upon the building element affected and are therefore left unassigned and given the uni_code X0000.  When possible, tags have been assigned to UNIFORMAT Level 3, however, some high-level element tags (e.g., building envelope) can only be assigned to UNIFORMAT Level 1 or 2, and lower levels are left unassigned. The first five tags in the dataset:

|keyword           |type    |uni_code |uni_level_1  |uni_level_2           |uni_level_3          |
|:-----------------|:-------|:--------|:------------|:---------------------|:--------------------|
|Foundation wall   |Element |A1010    |SUBSTRUCTURE |Foundations           |Standard Foundations |
|Slab              |Element |A1030    |SUBSTRUCTURE |Foundations           |Slab on Grade        |
|Basement wall     |Element |A2020    |SUBSTRUCTURE |Basement Construction |Basement Walls       |
|Building envelope |Element |B        |SHELL        |Unassigned            |Unassigned           |
|envelope          |Element |B        |SHELL        |Unassigned            |Unassigned           |

### ASHRAE 1836-RP 5% sample of EEMs
Two example EEM lists are provided as Comma Separated Values (CSV) files along with the R script. The first example list is a random sample of 5% of the EEMs from the 1836-RP main list of EEMs [eem-list-main.csv](https://github.com/retrofit-lab/ashrae-1836-rp-text-mining/blob/main/README.md#ashrae-1836-rp-main-list-of-eems) and is named [sample-eems.csv](data/sample-eems.csv). 

The dataset contains five columns. The EEM IDs from the main list of 1836-RP EEMs are shown in the `eem_id` column, the source document is shown in the `document` column, the original categorization in the source document is shown in the `cat_lev1` column, the sub-categorization in the original source document (if present) is shown in the `cat_lev2` column, and the EEM name is given in the `eem_name` column.  The first five EEMs from the 5% random sample:

| eem_id|document |cat_lev1    |cat_lev2     |eem_name                                            |
|------:|:--------|:-----------|:------------|:---------------------------------------------------|
|     10|1651RP   |Daylighting |Passive      |High ceilings                                       |
|     24|1651RP   |Daylighting |Passive      |Use of interzone luminous ceilings                  |
|     35|1651RP   |Envelope    |Fenestration |Heat absorbing blinds                               |
|     36|1651RP   |Envelope    |Fenestration |Manual Internal Window shades                       |
|     60|1651RP   |Envelope    |Infiltration |High Performance Air Barrier to Reduce Infiltration |

### BuildingSync list of EEMs
The second list contains all of the EEMs in BuildingSync and is named [building-sync.csv](data/building-sync.csv).  It follows the same five column format as the 5% random sample.  The first five EEMs from the BuildingSync list:  

| eem_id|document |cat_lev1                  | cat_lev2|eem_name                                                    |
|------:|:--------|:-------------------------|--------:|:-----------------------------------------------------------|
|   1237|BSYNC    |Advanced Metering Systems |        0|Install advanced metering systems                           |
|   1238|BSYNC    |Advanced Metering Systems |        0|Clean and/or repair                                         |
|   1239|BSYNC    |Advanced Metering Systems |        0|Implement training and/or documentation                     |
|   1240|BSYNC    |Advanced Metering Systems |        0|Upgrade operating protocols, calibration, and/or sequencing |
|   1241|BSYNC    |Advanced Metering Systems |        0|Other                                                       |

### ASHRAE 1836-RP 5% sample ground truth
>> TEXT TK
>>  Ground truth is not required for categorization, but for some of the metrics... 

### BuildingSync ground truth
>> TEXT TK

### User-defined data
In order to use a different list of categorization tags (or add to/amend this seed list) add the new list to the `/data/` folder and update the file name in the R script.  The list of categorization tags provided by the user should have the same six column format with the headers shown above. 

In order to categorize a different list of EEMs, add the new list to the `/data/` folder and update the file name in the R script. The list of EEMs provided by the user should have the same five column format with the headers shown above.  The input data needs to follow this header structure regardless of  whether the list of EEMs has a prior categorization system associated with it or not. The column `eem_id` should contain a unique ID for each EEM. If your EEM list does not have any original categorization system associated with it, keep the dummy columns `cat_lev1` and `cat_lev2` empty. 

## Analysis
The R script [eem-recategorization.R](analysis/eem-recategorization.R) categorizes an existing list of EEMs according to the standardized categorization system developed in 1836-RP.

### Setup

#### Load packages
First, load (or install if you do not already have them installed) the packages required for data handling and tokenization.

```
# Load required packages
library(tidyverse)
library(tidytext)
library(tokenizers) # for 1-n gram tokenization
```

#### Import data
Import the list of categorization tags, the list of EEMs to be categorized, and the corresponding ground truth (if available). The relative filepaths in this script follow the same directory structure as this Github repository, and it is recommended that you use this same structure.  You might have to use `setwd()` to set the working directory to the location of the R script.  

```
tag_list <- read_csv("../data/categorization-tags.csv")
sample_eems <- read_csv("../data/sample-eems.csv")
# Use sample-eems.csv or building-sync.csv or your custom EEM list
```

#### Tokenize tags and EEMs
Since the tags consist of n-grams where n>1 (e.g., words, bigrams, trigrams), the EEM names need to be tokenized as sequences of n-grams.  To determine the number of n in n-grams to be used to tokenize the EEM names, we first tokenize the tags and count the range of number of tokens in the categorization tag list.

```
tokenized_tag_list <- tag_list %>% 
  select(keyword) %>% 
  unnest_tokens(word, keyword, token = "words", drop = FALSE)

tag_token_counts <- tokenized_tag_list %>% 
  count(keyword)
```
  
This produces a token count for each tag.  For the first five tags:  

```
   keyword                     n
   <chr>                   <int>
 1 Absorption chiller          2
 2 Advanced power strip        3
 3 AHU                         1
 4 Air barrier                 2
 5 air cooled                  2
 ```

For the ASHRAE 1836-RP categorization tags, the tags range from 1 to 5 words in length. In order to look for these tags within the EEM names, the EEM names need to be tokenized as n-grams where n ranges from 1 to 5.

```
## Tokenize EEM names
# create a list of tokens for each EEM name
token_1_5grams <- tokenize_ngrams(sample_eems$eem_name, lowercase = TRUE, n = 5, n_min = 1)

# Map the list as a dataframe
eem_tokens <- map_df(token_1_5grams, ~as.data.frame(.x), .id="id")
eem_tokens$id <- as.numeric(eem_tokens$id)
eem_tokens <- dplyr::rename(eem_tokens, tokens = .x)
```

This produces a dataframe with the tokens from each EEM as separate rows.  For example, the EEM "High ceilings" is tokenized into three possible tokens: "high", "high ceilings", and "ceilings".  For the first five tokens: 

```
  id        tokens
1  1          high
2  1 high ceilings
3  1      ceilings
4  2           use
5  2        use of
```

### Search, tag, and categorize
The automatic tagger and categorizer code searches for the categorization tags within the tokenized EEM names. Every time it finds a match, it tags that EEM with all the information associated with that particular tag. This includes the tag, the tag type and the UNIFORMAT category associated with the tag.  Tokens that do not have a matching tagged are left untagged with an <NA>.

```
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
```

For the first five tokens, the dataframe is now: 

```
  id        tokens keyword    type uni_code uni_level_1       uni_level_2      uni_level_3
1  1          high    <NA>    <NA>     <NA>        <NA>              <NA>             <NA>
2  1 high ceilings    <NA>    <NA>     <NA>        <NA>              <NA>             <NA>
3  1      ceilings ceiling Element    C3030   INTERIORS Interior Finishes Ceiling Finishes
4  2           use    <NA>    <NA>     <NA>        <NA>              <NA>             <NA>
5  2        use of    <NA>    <NA>     <NA>        <NA>              <NA>             <NA>
```

### Results

#### Tagged and untagged EEMs
The script then exports five CSV files:
- `sheet-1-tagged-eems`: Tagged EEMs from the sample along with their original and new categorizations
- `sheet-2-untagged-eems`: Untagged EEMs from the sample along with their original categorizations
- `sheet-3-top-tags`: Most frequently occurring tagged terms from the sample along with their counts
- `sheet-4-untagged-words`: Most frequently occurring un-tagged terms from the sample along with their counts   
- `sheet-5-untagged-bigrams`: Most frequently occurring un-tagged bigrams from the sample along with their counts     
   
To illustrate the results, the first five EEMs from `sheet-1-tagged-eems` are shown below. If multiple tags are present in the EEM, each tag gets its own row in the re-categorized list.
    
| eem_id|document |cat_lev1    |cat_lev2     |eem_name                           |tags    |type       |uni_code |uni_level_1             |uni_level_2       |uni_level_3       |
|------:|:--------|:-----------|:------------|:----------------------------------|:-------|:----------|:--------|:-----------------------|:-----------------|:-----------------|
|     10|1651RP   |Daylighting |Passive      |High ceilings                      |ceiling |Element    |C3030    |INTERIORS               |Interior Finishes |Ceiling Finishes  |
|     24|1651RP   |Daylighting |Passive      |Use of interzone luminous ceilings |ceiling |Element    |C3030    |INTERIORS               |Interior Finishes |Ceiling Finishes  |
|     35|1651RP   |Envelope    |Fenestration |Heat absorbing blinds              |blind   |Element    |E2010    |EQUIPMENT & FURNISHINGS |Furnishings       |Fixed Furnishings |
|     36|1651RP   |Envelope    |Fenestration |Manual Internal Window shades      |manual  |Descriptor |X0000    |Unassigned              |Unassigned        |Unassigned        |
|     36|1651RP   |Envelope    |Fenestration |Manual Internal Window shades      |Wind    |Descriptor |D3010    |SERVICES                |HVAC              |Energy Supply     |

The first five EEMs from `sheet-2-untagged-eems` are shown below.  When EEMs remain untagged it is generally for one of several reasons: a relevant tag present in the EEM name is missing from the list of categorization tags; the EEM name uses a synonymous, abbreviated, or different form of a tag present in the tag list; the EEM name does not actually contain a building element. Examining the results, we see that EEM 73 illustrates the second error: it contains the plural term "doors", but the relevant categorization tags are "interior door" and "exterior door."  The rest of the EEM names illustrate the third error and do not contain any element tags.   
    
| eem_id|document |cat_lev1      |cat_lev2    |eem_name                                                                                                                           |
|------:|:--------|:-------------|:-----------|:----------------------------------------------------------------------------------------------------------------------------------|
|     73|1651RP   |Envelope      |Opaque      |High-speed doors between heated/cooled building space and unconditioned space in the areas with high-traffic                       |
|     80|1651RP   |Envelope      |Opaque      |large reservoirs of water for thermal mass within zone                                                                             |
|    304|1651RP   |HVAC          |Ventilation |Hybrid/Mixed Mode Ventilation                                                                                                      |
|    501|BEQ      |HVAC System   |0           |Where cooling is provided by multiple units, maintain proper sequencing to achieve maximum efficiency while meeting required load. |
|    562|BEQ      |HVAC System   |0           |Reduce operating hours of simultaneously heating and cooling systems.                                                              |
 
#### Performance metrics
The script then computes summary metrics to quantify the performance of the automated tagging system.  Metric 1 is the percentage of EEMs in the list that are tagged with at least one tag. 

```
> tagged_eem_count <- tagged_tokens$id %>% unique() %>% length()
> total_eem_count <- sample_eems %>% nrow()
> paste0("Percent EEMs tagged = ", round(100*tagged_eem_count/total_eem_count,1))
[1] "Percent EEMs tagged = 62.4"
```

Metric 2 is the percentage of EEMs in the list that are categorized, i.e., are tagged with at least one element tag.  If you prefer to compute metric 2 based on the number of EEMs that are categorized using either an element or descriptor tag (excluding unassigned descriptor tags), use the first (commented out) filter criteria instead.  

```
> categorized_tokens <- tagged_tokens %>% 
+   #filter(uni_code != "X0000") # Use this if you want to see both the descriptor and element tags
+   filter(type == "Element")
> categorized_eem_count <- categorized_tokens$id %>% unique() %>% length()
> paste0("Percent EEMs categorized = ", round(100*categorized_eem_count/total_eem_count,1))
[1] "Percent EEMs categorized = 41"
```

Metric 3 is the percentage of categorized EEMs in the list that are categorized correctly, i.e., the automatic categorization matches the ground truth categorization. 

```
> CODE TK METRIC 3
```



### Troubleshooting

If the script produces an error, check for the following issues:

* Are you using a CSV file? The script will not work with Excel sheets.
* Do the column names in the file match those specified above?
* Are you following the GitHub repo folder structure?
* Are you using RStudio to open and run the files?
* Do you have the most recent version of R and RStudio installed?
* Are the libraries in R up to date?
