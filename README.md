# Developing a standardized categorization system for energy efficiency measures (1836-RP)
This repository contains the data and code for the paper "Developing a standardized categorization system for energy efficiency measures (1836-RP)" submitted to *Science and Technology for the Built Environment*. This study was conducted as part of ASHRAE Research Project 1836, Developing a standardized categorization system for energy efficiency measures.

## Contents  
- [Repository Structure](#repository-structure)  
- [Objective](#objective)  
- [Data](#data)  
    - [ASHRAE 1836-RP 5% sample of EEMs](#ashrae-1836-rp-5-sample-of-eems)
    - [BuildingSync list of EEMs](#buildingsync-list-of-eems)   
    - [User-defined list](#user-defined-list)  
- [Analysis](#analysis)  
    - [Step 1: Import data](#step-1-import-data)  
    - [Step 2: Pre-processing](#step-2-pre-processing)  
    - [Step 3: Search, tag, and categorize](#step-3-search-tag-and-categorize)  
    - [Step 4: Export data](#step-4-export-data)  
    - [Step 5: Compute performance metrics](#step-5-compute-performance-metrics)  

## Repository Structure
The repository is divided into three directories:
- `/data/`: List(s) of EEMs to be categorized (or re-categorized).  
- `/analysis/`: R script for EEM categorization
- `/results/`: Output produced by R script

## Objective
TEXT TK

## Data
There is one dataset associated with this project. 
>> Two samples

### ASHRAE 1836-RP 5% sample of EEMs
The file [eem-list-main.csv](data/eem-list-main.csv) contains the complete list of 3,490 EEMs assembled and analyzed as part of 1836-RP.  This data file is used for the text mining analysis in [text-mining.R](analysis/text-mining.R).  The EEMs were collected from 16 different source documents during the 1836-RP literature review from September 2019 through July 2020.  An initial list of suggested sources was provided by the members of the 1836-RP Project Advisory Board, and additional documents were added through the authors’ literature review.  In order for a source to be included in the review, it needed to contain a list of EEMs.

### BuildingSync list of EEMs
The file [eem-list-main.csv](data/eem-list-main.csv) contains the complete list of 3,490 EEMs assembled and analyzed as part of 1836-RP.  This data file is used for the text mining analysis in [text-mining.R](analysis/text-mining.R).  The EEMs were collected from 16 different source documents during the 1836-RP literature review from September 2019 through July 2020.  An initial list of suggested sources was provided by the members of the 1836-RP Project Advisory Board, and additional documents were added through the authors’ literature review.  In order for a source to be included in the review, it needed to contain a list of EEMs.

### User-defined list
The file [eem-list-main.csv](data/eem-list-main.csv) contains the complete list of 3,490 EEMs assembled and analyzed as part of 1836-RP.  This data file is used for the text mining analysis in [text-mining.R](analysis/text-mining.R).  The EEMs were collected from 16 different source documents during the 1836-RP literature review from September 2019 through July 2020.  An initial list of suggested sources was provided by the members of the 1836-RP Project Advisory Board, and additional documents were added through the authors’ literature review.  In order for a source to be included in the review, it needed to contain a list of EEMs.

## Analysis
The R script `text-mining.R` replicates the analysis from the paper.

### Step 1: Import data
It is recommended that you update to the latest versions of both R and RStudio (if using RStudio) prior to running this script. 


### Step 2: Pre-processing
It is recommended that you update to the latest versions of both R and RStudio (if using RStudio) prior to running this script. 


### Step 3: Search, tag, and categorize
It is recommended that you update to the latest versions of both R and RStudio (if using RStudio) prior to running this script. 

### Step 4: Export data
It is recommended that you update to the latest versions of both R and RStudio (if using RStudio) prior to running this script. 

### Step 5: Compute performance metrics
It is recommended that you update to the latest versions of both R and RStudio (if using RStudio) prior to running this script.



#####################

## Overview
This document describes how to categorize (or re-categorize) energy efficiency measures (EEMs) according to the standardized categorization system developed during ASHRAE 1836-RP, using the accompanying R script [EEM-recategorization.R](analysis/EEM-recategorization.R). The categorization system developed in 1836-RP consists of a three-level hierarchy of building elements based on UNIFORMAT, a standard classification system for building elements and related sitework. An individual EEM is categorized on the hierarchy using an element “tag” (i.e., keyword) present in the EEM name that links the EEM with a single UNFORMAT category.  The EEM name may also contain an action tag and/or one or more descriptor tags.  These are not used for categorization, but may provide useful additional information for sorting and analyzing a group of EEMs.

The script categorizes an existing list of EEMs according to the standardized categorization system developed in 1836-RP.  First, the user loads their own list of EEMs (two sample lists have been provided with this script as examples). Then the script automatically tags and categorizes the list according to the 1836-RP standardized system. Finally, this list of categorized EEMs is exported as an Excel workbook. Typically, some EEMs in the list will remain untagged by the automatic tagging process, and the list of untagged EEMs is also exported in the Excel workbook. The workbook also contains some additional information related to the EEM list, like the list of top tags and the top untagged words and bigrams in the EEM list.

To categorize the list of EEMs, the R script uses a seed list of categorization tags that was developed during 1836-RP. The file [categorization-tags.csv](data/categorization-tags.csv) contains the element and descriptor type tags, along with their associated UNIFORMAT categories. The CSV file containing the categorization tags consists of six columns. The column `keyword` contains the tags to be used for categorization. The column `Type` provides information regarding whether the tag is an element tag or a descriptor tag. The remaining columns `uni_code`, `uni_level_1`, `uni_level_2`, and `uni_level_3` contain the UNIFORMAT category associated with that tag.

The R script searches for these tags within the EEM names and every time it finds a match, it tags the EEM with the tags and the associated UNIFORMAT category. Only the element tags are used for categorization purposes, however, the descriptor tags provide additional useful information and are also included in the Excel output. The results of 1836-RP showed that verb meaning in EEMs can be ambiguous and vary with context, and the action tags are therefore not used in the categorization analysis.

## Import Data

The input data provided by the user should have five columns, with the headers as shown in Table 1.  The input data needs to follow this header structure regardless of  whether the list of EEMs has an original categorization system associated with it or not. The column`eem_id` should contain the unique IDs for the   EEMs. The column `document` should contain the name of the source of the EEM list (e.g., reference document, organization). The column `cat_lev1` should contain the original categorization for the EEM. If there are sub-categories associated with the EEM, these should go in the column `cat_lev2`. If a second level of categorization is not available, leave this column empty. Finally, the EEM names go in the column `eem_name`. If your EEM list does not have any original categorization system associated with it, keep the dummy columns `cat_lev1` and `cat_lev2` empty.

Two example EEM lists are provided as Comma Separated Values (CSV) files along with the R script. The first list is a random sample of 5% of the EEMs from the 1836-RP main list of EEMs (eem-list-main.csv)[Link DOI] named [sample-eems.csv](data/sample-eems.csv). The second list contains only BuildingSync EEMs and is named [building-sync.csv](data/building-sync.csv). In order to use a different list of EEMs, add the new list to the `/data/` folder and update the file name in the R script. Make sure to keep the same folder structure as this GitHub repository and remember to set the working directory to the location of the R script.

```
tag_list <- read_csv("../data/categorization-tags.csv")
sample_eems <- read_csv("../data/sample-eems.csv")
# Use sample-eems.csv or building-sync.csv or your custom EEM list
```

As an illustrative example, this README demonstrates the script using the 5% random sample.  Table 1 below shows the first 5 EEMs from the 5% random sample. The EEM ids from the main list of 1836-RP EEMs are shown in the `eem_id` column, the source document is shown in the `document` column, the original categorization in the source document is shown in the `cat_lev1` column, the sub-categorization in the original source document (if present) is shown in the `cat_lev2` column, and the EEM name is given in the `eem_name` column.

Table 1: Top 5 observations from the EEM list

| eem_id|document |cat_lev1    |cat_lev2     |eem_name                                            |
|------:|:--------|:-----------|:------------|:---------------------------------------------------|
|     10|1651RP   |Daylighting |Passive      |High ceilings                                       |
|     24|1651RP   |Daylighting |Passive      |Use of interzone luminous ceilings                  |
|     35|1651RP   |Envelope    |Fenestration |Heat absorbing blinds                               |
|     36|1651RP   |Envelope    |Fenestration |Manual Internal Window shades                       |
|     60|1651RP   |Envelope    |Infiltration |High Performance Air Barrier to Reduce Infiltration |



## EEM categorization using 1836-RP standardized categorization system

The automatic tagger and categorizer code searches for the categorization tags (developed during 1836-RP) within the EEM names. Every time it finds a match, it tags that EEM with all the information associated with that particular tag. This includes the tag, the tag type and the UNIFORMAT category associated with the tag. The EEMs that remain untagged are compiled in a separate list. The script also uncovers the top categorization tags that show up within the EEM sample as well as the top un-tagged words and bigrams in the sample.

Every time the script is run, it creates a new Excel workbook named "eem-list-categorized-using-1836rp.xlsx" with the output from the script. The tagged EEMs along with their old as well as new categorization system are shown in Sheet 1 of the workbook. The untagged EEMs from the sample along with their original categorization system are shown in Sheet 2. Sheet 3 contains the top tags from the RP1836 seed list of categorization tags that occur within the sample. Sheets 4 and 5 contain the most frequent un-tagged words and bigrams respectively from within our sample of EEMs.

As an example, the first five EEMs from the re-categorized list (without their original categories) are shown below in Table 2. The 1836-RP seed list of categorization tags were able to tag `r tagged_eem_count` out of `r total_eem_count` EEMs in the sample. While the table displays both element and descriptor type tags, only the element tags should be used for categorization. The descriptor tags are present to provide additional information. Some descriptor tags like "cool roof" will always belong to a single UNIFORMAT category and are therefore pre-assigned to that category (in this case B3010 Roof Coverings). Other descriptor tags like "insulation" could belong to multiple different categories depending upon the building system being affected and are therefore left unassigned. If multiple tags are present in the EEM, each tag gets its own row in the re-categorized list.

Table 2: EEM list recategorized

| eem_id|eem_name                                            |tags         |type       |uni_code |uni_level_1             |uni_level_2        |uni_level_3       |
|------:|:---------------------------------------------------|:------------|:----------|:--------|:-----------------------|:------------------|:-----------------|
|     10|High ceilings                                       |ceiling      |Element    |C3030    |INTERIORS               |Interior Finishes  |Ceiling Finishes  |
|     24|Use of interzone luminous ceilings                  |ceiling      |Element    |C3030    |INTERIORS               |Interior Finishes  |Ceiling Finishes  |
|     35|Heat absorbing blinds                               |blind        |Element    |E2010    |EQUIPMENT & FURNISHINGS |Furnishings        |Fixed Furnishings |
|     36|Manual Internal Window shades                       |manual       |Descriptor |X0000    |Unassigned              |Unassigned         |Unassigned        |
|     36|Manual Internal Window shades                       |Wind         |Descriptor |D3010    |SERVICES                |HVAC               |Energy Supply     |
|     36|Manual Internal Window shades                       |shade        |Element    |E2010    |EQUIPMENT & FURNISHINGS |Furnishings        |Fixed Furnishings |
|     60|High Performance Air Barrier to Reduce Infiltration |Air barrier  |Descriptor |B2010    |SHELL                   |Exterior Enclosure |Exterior Walls    |
|     60|High Performance Air Barrier to Reduce Infiltration |infiltration |Descriptor |X0000    |Unassigned              |Unassigned         |Unassigned        |


The categorization script works fairly well in categorizing the EEMs according to UNIFORMAT based on the building element affected. However, some EEMs still get mis-categorized or remain untagged. As noted in the 1836-RP Final Report, there are two major reasons for untagged EEMs: either because a relevant tag is missing from the seed list of categorization tags, or because the EEM used a synonymous or abbreviated form of a tag present in the tag list. Table 3 shows the first five EEMs in the list that remain untagged after the script is run. The EEM "Consider converting internal courtyard into an atrium to reduce external wall surface." remains untagged because it uses the term "external wall" intead of "exterior wall" which is a tag in the seed list. The EEMs "Central Air Conditioning" and "Install Central Air Conditioner" remains untagged because no tag currently exists for "air conditioning" in the seed list. 

Table 3: Untagged EEMs from the list

| eem_id|document |cat_lev1    |cat_lev2    |eem_name                                                                                                                           |
|------:|:--------|:-----------|:-----------|:----------------------------------------------------------------------------------------------------------------------------------|
|     73|1651RP   |Envelope    |Opaque      |High-speed doors between heated/cooled building space and unconditioned space in the areas with high-traffic                       |
|     80|1651RP   |Envelope    |Opaque      |large reservoirs of water for thermal mass within zone                                                                             |
|    304|1651RP   |HVAC        |Ventilation |Hybrid/Mixed Mode Ventilation                                                                                                      |
|    501|BEQ      |HVAC System |0           |Where cooling is provided by multiple units, maintain proper sequencing to achieve maximum efficiency while meeting required load. |
|    562|BEQ      |HVAC System |0           |Reduce operating hours of simultaneously heating and cooling systems.                                                              |


## Common sources of error

If the script produces an error, check for the following issues:

* Are you using a CSV file? The script will not work with Excel sheets.
* Do the column names in the file match those specified above?
* Are you following the GitHub repo folder structure?
* Are you using RStudio to open and run the files?
* Do you have the most recent version of R and RStudio installed?
* Are the libraries in R up to date?
