#!/usr/bin/env bash
# recon.sh — reconhecimento rápido de um alvo. Correr no Kali.
# Uso: ./recon.sh 192.168.20.10
set -euo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "Uso: $0 <IP-alvo>"
  exit 1
fi

OUT="recon-${TARGET}"
mkdir -p "$OUT"

echo "[*] Scan de portas + serviços em $TARGET ..."
sudo nmap -sV -sC -p- "$TARGET" -oN "$OUT/nmap.txt"

echo "[*] Identificar tecnologias web (8080) ..."
whatweb "http://${TARGET}:8080" | tee "$OUT/whatweb.txt" || true

echo "[*] Fuzzing de diretórios (8080) ..."
gobuster dir -u "http://${TARGET}:8080" \
  -w /usr/share/wordlists/dirb/common.txt \
  -o "$OUT/gobuster.txt" || true

echo "[+] Resultados em: $OUT/"
