#!/usr/bin/env bash
python_env="python_bibtags"

if [ -d "python/${python_env}" ]; then
    source python/${python_env}/bin/activate
else
    python3 -m venv python/${python_env}
    source python/${python_env}/bin/activate
    pip3 install -r python/requirements.txt
fi

python3 python/sort.py
