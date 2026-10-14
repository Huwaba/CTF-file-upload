cat > scripts/scan_networks.py << 'EOF'
#!/usr/bin/env python3
import sys, os, json
from scapy.all import sniff, Dot11, Dot11Beacon, Dot11Elt

IFACE = os.environ.get("MON_IFACE", "wlan0mon")
SCAN_DURATION = int(os.environ.get("SCAN_DURATION", 15))
OUT_PATH = os.environ.get("NETWORKS_FILE", "networks_captured.json")

networks = {}

def handle_packet(pkt):
    if pkt.haslayer(Dot11Beacon):
        bssid = pkt[Dot11].addr2
        ssid = None
        elt = pkt.getlayer(Dot11Elt)
        while elt:
            if elt.ID == 0:
                try:
                    ssid = elt.info.decode(errors="ignore")
                except Exception:
                    ssid = None
                break
            elt = elt.payload.getlayer(Dot11Elt)
        if bssid and ssid:
            if bssid not in networks:
                print(f"[+] Found: SSID='{ssid}'  BSSID={bssid}")
            networks[bssid] = ssid

def main():
    print(f"[*] Scanning on {IFACE} for {SCAN_DURATION}s...")
    sniff(iface=IFACE, prn=handle_packet, timeout=SCAN_DURATION)
    if not networks:
        print("[!] No networks found.")
        sys.exit(1)
    with open(OUT_PATH, "w") as f:
        json.dump(networks, f, indent=2)
    print(f"[*] Captured {len(networks)} networks -> {OUT_PATH}")

if __name__ == "__main__":
    main()
EOF
