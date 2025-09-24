#!/usr/bin/env bash
python_env="python_bibtags"
workdir=$(dirname "$0")

if [ -d "$(dirname "$0")/python/${python_env}" ]; then
    source "$(dirname "$0")/python/${python_env}/bin/activate"
else
    python3 -m venv "$(dirname "$0")/python/${python_env}"
    source "$(dirname "$0")/python/${python_env}/bin/activate"
    pip3 install -r "$(dirname "$0")/python/requirements.txt"
fi

python3 "$(dirname "$0")/python/sort.py" "$@"