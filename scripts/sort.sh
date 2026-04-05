#!/usr/bin/env bash
workdir=$(dirname "$0")

if command -v python3 &> /dev/null; then
	PYTHON=python3
else
	PYTHON=python
fi
python_env="python_bibtags"

if [ -d "$(dirname "$0")/python/${python_env}" ]; then
    source "$(dirname "$0")/python/${python_env}/bin/activate"
else
    $PYTHON -m venv "$(dirname "$0")/python/${python_env}"
    source "$(dirname "$0")/python/${python_env}/bin/activate"
    pip install -r "$(dirname "$0")/python/requirements.txt"
fi

$PYTHON "$(dirname "$0")/python/sort.py" "$@"
