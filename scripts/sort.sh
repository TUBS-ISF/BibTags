#!/usr/bin/env bash

if command -v python3 &> /dev/null; then
	PYTHON=python3
else
	PYTHON=python
fi
python_env="python_bibtags"
if [ -d "python/${python_env}" ]; then
	source python/${python_env}/bin/activate
else
	if command -v pip3 &> /dev/null; then
		PIP=pip3
	else
		PIP=pip
	fi
	$PYTHON -m pip install --upgrade pip
	$PYTHON -m venv python/${python_env}
	source python/${python_env}/bin/activate
	$PIP install -r python/requirements.txt
fi

python3 python/sort.py
