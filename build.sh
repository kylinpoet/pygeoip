#!/bin/bash

function warning { echo "Warning: $1"; }
function error { echo "Error: $1" 1>&2; exit 1; }

if [ -z "$(virtualenv --version)" ]; then
    error "Missing virtualenv binary"
fi

if [ ! -d venv ]; then
	virtualenv venv || error "virtualenv failed"
	venv/bin/pip install tox nose epydoc || error "pip failed"
fi

venv/bin/tox || error "tox failed"
venv/bin/epydoc --config=epydoc.ini --no-private || error "epydoc failed"

if [ -z "$(pandoc --version)" ]; then
    warning "Skipping Markdown to reStructuredText translation"
else
    pandoc -f markdown -t rst -o README.rst README.md || error "pandoc failed"
fi

