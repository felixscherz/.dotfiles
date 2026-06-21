#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

install_package ollama


MODELS_DIR="$(dirname "$0")/models"

# Register custom models from Modelfiles
for modeldir in "$MODELS_DIR"/*/; do
    model_name="$(basename "$modeldir")"
    ollama create "$model_name" -f "$modeldir/Modelfile"
done
