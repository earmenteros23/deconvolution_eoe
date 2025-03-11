#!/usr/bin/env bash

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <GSE_number>"
    exit 1
fi

# Assign the argument to a variable
GSE_NUMBER=$1

# Define paths
DATA_DIR="data/${GSE_NUMBER}"
TAR_FILE="data/${GSE_NUMBER}.tar"

# Create data directory if it doesn't exist
mkdir -p "$DATA_DIR"

# Download the dataset
wget -O "$TAR_FILE" "https://www.ncbi.nlm.nih.gov/geo/download/?acc=${GSE_NUMBER}&format=file"

# Extract the dataset
tar -xvf "$TAR_FILE" -C "$DATA_DIR"

echo "Download and extraction of ${GSE_NUMBER} completed."


