#!/usr/bin/env bash
# Usage: ./tags.sh [tt|ek|...]

# This script finds all tags used by the given workgroup member in the literature.bib file.
# The workgroup member is specified by the first argument, which consists of the first letters of the first and last name.
# The script is useful to quickly look up which tags are available, so as to avoid duplication.

who=${1:-"ek"}
grep "${who}tags" "$(dirname "$0")"/../literature/literature.bib | cut -d= -f2- | tr -d '{}' | tr , '\n' | grep -E .+ | sort | uniq
