#!/usr/bin/env Rscript


library(dplyr)

#Rename each run directory 
rename_files <- function(directory, patterns) {
    # List all directories in the specified directory
    dirs <- list.dirs(directory, full.names = TRUE, recursive = FALSE)
    
    # Loop through each directory
    for (dir in dirs) {
        # Skip the main directory itself (first directory listed)
        if (dir == directory) next
        
        # Get the current directory name
        current_name <- basename(dir)
        matched <- FALSE  # Flag to track if any pattern matches
        
        # Loop through each pattern in the list
        for (pattern in patterns) {
            # Check if the pattern exists in the directory name
            if (grepl(pattern, current_name)) {
                # Create a new name based on the matched pattern
                new_name <- paste0(pattern)
                # Create the new directory path
                new_dir_path <- file.path(dirname(dir), new_name)
                # Rename the directory
                file.rename(dir, new_dir_path)
                cat("Renamed directory:", dir, "->", new_dir_path, "\n")
                matched <- TRUE  # Mark as matched
                break  # Stop renaming after the first match
            }
        }
        
        # If no pattern matched, delete the directory
        if (!matched) {
            cat("No match found for directory:", dir, "\n")
            unlink(dir, recursive = TRUE)
            cat("Deleted directory:", dir, "\n")
        }
    }
}



### --------------Runs Rothenberg scRNA-seq data -------------
active=c("run2233", "run2295","run2326","run2403","run2441")
remiss=c("run2242","run2312","run2442")
normal=c("run2272","run2422")
rothenberg_runs=c(active,remiss,normal)

rename_files("data/GSE201153_organized_rothenberg/",rothenberg_runs)


### --------------Runs Morgan scRNA-seq data -------------
#https://github.com/duncanmorgan/EoE_SciImmunol/tree/main/DataAssembly
morgan_runs = read.csv('data/metadata_morgan/tissue_object_metadata.csv',
                       header =1, stringsAsFactors = FALSE, row.names = 1) %>%
    filter(tissue=="Esophagus") %>% pull(patient) %>% unique() %>% 
    paste0(., "_Esophagus") #Only esophagus

rename_files("data/GSE175930_organized_morgan/",morgan_runs)
