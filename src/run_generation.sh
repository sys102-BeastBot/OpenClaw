#!/bin/bash
# run_generation.sh — called by OpenClaw cron
# Runs one generation of the learning loop

set -e

LOG_DIR="$HOME/.openclaw/workspace/learning/monitor"
LOG_FILE="$LOG_DIR/orchestrator.log"

mkdir -p "$LOG_DIR"
cd "$HOME/.openclaw/workspace/learning"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) Starting generation..." >> "$LOG_FILE"
python3 src/orchestrator.py --generation auto >> "$LOG_FILE" 2>&1
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) Done." >> "$LOG_FILE"
