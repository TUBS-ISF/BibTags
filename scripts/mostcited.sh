#!/bin/bash
# Usage: ./extract-citations.sh <directory1> [directory2] [...]

# Script to extract citation keys from TeX files and cross-reference with literature.bib

if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory1> [directory2] [...]"
    echo "Extracts citation keys from all TeX files in the given directories"
    exit 1
fi

# Find the script directory to locate literature.bib
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BIB_FILE="$PROJECT_DIR/literature/literature.bib"

if [ ! -f "$BIB_FILE" ]; then
    echo "Error: Bibliography file not found at $BIB_FILE"
    exit 1
fi

# Temporary files for processing
TEMP_CITATIONS=$(mktemp)
TEMP_COUNTS=$(mktemp)
TEMP_TITLES=$(mktemp)

# Clean up temporary files on exit
trap "rm -f $TEMP_CITATIONS $TEMP_COUNTS $TEMP_TITLES" EXIT

echo "Extracting citations from TeX files in directories: $*"
echo "Using bibliography: $BIB_FILE"
echo ""

# Extract all citation keys from TeX files in given directories
for dir in "$@"; do
    if [ ! -d "$dir" ]; then
        echo "Warning: Directory '$dir' does not exist, skipping..."
        continue
    fi
    
    find "$dir" -name "*.tex" -type f -exec grep -h -o '\\cite[pt]\?{[^}]*}' {} \; >> $TEMP_CITATIONS 2>/dev/null || true
    find "$dir" -name "*.tex" -type f -exec grep -h -o '\\nocite{[^}]*}' {} \; >> $TEMP_CITATIONS 2>/dev/null || true
done

if [ ! -s "$TEMP_CITATIONS" ]; then
    echo "No citations found in the specified directories."
    exit 0
fi

# Extract citation keys from citation commands and count occurrences
sed 's/\\[a-z]*cite[pt]*{\([^}]*\)}/\1/g' "$TEMP_CITATIONS" | \
    tr ',' '\n' | \
    sed 's/^[[:space:]]*//' | \
    sed 's/[[:space:]]*$//' | \
    grep -v '^$' | \
    sort | \
    uniq -c | \
    sort -nr > $TEMP_COUNTS

# Extract bibliography entries and titles, including handling renamedfrom
awk '
/^@(article|book|inproceedings|incollection|techreport|phdthesis|mastersthesis|misc|inbook|conference|unpublished|proceedings|manual)\{/ {
    # Extract citation key
    gsub(/^@[a-zA-Z]*\{/, "", $0)
    gsub(/,.*$/, "", $0)
    key = $0
    in_entry = 1
    title = ""
    renamedfrom = ""
}
in_entry && /^[[:space:]]*title[[:space:]]*=/ {
    # Extract title
    title_line = $0
    gsub(/^[[:space:]]*title[[:space:]]*=[[:space:]]*\{/, "", title_line)
    gsub(/\}[[:space:]]*,?[[:space:]]*$/, "", title_line)
    gsub(/^\{/, "", title_line)
    gsub(/\}$/, "", title_line)
    gsub(/\{\{/, "\"", title_line)
    gsub(/\}\}/, "\"", title_line)
    title = title_line
}
in_entry && /^[[:space:]]*renamedfrom[[:space:]]*=/ {
    # Extract renamedfrom value
    renamed_line = $0
    gsub(/^[[:space:]]*renamedfrom[[:space:]]*=[[:space:]]*\{/, "", renamed_line)
    gsub(/\}[[:space:]]*,?[[:space:]]*$/, "", renamed_line)
    renamedfrom = renamed_line
}
/^}/ && in_entry {
    if (title != "") {
        print key "|||" title
        # Also create an entry for the old name if it exists
        if (renamedfrom != "") {
            print renamedfrom "|||" title
        }
    }
    in_entry = 0
    title = ""
    renamedfrom = ""
}
' "$BIB_FILE" > $TEMP_TITLES

# Display results
echo "Citation Analysis Results"
echo "========================="
echo ""

total_citations=0
unique_citations=0

while IFS= read -r line; do
    count=$(echo "$line" | awk '{print $1}')
    key=$(echo "$line" | awk '{print $2}')
    
    total_citations=$((total_citations + count))
    unique_citations=$((unique_citations + 1))
    
    # Find the title for this key
    title=$(grep "^$key|||" "$TEMP_TITLES" | cut -d'|' -f4- | sed 's/{{/"/g' | sed 's/}}/"/g')
    
    if [ -n "$title" ]; then
        printf "%3d %-20s %s\n" "$count" "$key" "$title"
    else
        printf "%3d %-20s\n" "$count" "$key"
    fi
done < "$TEMP_COUNTS"

echo ""
echo "Summary"
echo "======="
echo "Total citations: $total_citations"
echo "Unique citation keys: $unique_citations"