#!/usr/bin/env python3
"""
Split main.tex into subfiles based on toc_main.txt structure.

Usage:
    python split_tex.py
"""

import os
import re
from pathlib import Path

# Configuration
BASE_DIR = Path("/Users/dplane/git_repos/agentic_dissertation/Overleaf_PhD")
MAIN_TEX = BASE_DIR / "main.tex"
TOC_FILE = BASE_DIR / "toc_main.txt"
OUTPUT_MAIN = BASE_DIR / "main_w_sub.tex"
SECTIONS_DIR = BASE_DIR / "sections"

# Mapping from section labels to desired filenames
# This is the user's custom naming
LABEL_TO_FILENAME = {
    "significance_of_study": "significance_of_study.tex",
    "problem_statement1": "problem_statement1.tex",
    "perception_geometry": "perception_geometry.tex",
    "sensors": "sensors.tex",
    "sec:Atlas_LAN": "hardware.tex",
    "sec:calibration": "calibration.tex",
    "sec:sensor_data_dataset": "sensor_data.tex",
    "yolo": "yolo.tex",
    "gbcache": "gbcache.tex",
    "late_fusion": "late_fusion.tex",
    "performance": "performance.tex",
}


class TexSection:
    """Represents a section/chapter in the document structure."""
    def __init__(self, level, title, label, line_num):
        self.level = level  # chapter, section, subsection, subsubsection
        self.title = title
        self.label = label
        self.line_num = int(line_num)
        
    def __repr__(self):
        return f"<{self.level}: {self.title} @{self.line_num}>"


def parse_toc(toc_path):
    """Parse toc_main.txt into structured sections."""
    sections = []
    with open(toc_path, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = [p.strip() for p in line.split(',')]
            if len(parts) == 4:
                level, title, label, line_num = parts
                sections.append(TexSection(level, title, label, line_num))
    return sections


def read_main_tex(main_path):
    """Read main.tex file into list of lines."""
    with open(main_path, 'r', encoding='utf-8') as f:
        return f.readlines()


def find_section_content_range(sections, section_idx):
    """
    Find the line range for a section's content.
    Returns (start_line, end_line) - 1-indexed, inclusive.
    """
    section = sections[section_idx]
    start_line = section.line_num
    
    # Find the next section at the same or higher level
    current_level = section.level
    level_hierarchy = ['chapter', 'section', 'subsection', 'subsubsection']
    current_level_idx = level_hierarchy.index(current_level)
    
    end_line = None
    for i in range(section_idx + 1, len(sections)):
        next_section = sections[i]
        next_level_idx = level_hierarchy.index(next_section.level)
        
        # Stop if we hit a section at same or higher level
        if next_level_idx <= current_level_idx:
            end_line = next_section.line_num - 1
            break
    
    # If no next section found, go to end of file
    if end_line is None:
        end_line = float('inf')
    
    return start_line, end_line


def extract_lines(lines, start, end):
    """Extract lines from list (1-indexed, inclusive)."""
    # Convert to 0-indexed
    start_idx = start - 1
    end_idx = min(end, len(lines))
    return lines[start_idx:end_idx]


def create_subfile(filename, content):
    """Create a subfile with proper template."""
    subfile_content = [
        "\\documentclass[../main.tex]{subfiles}\n",
        "\\graphicspath{{\\subfix{../Images/}}}\n",
        "\\begin{document}\n",
        "\n",
    ]
    
    subfile_content.extend(content)
    
    subfile_content.append("\n\\end{document}\n")
    
    filepath = SECTIONS_DIR / filename
    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(subfile_content)
    
    print(f"  Created: {filename}")


def find_preamble_end(lines):
    """Find the line number where \\begin{document} appears."""
    for i, line in enumerate(lines):
        if line.strip().startswith("\\begin{document}"):
            return i + 1  # Return 1-indexed
    return 1


def find_frontmatter_end(lines):
    """Find the line number where \\mainmatter appears or first \\chapter."""
    for i, line in enumerate(lines):
        if "\\mainmatter" in line or line.strip().startswith("\\chapter{"):
            return i + 1  # Return 1-indexed
    return find_preamble_end(lines)


def generate_main_w_sub(lines, sections):
    """Generate the main_w_sub.tex file."""
    output = []
    
    # Step 1: Copy preamble and add subfiles package
    preamble_end = find_preamble_end(lines)
    preamble = lines[:preamble_end-1]  # Don't include \begin{document} yet
    
    # Add subfiles package before \begin{document}
    output.extend(preamble)
    output.append("\\usepackage{subfiles} % Best loaded last in the preamble\n")
    output.append("\n\\begin{document}\n\n")
    
    # Step 2: Copy frontmatter
    frontmatter_end = find_frontmatter_end(lines)
    frontmatter = extract_lines(lines, preamble_end + 1, frontmatter_end - 1)
    output.extend(frontmatter)
    output.append("\n\\mainmatter\n\\newpage\n")
    
    # Step 3: Process chapters
    chapter_indices = [i for i, s in enumerate(sections) if s.level == 'chapter']
    
    for ch_idx, chapter_idx in enumerate(chapter_indices):
        chapter = sections[chapter_idx]
        
        # Add chapter heading
        if chapter.label:
            output.append(f"\\chapter{{{chapter.title}}} \\label{{{chapter.label}}}\n\n")
        else:
            output.append(f"\\chapter{{{chapter.title}}}\n\n")
        
        # Find sections belonging to this chapter
        next_chapter_idx = chapter_indices[ch_idx + 1] if ch_idx + 1 < len(chapter_indices) else len(sections)
        chapter_sections = [(i, s) for i, s in enumerate(sections[chapter_idx+1:next_chapter_idx], start=chapter_idx+1) 
                           if s.level == 'section']
        
        # Find which sections should be subfiles
        subfile_sections = [(i, s) for i, s in chapter_sections if s.label in LABEL_TO_FILENAME]
        
        if subfile_sections:
            # Copy chapter intro (from chapter to first section)
            first_section_line = chapter_sections[0][1].line_num if chapter_sections else float('inf')
            intro = extract_lines(lines, chapter.line_num, first_section_line - 1)
            # Remove the \chapter line (already added above)
            intro = [l for l in intro if not l.strip().startswith("\\chapter{")]
            output.extend(intro)
            output.append("\n")
            
            # Add subfile commands
            for sect_idx, sect in subfile_sections:
                filename = LABEL_TO_FILENAME[sect.label]
                output.append(f"\\subfile{{sections/{filename.replace('.tex', '')}}}\n")
            
            output.append("\n")
        else:
            # No subfiles - copy entire chapter content
            start_line = chapter.line_num
            end_line = sections[next_chapter_idx].line_num - 1 if next_chapter_idx < len(sections) else len(lines)
            content = extract_lines(lines, start_line, end_line)
            # Remove the \chapter line (already added above)
            content = [l for l in content if not l.strip().startswith("\\chapter{")]
            output.extend(content)
            output.append("\n")
    
    # Step 4: Copy bibliography and backmatter (after last chapter)
    if chapter_indices:
        last_chapter_idx = chapter_indices[-1]
        next_item_idx = last_chapter_idx + 1
        # Find where last chapter's content ends
        while next_item_idx < len(sections) and sections[next_item_idx].level != 'chapter':
            next_item_idx += 1
        
        if next_item_idx < len(sections):
            # There's a backmatter chapter
            backmatter_start = sections[next_item_idx].line_num
        else:
            # Find backmatter manually
            backmatter_start = None
            for i, line in enumerate(lines):
                if '\\backmatter' in line or '\\bibliography' in line:
                    backmatter_start = i + 1
                    break
            if backmatter_start is None:
                backmatter_start = len(lines)
        
        backmatter = lines[backmatter_start-1:]
        output.extend(backmatter)
    
    # Write output
    with open(OUTPUT_MAIN, 'w', encoding='utf-8') as f:
        f.writelines(output)
    
    print(f"\nCreated: main_w_sub.tex")


def main():
    """Main execution function."""
    print("LaTeX Subfile Splitter")
    print("=" * 50)
    
    # Ensure sections directory exists
    SECTIONS_DIR.mkdir(exist_ok=True)
    
    # Parse structure
    print("\n1. Parsing toc_main.txt...")
    sections = parse_toc(TOC_FILE)
    print(f"   Found {len(sections)} sections")
    
    # Read main.tex
    print("\n2. Reading main.tex...")
    lines = read_main_tex(MAIN_TEX)
    print(f"   Read {len(lines)} lines")
    
    # Generate subfiles
    print("\n3. Generating subfiles...")
    for label, filename in LABEL_TO_FILENAME.items():
        # Find the section with this label
        section_idx = next((i for i, s in enumerate(sections) if s.label == label), None)
        if section_idx is None:
            print(f"  WARNING: Label '{label}' not found in toc_main.txt")
            continue
        
        # Extract content
        start, end = find_section_content_range(sections, section_idx)
        content = extract_lines(lines, start, end)
        
        # Create subfile
        create_subfile(filename, content)
    
    # Generate main_w_sub.tex
    print("\n4. Generating main_w_sub.tex...")
    generate_main_w_sub(lines, sections)
    
    print("\n" + "=" * 50)
    print("Complete!")
    print(f"Created {len(LABEL_TO_FILENAME)} subfiles in: {SECTIONS_DIR}")
    print(f"Created main file: {OUTPUT_MAIN}")


if __name__ == "__main__":
    main()