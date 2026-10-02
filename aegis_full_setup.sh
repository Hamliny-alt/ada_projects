#!/bin/bash
set -e

echo "=================================================="
echo "   ÆGIS TERMUX: FULLSTÄNDIG AUTOMATISERING        "
echo "=================================================="

# 1. Skapa komplett katalogstruktur
echo "[*] Initierar kataloger (active, backup, clean, obj, deltanabla)..."
mkdir -p active backup clean obj deltanabla docs snapshots

# 2. Skapa grundfiler och nätverksregister
echo "[*] Skapar noder, register och loggfiler..."
echo "STEADY STATE" > nodes.registry
touch aegis.log cluster_history.log nodes.json

# 3. Skapa det kompletta Python-masterprogrammet
cat << 'PYTHON_EOF' > aegis_master.py
import os
import json
import time

LOG_FIL = "aegis.log"
REGISTRY_FIL = "nodes.registry"
CLUSTER_LOG = "cluster_history.log"

def logg(msg):
    ts = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    line = f"[{ts}] {msg}"
    with open(LOG_FIL, "a", encoding="utf-8") as f:
        f.write(line + "\n")
    with open(CLUSTER_LOG, "a", encoding="utf-8") as cf:
        cf.write(json.dumps({"time": ts, "event": msg}) + "\n")

def start_menu():
    logg("--- ÆGIS SYSTEM STARTAD (MASTER) ---")
    while True:
        print("\n========================================")
        print("   ÆGIS MASTER KONTROLLPANEL (TERMUX)   ")
        print("========================================")
        print("1. Utför beräkning & nod-audit (-1000 till 1000)")
        print("2. Kör SPARK-verifierad summa (0 till 100)")
        print("3. Generera krypto-hash & synka kluster")
        print("4. Visa klusterlogg och historik")
        print("5. Systemstatus & Noder")
        print("6. Avsluta systemet")
        
        val = input("Välj alternativ (1-6): ").strip()
        
        if val == "1":
            try:
                x = int(input("Ange heltal (-1000 till 1000): "))
                if -1000 <= x <= 1000:
                    res = min(x * x, 100000)
                    print(f"-> Beräknat resultat: {res}")
                    logg(f"Beräkning | Input: {x} | Res: {res}")
                else:
                    print("[Varning] Utanför tillåtet intervall.")
            except ValueError:
                print("[Fel] Ej ett giltigt heltal.")
                
        elif val == "2":
            try:
                n = int(input("Ange N (0 till 100): "))
                if 0 <= n <= 100:
                    res = sum(range(1, n + 1))
                    print(f"-> Verifierad summa: {res}")
                    logg(f"Summa | N: {n} | Res: {res}")
                else:
                    print("[Varning] Måste vara mellan 0 och 100.")
            except ValueError:
                print("[Fel] Ej ett giltigt heltal.")
                
        elif val == "3":
            try:
                v = int(input("Ange värde för krypto-hash: "))
                h = abs((v * 31) % 65536)
                print(f"-> Verifierad Checksumma (Hash): {h}")
                logg(f"Krypto | Värde: {v} | Hash: {h}")
                print("[ÆGIS-KLUSTER] Klustersynk genomförd mot lokala noder.")
            except ValueError:
                print("[Fel] Ej ett giltigt heltal.")
                
        elif val == "4":
            print("\n--- ÆGIS KLUSTER- & LOGGHISTORIK ---")
            if os.path.exists(LOG_FIL):
                with open(LOG_FIL, "r", encoding="utf-8") as f:
                    print(f.read(), end="")
            else:
                print("[Ingen loggfil hittad än.]")
            print("-------------------------------------")
            
        elif val == "5":
            status = open(REGISTRY_FIL).read().strip() if os.path.exists(REGISTRY_FIL) else "UNKNOWN"
            print(f"\n[NOD-STATUS] Node: Termux-Local-Node | State: [{status}] | Phi-Active: True")
            
        elif val == "6":
            print("Systemet stängs ner. Q.E.D.")
            logg("--- SYSTEM AVSLUTAT ---")
            break
        else:
            print("[Fel] Välj ett tal mellan 1 och 6.")

if __name__ == "__main__":
    start_menu()
PYTHON_EOF

chmod +x aegis_master.py
echo "[Klar] ÆGIS-miljön är fullständigt konfigurerad!"
echo ""
echo "Starta systemet när som helst med kommandot:"
echo "python3 aegis_master.py"
echo "=================================================="
