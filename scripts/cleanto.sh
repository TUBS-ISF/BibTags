#!/usr/bin/env bash
set -e

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <output-dir> [options]"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: $1 is not a directory"
    exit 1
fi

java -cp mibtex/MibTeX.jar de.mibtex.BibtexCleaner "../literature/literature.bib" -o "$1/literature-cleaned.bib" "${@:2}"
cp "../literature/MYabrv.bib" "$1"
cp "../literature/MYshort.bib" "$1"
