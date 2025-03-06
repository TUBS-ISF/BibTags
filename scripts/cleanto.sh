#!/usr/bin/env bash
java -cp mibtex/mibtex-cleaner.jar de.mibtex.BibtexCleaner "../literature/literature.bib" -o "$1/literature-cleaned.bib" "${@:2}"
cp "../literature/MYabrv.bib" "$1"
cp "../literature/MYshort.bib" "$1"
