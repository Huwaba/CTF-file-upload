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

export MON_IFACE CHANNEL SCAN_DURATION PROBE_DURATION ROGUE_BSSID NETWORKS_FILE

while true; do
    echo "============================================"
    echo "[SCAN] Capturing real SSIDs/BSSIDs for ${SCAN_DURATION}s..."
    echo "============================================"
    sudo -E python3 scripts/scan_networks.py | tee -a logs/scan.log

    echo ""
    echo "============================================"
    echo "[PROBE] Rebroadcasting cloned SSIDs for ${PROBE_DURATION}s..."
    echo "============================================"
    timeout "$PROBE_DURATION" sudo -E python3 scripts/rebroadcast.py | tee -a logs/probe.log

    echo "[*] Cycle complete. Re-scanning..."
    sleep 2
done
EOF
