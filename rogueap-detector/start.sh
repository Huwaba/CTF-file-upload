#!/bin/bash
cd "$(dirname "$0")"
source ./config.sh

cleanup() {
    echo -e "\n[*] Shutting down, restoring managed mode..."
    sudo airmon-ng stop "$MON_IFACE" 2>/dev/null
    sudo systemctl restart NetworkManager
    exit 0
}
trap cleanup SIGINT SIGTERM

echo "[*] Enabling monitor mode on $IFACE..."
sudo airmon-ng check kill
sudo airmon-ng start "$IFACE"

export MON_IFACE CHANNELS ALERT_THRESHOLD WINDOW_SECONDS LOG_FILE

echo "[*] Starting detector..."
sudo -E python3 scripts/detect.py
