#!/usr/bin/env bash
# Usage: ./merge.sh
# This script merges the main branch into the current branch.
# This is useful to keep a branch synchronized with the main branch after a pull request.
git fetch origin main && git merge origin/main && git push