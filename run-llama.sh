#!/usr/bin/env bash
# ==============================================================================
#  run-llama.sh — Run llama-server with gemma270m.gguf
# ==============================================================================
#  Author  : Percio Castelo <percio@perciocastelo.com.br>
#  Website : https://perciocastelo.com.br
#  Repo    : https://github.com/sr00t3d/nexus-llm-gemma
#  License : Apache-2.0
# ==============================================================================

set -eo pipefail

MODEL_FILE="${MODEL_FILE:-gemma270m.gguf}"
PORT="${PORT:-8080}"
HOST="${HOST:-0.0.0.0}"
CTX_SIZE="${CTX_SIZE:-2048}"
N_GPU_LAYERS="${N_GPU_LAYERS:-99}"

if [ ! -f "$MODEL_FILE" ]; then
    echo "[INFO] Model file '$MODEL_FILE' not found. Fetching via fetch-model.sh..."
    bash "$(dirname "$0")/fetch-model.sh" "$(dirname "$MODEL_FILE")"
fi

if ! command -v llama-server >/dev/null 2>&1; then
    echo "[ERROR] llama-server binary not found in PATH."
    echo "Install llama.cpp or compile llama-server to run the model server."
    exit 1
fi

echo "[INFO] Starting llama-server with $MODEL_FILE on http://${HOST}:${PORT} (ctx=${CTX_SIZE})..."
exec llama-server \
    --model "$MODEL_FILE" \
    --host "$HOST" \
    --port "$PORT" \
    --ctx-size "$CTX_SIZE" \
    --n-gpu-layers "$N_GPU_LAYERS" \
    --alias "gemma-270m"
