cat > start.sh << 'EOF'
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
sudo iw dev "$MON_IFACE" set channel "$CHANNEL"

export MON_IFACE CHANNEL ROGUE_BSSID ROGUE_SSID

echo "[*] Starting rogue broadcast..."
sudo -E python3 scripts/rebroadcast.py | tee -a logs/probe.log
EOF
