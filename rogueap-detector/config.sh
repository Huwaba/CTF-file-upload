#!/bin/bash
IFACE="wlan0"
MON_IFACE="wlan0mon"
CHANNELS="1,2,3,4,5,6,7,8,9,10,11"
ALERT_THRESHOLD=1          # flag if an SSID is seen on more than this many distinct BSSIDs
WINDOW_SECONDS=20          # how far back to look when correlating SSID->BSSID sightings
LOG_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/logs/detector.log"
