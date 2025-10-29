#!/bin/bash
# Count image filename occurrences in a LaTeX document.
#
# Function:
#     Scans a directory for image files (.png, .jpg, .jpeg) and searches a .tex 
#     file for each filename. Returns a CSV report with filename and occurrence count.
#
# Usage:
#     bash querry_tex_imgs.sh [image_directory] [tex_filepath]
#     
#     Default (from scripts folder): bash querry_tex_imgs.sh
#     Custom paths: bash querry_tex_imgs.sh ./figures/images main.tex
#
# Output:
#     image_usage.csv - CSV format with headers: filename, count
#     Default output location: project root (../)
#
# Date Created: 2025-10-22
#
# Changelog:
#     - 2025-10-22: Initial version - count image references in .tex file
#     - 2025-10-22: Added default paths for scripts folder usage (../main.tex, ../ output)


# Set default paths for scripts folder usage
image_dir="${1:-../Images}"
tex_file="${2:-../main.tex}"
output_dir="${3:-../}"

# Validate image directory
if [[ ! -d "$image_dir" ]]; then
    echo "Error: Directory '$image_dir' not found."
    exit 1
fi

# Validate .tex file
if [[ ! -f "$tex_file" ]]; then
    echo "Error: File '$tex_file' not found."
    exit 1
fi

# Validate output directory
if [[ ! -d "$output_dir" ]]; then
    echo "Error: Output directory '$output_dir' not found."
    exit 1
fi

# Set output file path
output_file="${output_dir}toc_image_usage.csv"

# Read entire .tex file into variable for faster searching
tex_content=$(<"$tex_file")

# Create temporary file for results
temp_results=$(mktemp)

# Write CSV header
echo "filename,count" > "$output_file"

# Find all image files and count occurrences
find "$image_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | sort | while read -r filepath; do
    # Extract filename from full path
    filename=$(basename "$filepath")
    
    # Count occurrences in .tex file using grep
    count=$(echo "$tex_content" | grep -o "$filename" | wc -l)
    
    # Append to output file
    echo "$filename,$count" >> "$output_file"
done

# Count total files processed
total_files=$(find "$image_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | wc -l)

echo "Results written to $output_file"
echo "Total files scanned: $total_files"
