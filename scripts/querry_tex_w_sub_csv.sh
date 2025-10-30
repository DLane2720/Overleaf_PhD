#!/bin/bash
# Extract LaTeX document hierarchy and generate table of contents with subfile references.
#
# Function:
#     Parses a .tex file to extract chapter, section, subsection, subsubsection, 
#     and paragraph structures. Generates a table of contents file that shows the 
#     document hierarchy with titles, labels, subfile references, and line numbers. 
#     Filters out any lines where "%" appears before the LaTeX command.
#
# Usage:
#     bash querry_tex_toc_labels_w_sub.sh [filepath]
#
#     Default (from scripts folder): bash querry_tex_toc_labels_w_sub.sh
#     Custom path: bash querry_tex_toc_labels_w_sub.sh ../main_w_sub.tex
#
# Output:
#     toc_main_w_sub.csv - CSV format with headers: level, title, label, subfile, line_number
#     Default output location: project root (../)
#     Labels and subfiles are extracted from current line or up to 3 lines following the section command
#
# Date Created: 2025-10-29
#
# Changelog:
#     - 2025-10-29: Created from querry_tex_toc_labels.sh to process main_w_sub.tex with subfile extraction
#     - 2025-10-29: Changed output to .csv format with headers


# Set default paths for scripts folder usage
filepath="${1:-../main_w_sub.tex}"
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
output_file="${output_dir}toc_main_w_sub.csv"

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
                
                # Search for label on current line first
                label=""
                if [[ "$comment_part" =~ \\label\{([^}]*)\} ]]; then
                    label="${BASH_REMATCH[1]}"
                else
                    # Look ahead up to 3 lines for label
                    next_lines=$(sed -n "$((line_num+1)),$((line_num+3))p" "$filepath" 2>/dev/null)
                    if [[ "$next_lines" =~ \\label\{([^}]*)\} ]]; then
                        # Verify label is not commented out
                        label_line="${next_lines%%\\label*}\\label{${BASH_REMATCH[1]}}"
                        label_comment_part="${label_line%%\%*}"
                        if [[ "$label_comment_part" =~ \\label\{([^}]*)\} ]]; then
                            label="${BASH_REMATCH[1]}"
                        fi
                    fi
                fi
                
                # Search for subfile on current line first
                subfile=""
                if [[ "$comment_part" =~ \\subfile\{([^}]*)\} ]]; then
                    subfile="${BASH_REMATCH[1]}"
                else
                    # Look ahead up to 3 lines for subfile
                    next_lines=$(sed -n "$((line_num+1)),$((line_num+3))p" "$filepath" 2>/dev/null)
                    if [[ "$next_lines" =~ \\subfile\{([^}]*)\} ]]; then
                        # Verify subfile is not commented out
                        subfile_line="${next_lines%%\\subfile*}\\subfile{${BASH_REMATCH[1]}}"
                        subfile_comment_part="${subfile_line%%\%*}"
                        if [[ "$subfile_comment_part" =~ \\subfile\{([^}]*)\} ]]; then
                            subfile="${BASH_REMATCH[1]}"
                        fi
                    fi
                fi
                
                echo "$cmd|$title|$label|$subfile|$line_num" >> "$temp_results"
            fi
        fi
    done
    
done < "$filepath"

# Sort by line number and write to output file
# Clear output file and write CSV header
echo "level,title,label,subfile,line_number" > "$output_file"

if [[ -f "$temp_results" ]] && [[ -s "$temp_results" ]]; then
    sort -t'|' -k5 -n "$temp_results" | while IFS='|' read -r level title label subfile line; do
        echo "$level,$title,$label,$subfile,$line" >> "$output_file"
    done
    
    entry_count=$(($(wc -l < "$output_file") - 1))
    echo "Table of contents written to $output_file"
    echo "Total entries: $entry_count"
    rm "$temp_results"
else
    echo "No LaTeX hierarchical commands found in file."
    rm "$temp_results"
fi
