#!/usr/bin/env bash
set -e

if [ -f ../literature/literature.backup.bib ]; then
    mv ../literature/literature.backup.bib ../literature/literature.old.bib
fi

./sort.sh

cp ../literature/literature.bib ../literature/literature.new.bib
mv ../literature/literature.backup.bib ../literature/literature.bib

if diff -q ../literature/literature.new.bib ../literature/literature.bib >/dev/null; then
    echo "The literature is sorted. Nothing to be done."
else
    echo "The literature is not sorted. Please run sort.sh."
    error=1
fi

rm ../literature/literature.new.bib
if [ -f ../literature/literature.old.bib ]; then
    mv ../literature/literature.old.bib ../literature/literature.backup.bib
fi

if [ -n "$error" ]; then
    exit 1
fi