#!/bin/bash
set -e  # stop when error
# === 1. Create & activate conda env ===
echo "[INFO] Creating conda env f5-tts with Python 3.10..."
conda create -y -n f5-tts python=3.10
source $(conda info --base)/etc/profile.d/conda.sh
conda activate f5-tts

# === 2. Install PyTorch (CUDA 12.4) ===
echo "[INFO] Installing PyTorch 2.4.0 (CUDA 12.4)..."
pip install torch==2.4.0+cu124 torchaudio==2.4.0+cu124 --extra-index-url https://download.pytorch.org/whl/cu124

# === 3. Install f5-tts ===
echo "[INFO] Installing f5-tts..."
pip install f5-tts

# === 4. Clone repo ===
echo "[INFO] Cloning F5-TTS-Vietnamese repo..."
git clone https://github.com/letuankiet146/F5-TTS-Vietnamese.git
cd F5-TTS-Vietnamese

# === 5. Install editable mode ===
echo "[INFO] Installing repo in editable mode..."
pip install -e .

# === 6. Prepare vi_voice folder ===
echo "[INFO] Preparing vi_voice folder..."
mkdir -p vi_voice
cd vi_voice
touch script.txt

# === 7. Download model + config from Hugging Face ===
echo "[INFO] Downloading model_last.pt..."
huggingface-cli download hynt/F5-TTS-Vietnamese-ViVoice model_last.pt \
  --local-dir . \
  --local-dir-use-symlinks False

echo "[INFO] Downloading config.json..."
huggingface-cli download hynt/F5-TTS-Vietnamese-ViVoice config.json \
  --local-dir . \
  --local-dir-use-symlinks False

# rename config.json -> vocab.txt
mv config.json F5-TTS-Vietnamese/vocab.txt
mv model_last.pt F5-TTS-Vietnamese/model_last.pt

# === 8. Go back to repo root ===

echo "[INFO] ✅ Setup completed!"
