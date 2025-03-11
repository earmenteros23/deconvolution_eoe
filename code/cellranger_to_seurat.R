#!/usr/bin/env Rscript

# Load required libraries
library(optparse)  # For parsing command-line arguments
library(stringr)   # For string manipulation

# Define command-line options
option_list = list(
    make_option(c("-i", "--input_directory"), type="character", help="Input directory path"),  # Input directory
    make_option(c("-t", "--tag"), type="character", help="Tag to identify the dataset")  # Input directory
    
    )

# Create an argument parser and define usage instructions
opt_parser = OptionParser(usage="Usage: %prog -i INPUT_DIRECTORY -t TAG", option_list=option_list)

# Parse command-line arguments
opt = parse_args(opt_parser)

# Ensure that the input directory is provided, otherwise print help message and stop execution
if (is.null(opt$input_directory)){
    print_help(opt_parser)
    stop("Input (-i) and output (-o) directories must be supplied", call.=FALSE)  # Stop execution with error message
}

# Define a pattern to match filenames of interest
file_pattern <- "^.*(?=barcodes.tsv.gz|genes.tsv.gz|features.tsv.gz|matrix.mtx.gz)"

# Function to extract the GSM identifier from a filename
extract_gsm_identifier <- function(file_name) {
    match <- basename(str_extract(file_name, file_pattern))  # Extract matching part of filename
    if (length(match) > 0) {
        return(match)  # Return extracted identifier
    }
    return(NULL)  # Return NULL if no match found
}

# Function to determine the new relative filename based on its type
get_new_relative_name <- function(file_name) {
    base_name_match <- str_extract(file_name, file_pattern)  # Extract the base name
    if (length(base_name_match) > 0) {
        extension_match <- regmatches(file_name, regexpr("(barcodes\\.tsv|genes\\.tsv|features\\.tsv|matrix\\.mtx)\\.gz$", 
                                                         file_name))  # Match expected file types
        if (length(extension_match) > 0) {
            if (extension_match == "genes.tsv.gz") {
                extension_match <- "features.tsv.gz"  # Standardize naming for gene files
            }
            return(extension_match)  # Return the extracted file type
        }
    }
    return(NULL)  # Return NULL if no match found
}

# Main function to process and organize files
main <- function() {
    directory <- opt$input_directory  # Get input directory from command-line argument
    tag <- opt$tag 
    output_directory <- file.path(paste0(directory,"_organized_",tag))  # Define output directory path
    
    # List all files in the input directory recursively
    all_files <- list.files(path = directory, recursive = TRUE, full.names = TRUE)
    
    # Create the output directory if it doesn't exist
    if (!file.exists(output_directory)) {
        dir.create(output_directory)
    }
    
    # Loop through each file in the directory
    for (file in all_files) {
        gsm_identifier <- extract_gsm_identifier(file)  # Extract GSM identifier
        new_relative_name <- get_new_relative_name(file)  # Get new filename based on type
        
        # If both the identifier and filename are valid, proceed
        if (!is.null(gsm_identifier) && !is.null(new_relative_name)) {
            folder_path <- file.path(output_directory, gsm_identifier)  # Define new folder path
            
            # Create folder if it doesn't exist
            if (!file.exists(folder_path)) {
                dir.create(folder_path, recursive = TRUE)
            }
            
            # Copy the file to its new location with the new name
            file.copy(file, file.path(folder_path, new_relative_name))
        }
    }
    
    # Print a completion message
    cat("\nProcessing completed.\n")
}

# Execute the main function
main()



