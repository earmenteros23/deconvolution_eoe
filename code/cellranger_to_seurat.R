#!/usr/bin/env -S Rscript --vanilla

library(optparse)
library(stringr)
option_list = list(
    make_option(c("-i", "--input_directory"), type="character", help="Input directory path"),
    make_option(c("-o", "--output_directory"), type="character", help="Output directory path"))
opt_parser = OptionParser(usage="Usage: %prog -i INPUT_DIRECTORY -o OUTPUT_DIRECTORY", option_list=option_list)
opt = parse_args(opt_parser)
if (is.null(opt$input_directory)){
    print_help(opt_parser)
    stop("Input (-i) and output (-o) directories must be supplied", call.=FALSE)
}

# Filename pattern to match
file_pattern <- "^.*(?=barcodes.tsv.gz|genes.tsv.gz|features.tsv.gz|matrix.mtx.gz)"
extract_gsm_identifier <- function(file_name) {
    match <- basename(str_extract(file_name,file_pattern))
    if (length(match) > 0) {
        return(match)
    }
    return(NULL)
}
#Function to extract the file data type
get_new_relative_name <- function(file_name) {
    base_name_match <- str_extract(file_name,file_pattern)
    if (length(base_name_match) > 0) {
        extension_match <- regmatches(file_name, regexpr("(barcodes\\.tsv|genes\\.tsv|features\\.tsv|matrix\\.mtx)\\.gz$",
                                                         file_name))
        if (length(extension_match) > 0) {
            if (extension_match == "genes.tsv.gz") {
                extension_match <- "features.tsv.gz"
            }
            return(extension_match)
        }
    }
    return(NULL)
}

# Main function
main <- function() {
    directory <- opt$input_directory
    output_directory <- file.path(opt$output_directory, "organized_files")
    all_files <- list.files(path = directory, recursive = TRUE, full.names = TRUE)
    if (!file.exists(output_directory)) {
        dir.create(output_directory)
    }
    for (file in all_files) {
        gsm_identifier <- extract_gsm_identifier(file)
        new_relative_name <- get_new_relative_name(file)
        
        if (!is.null(gsm_identifier) && !is.null(new_relative_name)) {
            folder_path <- file.path(output_directory, gsm_identifier)            
            if (!file.exists(folder_path)) {
                dir.create(folder_path, recursive = TRUE)
            }
            file.copy(file, file.path(folder_path, new_relative_name))
        }
    }
    
    cat("\nProcessing completed.\n")
}

# Run the main function
main()


