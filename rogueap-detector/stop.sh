#!/bin/bash
cd "$(dirname "$0")"
source ./config.sh

echo "[*] Stopping monitor mode and restoring network..."
sudo airmon-ng stop "$MON_IFACE" 2>/dev/null
sudo pkill -f detect.py 2>/dev/null
sudo systemctl restart NetworkManager
echo "[*] Done."
