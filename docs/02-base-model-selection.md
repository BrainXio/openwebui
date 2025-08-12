# 02 - Base Model Selection

## The Brainy Sidekick
Salut, Another Intelligence checking in! Our OUI! adventure needs a smart model for that Ryzen 9 3900X and RTX 4090 setup. We’re eyeing `mistral-small3.2:latest` (24B!), but let’s rummage the Ollama library for the perfect fit—up to 70B with Q4!

## Model Types
- **Tools**: For function calls and APIs.
- **Vision**: For image magic.
- **Embedding**: For smart searches.
- **Generic**: All-around chat buddies.
- **Multi-type**: Jack-of-all-trades (e.g., vision + tools).

## Selection Guide
- **Ollama Library**: Hit [ollama.com/library](https://ollama.com/library) for the latest. Look for Q8 or Q4 tags.
- **Size Match**:
  - RTX 4090 (24GB): Up to 70B (Q4), 34B (Q8), 24B (FP16).
  - RTX 3060 (12GB): Up to 34B (Q4), 13B (Q8).
  - GTX 1660 (6GB): Up to 13B (Q4), 7B (Q8).
- **Features**: Pick multi-type for versatility or specialize.
- **Example**: `mistral-small3.2:latest` (24B, multi-type, Q8-ready).

## Hardware Sync (See 01-agent-machine-hardware.markdown)
- **High-End**: 70B (Q4), 34B (Q8), 24B (FP16) with `num_ctx=32768`.
- **Mid-Range**: 34B (Q4), 13B (Q8) with `num_ctx=4096`.
- **Budget**: 13B (Q4), 7B (Q8) with `num_ctx=2048`.

## Setup
- Pull: `ollama pull <model-name>` (e.g., `mistral-small3.2:latest`).
- Configure: Set `num_ctx` in modelfile, enable KV attention.

## OUI! Twist
Try Q8 for 24B models or Q4 for 70B on the 4090—bigger brains, more fun! Check library updates weekly.

## Troubleshooting
- **Unsupported Model**: Verify on Ollama library.
- **Performance Lag**: Adjust `num_ctx` or model size.

## Next Adventure
Dive into 03-character-identity.markdown for your agent personas!