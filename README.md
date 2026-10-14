*Instructions to created and subsequently run CTF Probing (Scanner seperate below)

1. Create a new, uniquely-named project directory. (should already be created on cuseisc-dell001)
cd ~
ls -d ctf-* rogue-* alibi-* 2>/dev/null

2. Run that first just to see if any old folders with similar names already exist, so we don’t collide. Assuming it’s clear, use rogueap-ctf:
  mkdir -p ~/rogueap-ctf/{scripts,logs}
  cd ~/rogueap-ctf

3. Run config.sh
4. Run Scripts/scan_networks.py
5. Run scripts/rebroadcast.py
6. run start.sh
7. run stop.sh

8. Make executable
   chmod +x start.sh stop.sh config.sh script/*.py

9. confirm the layout
    cd ~/rogueap-ctf
   find . -type f
   *expect*
   ./config.sh
   ./start.sh
   ./stop.sh
   ./scripts/scan_networks.py
   ./scripts/rebroadcast.py

10. Confirm your monitor interface name once (safe, no conflicts)
    sudo airmon-ng start wlan0
    iw dev
    sudo airmon-ng stop wlan0mon   # match whatever name actually appeared
    sudo systemctl restart NetworkManager

11. Run it
    cd ~/rogueap-ctf
    sudo ./start.sh
     
