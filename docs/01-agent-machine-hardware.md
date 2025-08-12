# 01 - Agent Machine Hardware

## The Journey Begins
Bonjour, Another Intelligence here! Our OUI! adventure kicks off by sizing up the machines that fuel our agents. We’re cruising with an AMD Ryzen 9 3900X (12 cores), 128GB RAM, and an RTX 4090 (24GB VRAM) as our playground, running Ollama via OpenWebUI. But let’s explore the wild hardware jungle—bigger beasts, bigger brains!

## Hardware Profiles
- **High-End Powerhouse** (Our Setup):
  - **CPU**: AMD Ryzen 9 3900X (12 cores, 24 threads).
  - **RAM**: 128GB DDR4.
  - **GPU**: RTX 4090 (24GB VRAM).
  - **Deployment**: Local Ollama on Ubuntu 22.04.
  - **Capacity**: Handles up to 70B parameters (Q4), 34B (Q8), 24B (FP16/bf16) with `num_ctx=32768`, thanks to Q8 and KV attention.
- **Mid-Range Warrior**:
  - **CPU**: Intel i7-10700 (8 cores, 16 threads).
  - **RAM**: 32GB DDR4.
  - **GPU**: RTX 3060 (12GB VRAM).
  - **Deployment**: Docker container on Windows 10.
  - **Capacity**: Supports up to 34B (Q4), 13B (Q8) with `num_ctx=4096`.
- **Budget Explorer**:
  - **CPU**: AMD Ryzen 5 3600 (6 cores, 12 threads).
  - **RAM**: 16GB DDR4.
  - **GPU**: GTX 1660 Super (6GB VRAM).
  - **Deployment**: Local VM on macOS.
  - **Capacity**: Manages up to 13B (Q4), 7B (Q8) with `num_ctx=2048`.
- **Cloud Dreamer**:
  - **CPU**: AWS c5.18xlarge (36 vCPUs).
  - **RAM**: 72GB.
  - **GPU**: NVIDIA A10G (24GB VRAM).
  - **Deployment**: AWS EC2 with Ollama container.
  - **Capacity**: Scales to 70B (Q4), 34B (Q8) with `num_ctx=16384`.

## Key Ingredients
- **VRAM**: Drives model size—24GB handles 24B FP16, 34B Q8, 70B Q4 with optimizations.
- **RAM**: 128GB buffers big batches; 16GB needs swap for smaller models.
- **CPU**: 12+ cores speed up preprocessing; fewer cores slow things down.
- **Env Vars**: KV attention, `OLLAMA_NUM_THREADS=12`, `OLLAMA_MAX_RAM=90GB` active.

## Setup Tips
- Pull model: `ollama pull mistral-small3.2:latest` (24B fits RTX 4090!).
- Tune `num_ctx` per VRAM (e.g., 32768 for RTX 4090, 2048 for GTX 1660).
- Monitor with `nvidia-smi` or system tools.

## OUI! Experiment
Crank up Q8 quantization (`ollama run --quantize 8`) to tame those 24B models on the 4090. Mix deployments—local for speed, cloud for scale!

## Troubleshooting
- **Memory Crash**: Reduce `num_ctx` or switch to Q4.
- **Slow Load**: Boost CPU threads or RAM.
- **Deployment Fail**: Check Ollama logs.

## Next Stop
Hop to 02-base-model-selection.markdown to pick your brainy buddy!