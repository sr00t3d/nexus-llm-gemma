# nexus-llm-gemma (Português)

> Distribuição oficial do modelo Gemma 270M GGUF de ultra-baixa latência para o NEXUS AI Hub, satélites Oracle Cloud (OCI) e inferência em edge.

[![Licença](https://img.shields.io/badge/Licen%C3%A7a-Apache_2.0-blue.svg)](LICENSE)
[![Formato](https://img.shields.io/badge/Formato-GGUF-orange.svg)](https://github.com/ggerganov/llama.cpp)
[![Tamanho](https://img.shields.io/badge/Tamanho-231%20MB-brightgreen.svg)](releases)
[![SHA-256](https://img.shields.io/badge/SHA--256-Verificado-success.svg)](#especifica%C3%A7%C3%B5es-do-modelo)
[![Autor](https://img.shields.io/badge/Autor-Percio%20Castelo-blueviolet.svg)](https://perciocastelo.com.br)

---

## Visão Geral

O **`nexus-llm-gemma`** é o repositório canônico de distribuição do modelo **Gemma 270M GGUF** (`gemma270m.gguf`), otimizado para o ecossistema **NEXUS AI Hub**. Especialmente projetado para tarefas de classificação rápida em tempo real, respostas estruturadas e workers com restrição severa de recursos (< 500 MB de RAM).

Este repositório substitui o armazenamento local no servidor web, oferecendo entrega global acelerada via CDN do GitHub para os satélites de IA na Oracle Cloud Infrastructure (OCI).

---

## Especificações do Modelo

| Parâmetro | Detalhe |
|---|---|
| **Nome do Arquivo** | `gemma270m.gguf` |
| **Arquitetura Base** | Google Gemma |
| **Parâmetros** | ~270 Milhões |
| **Formato** | GGUF (compatível com `llama.cpp` b2500+) |
| **Tamanho do Arquivo** | `241.410.208 bytes` (~231 MB) |
| **Janela de Contexto** | 2048 tokens |
| **Consumo de Memória** | `< 500 MB` RAM |
| **Checksum SHA-256** | `5f4b2e17722e510122c464573b880587f4983347a40e5472b858d5a3c1ab8095` |

---

## Download Rápido

### Linux / macOS (Automático com Verificação)

```bash
# Baixa e verifica integridade no diretório atual:
curl -fsSL https://raw.githubusercontent.com/sr00t3d/nexus-llm-gemma/main/fetch-model.sh | bash

# Ou especificando pasta de destino:
curl -fsSL https://raw.githubusercontent.com/sr00t3d/nexus-llm-gemma/main/fetch-model.sh | bash -s -- /opt/models
```

### Windows (PowerShell 5.1+ / 7+)

```powershell
irm https://raw.githubusercontent.com/sr00t3d/nexus-llm-gemma/main/fetch-model.ps1 | iex
```

### Download Direto via GitHub Releases

```bash
wget -O gemma270m.gguf "https://github.com/sr00t3d/nexus-llm-gemma/releases/download/v1.0.0/gemma270m.gguf"
```

---

## Executando com `llama-server`

```bash
# Iniciar servidor REST na porta 8080:
./run-llama.sh
```

No Windows PowerShell:
```powershell
.\run-llama.ps1
```

### Teste de Requisição (Chat Completions)

```bash
curl -s http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemma-270m",
    "messages": [
      {"role": "user", "content": "Olá! Resuma o seu propósito em uma frase."}
    ]
  }' | jq .
```

---

## Integração com NEXUS e Satélites OCI

Nos nós satélites provisionados pelo NEXUS na Oracle Cloud, o modelo é baixado diretamente do GitHub Release:

```bash
wget -O /opt/models/model.gguf \
  "https://github.com/sr00t3d/nexus-llm-gemma/releases/download/v1.0.0/gemma270m.gguf"
```

---

## Licença

Distribuído sob a licença **Apache-2.0**. Consulte o arquivo [LICENSE](LICENSE) para detalhes.

Mantido por **[Percio Castelo](https://perciocastelo.com.br)**.
