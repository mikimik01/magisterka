#!/usr/bin/env bash
set -euo pipefail

DOC=main

echo "[1/3] LaTeX (Tectonic) – pierwszy przebieg"
tectonic -X compile "${DOC}.tex"

echo "[2/3] BibTeX – generuję bibliografię"
bibtex "${DOC}" || true

echo "[3/3] LaTeX (Tectonic) – dwa przebiegi dla stabilnych referencji"
tectonic -X compile "${DOC}.tex"
tectonic -X compile "${DOC}.tex"

echo "Gotowe: ${DOC}.pdf"