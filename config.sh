cat > config.sh << 'EOF'
#!/bin/bash
IFACE="wlan0"
MON_IFACE="wlan0mon"
CHANNEL=6
SCAN_DURATION=15
PROBE_DURATION=20
ROGUE_BSSID="DE:AD:BE:EF:00:01"
NETWORKS_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/networks_captured.json"
EOF
