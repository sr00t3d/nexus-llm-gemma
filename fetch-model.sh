#!/usr/bin/env bash
# ==============================================================================
#  fetch-model.sh — Download & Verify Gemma 270M GGUF Model Asset
# ==============================================================================
#  Author  : Percio Castelo <percio@perciocastelo.com.br>
#  Website : https://perciocastelo.com.br
#  Repo    : https://github.com/sr00t3d/nexus-llm-gemma
#  License : Apache-2.0
# ==============================================================================

set -eo pipefail

MODEL_NAME="gemma270m.gguf"
MODEL_EXPECTED_SHA256="5f4b2e17722e510122c464573b880587f4983347a40e5472b858d5a3c1ab8095"
MODEL_VERSION="v1.0.0"
MODEL_RELEASE_URL="https://github.com/sr00t3d/nexus-llm-gemma/releases/download/${MODEL_VERSION}/${MODEL_NAME}"
MODEL_RAW_LFS_URL="https://media.githubusercontent.com/media/sr00t3d/nexus-llm-gemma/main/${MODEL_NAME}"

TARGET_DIR="${1:-.}"
TARGET_FILE="${TARGET_DIR}/${MODEL_NAME}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log_info()    { printf "%b[INFO]%b  %s\n" "$CYAN" "$NC" "$*"; }
log_success() { printf "%b[OK]%b    %s\n" "$GREEN" "$NC" "$*"; }
log_warn()    { printf "%b[WARN]%b  %s\n" "$YELLOW" "$NC" "$*"; }
log_error()   { printf "%b[ERROR]%b %s\n" "$RED" "$NC" "$*" >&2; }

verify_checksum() {
    local file="$1"
    if [ ! -f "$file" ]; then
        return 1
    fi
    local actual_sha
    if command -v sha256sum >/dev/null 2>&1; then
        actual_sha=$(sha256sum "$file" | awk '{print $1}')
    elif command -v shasum >/dev/null 2>&1; then
        actual_sha=$(shasum -a 256 "$file" | awk '{print $1}')
    else
        log_warn "Neither sha256sum nor shasum available; skipping hash check."
        return 0
    fi

    if [ "$actual_sha" = "$MODEL_EXPECTED_SHA256" ]; then
        return 0
    else
        log_error "Checksum mismatch!"
        log_error "Expected : $MODEL_EXPECTED_SHA256"
        log_error "Actual   : $actual_sha"
        return 2
    fi
}

mkdir -p "$TARGET_DIR"

if [ -f "$TARGET_FILE" ]; then
    log_info "Found existing $TARGET_FILE. Verifying integrity..."
    if verify_checksum "$TARGET_FILE"; then
        log_success "File $TARGET_FILE is already present and verified healthy."
        exit 0
    else
        log_warn "Existing file is corrupt or incomplete. Re-downloading..."
        rm -f "$TARGET_FILE"
    fi
fi

log_info "Downloading $MODEL_NAME from GitHub Release (${MODEL_VERSION})..."
DOWNLOAD_OK=false

if command -v curl >/dev/null 2>&1; then
    if curl -fL --progress-bar -o "$TARGET_FILE" "$MODEL_RELEASE_URL"; then
        DOWNLOAD_OK=true
    fi
elif command -v wget >/dev/null 2>&1; then
    if wget --show-progress -q -O "$TARGET_FILE" "$MODEL_RELEASE_URL"; then
        DOWNLOAD_OK=true
    fi
fi

if [ "$DOWNLOAD_OK" = false ]; then
    log_warn "Release URL failed, falling back to Git LFS media endpoint..."
    if command -v curl >/dev/null 2>&1; then
        curl -fL --progress-bar -o "$TARGET_FILE" "$MODEL_RAW_LFS_URL" && DOWNLOAD_OK=true
    elif command -v wget >/dev/null 2>&1; then
        wget --show-progress -q -O "$TARGET_FILE" "$MODEL_RAW_LFS_URL" && DOWNLOAD_OK=true
    fi
fi

if [ "$DOWNLOAD_OK" = false ] || [ ! -f "$TARGET_FILE" ]; then
    log_error "Failed to download $MODEL_NAME from both release and LFS endpoints."
    exit 1
fi

log_info "Verifying SHA-256 integrity..."
if verify_checksum "$TARGET_FILE"; then
    log_success "Download complete and verified successfully: $TARGET_FILE"
    exit 0
else
    log_error "Downloaded file failed checksum verification. Deleting invalid download."
    rm -f "$TARGET_FILE"
    exit 2
fi
