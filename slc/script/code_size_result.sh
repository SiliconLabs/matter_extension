#!/bin/bash

# Get directory from argument or use current directory as default
SEARCH_DIR="${1:-.}"

# Get output file name from argument or use default
OUTPUT_FILE="${2:-code_size_results.csv}"

echo "file_path,text_size,bss_data_size" > "$OUTPUT_FILE"

# Find all .out files in the specified directory and subdirectories
find "$SEARCH_DIR" -name "*.out" -type f | while read -r file; do
    size_output=$(arm-none-eabi-size -A "$file" 2>/dev/null)

    if [ $? -eq 0 ]; then
        text=$(echo "$size_output" | awk '$1 == ".text" {print $2}')
        data=$(echo "$size_output" | awk '$1 == ".data" {print $2}')
        bss=$(echo "$size_output" | awk '$1 == ".bss" {print $2}')
        text=${text:-0}
        data=${data:-0}
        bss=${bss:-0}
        bss_data_total=$((bss + data))

        file_sanitized="${file//,/_}"
        echo "$file_sanitized,$text,$bss_data_total" >> "$OUTPUT_FILE"
    else
        echo "Warning: Failed to process $file" >&2
    fi
done

echo "Results saved to $OUTPUT_FILE"
