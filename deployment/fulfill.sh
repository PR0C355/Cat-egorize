#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <env_file> <template_file>"
    exit 1
fi

ENV_FILE="$1"
TEMPLATE_FILE="$2"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file '$ENV_FILE' not found."
    exit 1
fi

# Check if template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found."
    exit 1
fi

# Read .env file and export variables
set -a
source "$ENV_FILE"
set +a

# Create a temporary file for output
TEMP_FILE=$(mktemp)

# Process the template file
while IFS= read -r line || [[ -n "$line" ]]
do
    # Replace placeholders with their values
    while [[ "$line" =~ (\$\{([a-zA-Z_][a-zA-Z_0-9]*)\}) ]]
    do
        match="${BASH_REMATCH[1]}"
        var_name="${BASH_REMATCH[2]}"
        var_value="${!var_name}"
        line="${line//$match/$var_value}"
    done
    echo "$line" >> "$TEMP_FILE"
done < "$TEMPLATE_FILE"

# Replace the original file with the processed one
cp "$TEMP_FILE" "filled.tf"

echo "Environment variables have been filled in filled.tf"