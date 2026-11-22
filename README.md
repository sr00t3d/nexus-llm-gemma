# nexus-llm-gemma

> Ultra-low latency Gemma 270M GGUF model distribution for NEXUS AI Hub, Oracle Cloud (OCI) satellites, and edge inference.

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Format](https://img.shields.io/badge/Format-GGUF-orange.svg)](https://github.com/ggerganov/llama.cpp)
[![Size](https://img.shields.io/badge/File%20Size-231%20MB-brightgreen.svg)](releases)
[![SHA-256](https://img.shields.io/badge/SHA--256-Verified-success.svg)](#model-specifications)
[![Author](https://img.shields.io/badge/Author-Percio%20Castelo-blueviolet.svg)](https://perciocastelo.com.br)

---

## Overview

**`nexus-llm-gemma`** provides the official, verified distribution of the **Gemma 270M GGUF** model (`gemma270m.gguf`) utilized by the **NEXUS AI Hub** ecosystem. Optimized specifically for sub-second classification, fast structured responses, and edge worker tasks, this model delivers maximum performance with minimal memory overhead (< 500 MB RAM).

This repository serves as the single source of truth for automated provisioning on remote Oracle Cloud Infrastructure (OCI) instances, local development nodes, and CI/CD pipelines.

---

## Model Specifications

| Parameter | Specification |
|---|---|
| **Model Name** | `gemma270m.gguf` |
| **Base Architecture** | Google Gemma |
| **Parameter Count** | ~270 Million |
| **Container / Format** | GGUF (compatible with `llama.cpp` b2500+) |
| **File Size** | `241,410,208 bytes` (230.22 MB / ~231 MB) |
| **Default Context Window** | 2048 tokens |
| **Memory Footprint** | `< 500 MB` RAM (CPU-only or full GPU offload) |
| **SHA-256 Checksum** | `5f4b2e17722e510122c464573b880587f4983347a40e5472b858d5a3c1ab8095` |

---

## Quickstart & Download

### Option 1: Automatic Download & Verification (Linux / macOS)

```bash
# Download and verify in current directory:
curl -fsSL https://raw.githubusercontent.com/sr00t3d/nexus-llm-gemma/main/fetch-model.sh | bash

# Or specify a custom target directory:
curl -fsSL https://raw.githubusercontent.com/sr00t3d/nexus-llm-gemma/main/fetch-model.sh | bash -s -- /opt/models
```

### Option 2: Automatic Download & Verification (Windows PowerShell)

```powershell
# In PowerShell 5.1+ or 7+:
irm https://raw.githubusercontent.com/sr00t3d/nexus-llm-gemma/main/fetch-model.ps1 | iex
```

### Option 3: Direct Download via GitHub Releases (CDN)

```bash
wget -O gemma270m.gguf "https://github.com/sr00t3d/nexus-llm-gemma/releases/download/v1.0.0/gemma270m.gguf"
```

### Option 4: Git LFS Clone

```bash
git lfs install
git clone https://github.com/sr00t3d/nexus-llm-gemma.git
```

---

## Running the Model

### Using `llama-server` (OpenAI-Compatible REST API)

```bash
# Launch server on port 8080:
./run-llama.sh

# Or invoke directly:
llama-server \
  --model gemma270m.gguf \
  --host 0.0.0.0 \
  --port 8080 \
  --ctx-size 2048 \
  --n-gpu-layers 99 \
  --alias "gemma-270m"
```

On Windows:
```powershell
.\run-llama.ps1
```

### Testing with `curl` (Chat Completions)

```bash
curl -s http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemma-270m",
    "messages": [
      {"role": "system", "content": "You are a concise security classifier."},
      {"role": "user", "content": "Analyze this string: 127.0.0.1 - root login attempt"}
    ],
    "temperature": 0.2
  }' | jq .
```

---

## Integration with NEXUS & OCI Satellites

In the NEXUS ecosystem (`task.perciocastelo.com.br`), OCI satellite nodes pull this model during initialization via `deploy-oci.sh` and `gemma-engine.sh`:

```bash
# OCI On-Demand Provisioning
wget -O /opt/models/model.gguf \
  "https://github.com/sr00t3d/nexus-llm-gemma/releases/download/v1.0.0/gemma270m.gguf"
```

---

## Checksum Verification

```bash
# Linux
echo "5f4b2e17722e510122c464573b880587f4983347a40e5472b858d5a3c1ab8095  gemma270m.gguf" | sha256sum -c -

# macOS
shasum -a 256 gemma270m.gguf

# Windows PowerShell
(Get-FileHash .\gemma270m.gguf -Algorithm SHA256).Hash
```

---

## License

Distributed under the **Apache-2.0 License**. See [LICENSE](LICENSE) for more details.

Developed and maintained by **[Percio Castelo](https://perciocastelo.com.br)**.
