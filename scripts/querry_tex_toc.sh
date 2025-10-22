#!/bin/bash
# Extract LaTeX document hierarchy and generate table of contents.
#
# Function:
#     Parses a .tex file to extract chapter, section, subsection, subsubsection, 
#     and paragraph structures. Generates a table of contents file that shows the 
#     document hierarchy with titles and line numbers. Filters out any lines where 
#     "%" appears before the LaTeX command.
#
# Usage:
#     bash querry_tex_toc.sh [filepath]
#
#     Default (from scripts folder): bash querry_tex_toc.sh
#     Custom path: bash querry_tex_toc.sh ../main.tex
#
# Output:
#     main_toc.txt - CSV-like format: level, title, line_number
#     Default output location: project root (../)
#
# Date Created: 2025-10-22
#
# Changelog:
#     - 2025-10-22: Initial version - extract LaTeX hierarchy to main_toc.txt
#     - 2025-10-22: Added default paths for scripts folder usage (../main.tex, ../ output)


# Set default paths for scripts folder usage
filepath="${1:-../main.tex}"
output_dir="${2:-../}"

# Validate .tex file
if [[ ! -f "$filepath" ]]; then
    echo "Error: File '$filepath' not found."
    exit 1
fi

# Validate output directory
if [[ ! -d "$output_dir" ]]; then
    echo "Error: Output directory '$output_dir' not found."
    exit 1
fi

# Set output file path
output_file="${output_dir}toc_main.txt"

# Temporary file for results
temp_results=$(mktemp)

# LaTeX hierarchical commands
latex_commands=("chapter" "section" "subsection" "subsubsection" "paragraph")

# Loop through file line by line
line_num=0
while IFS= read -r line || [[ -n "$line" ]]; do
    line_num=$((line_num + 1))
    
    # Find position of comment character
    comment_part="${line%%\%*}"
    comment_pos=${#comment_part}
    
    # Loop through each LaTeX command
    for cmd in "${latex_commands[@]}"; do
        # Search for \command pattern
        if [[ "$line" =~ \\$cmd\{ ]]; then
            # Find position of command in line
            before_cmd="${line%%\\$cmd*}"
            cmd_pos=${#before_cmd}
            
            # Skip if comment appears before command
            if [[ "$line" == *"%"* ]] && [[ $cmd_pos -gt $comment_pos ]]; then
                continue
            fi
            
            # Extract title from braces using regex
            if [[ "$line" =~ \\$cmd\{([^}]*)\} ]]; then
                title="${BASH_REMATCH[1]}"
                echo "$cmd|$title|$line_num" >> "$temp_results"
            fi
        fi
    done
    
done < "$filepath"

# Sort by line number and write to output file
if [[ -f "$temp_results" ]] && [[ -s "$temp_results" ]]; then
    sort -t'|' -k3 -n "$temp_results" | while IFS='|' read -r level title line; do
        echo "$level, $title, $line" >> "$output_file"
    done
    
    entry_count=$(wc -l < "$output_file")
    echo "Table of contents written to $output_file"
    echo "Total entries: $entry_count"
    rm "$temp_results"
else
    echo "No LaTeX hierarchical commands found in file."
    rm "$temp_results"
fi
