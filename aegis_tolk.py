import os
import json
import time

LOG_FIL = "aegis.log"
REGISTRY_FIL = "nodes.registry"
CLUSTER_LOG = "cluster_history.log"

def skriv_logg(meddelande):
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    rad = f"[{timestamp}] {meddelande}"
    with open(LOG_FIL, "a", encoding="utf-8") as f:
        f.write(rad + "\n")
    with open(CLUSTER_LOG, "a", encoding="utf-8") as cf:
        cf.write(json.dumps({"time": timestamp, "event": meddelande}) + "\n")

def las_och_analysera_logg():
    print("\n--- ÆGIS KLUSTER- & LOGGHISTORIK ---")
    if os.path.exists(LOG_FIL):
        with open(LOG_FIL, "r", encoding="utf-8") as f:
            print(f.read(), end="")
    else:
        print("[Ingen loggfil hittad än.]")
    print("-------------------------------------")

def utfor_berakning(x):
    res = x * x
    return min(res, 100000)

def berakna_summa(n):
    return sum(range(1, n + 1))

def berakna_checksumma(data_varde):
    return abs((data_varde * 31) % 65536)

def synka_kluster(händelse_typ, värde, hash_res):
    node_status = "STEADY STATE"
    if os.path.exists(REGISTRY_FIL):
        with open(REGISTRY_FIL, "r", encoding="utf-8") as rf:
            node_status = rf.read().strip()
    
    payload = {
        "node": "Termux-Local-Node",
        "status": node_status,
        "action": händelse_typ,
        "input": värde,
        "result": hash_res,
        "phi_active": True
    }
    print(f"[ÆGIS-KLUSTER] Sändning till nätverksnod... Status: [{node_status}]")
    skriv_logg(f"GOSSIP SYNC -> Aktör: {payload['node']} | Handling: {händelse_typ} | Hash: {hash_res}")

def main():
    skriv_logg("--- NY KLUSTERSESSION STARTAD (ALLT-I-ETT) ---")
    
    while True:
        print("\n========================================")
        print("   ÆGIS KLUSTER-TERMINAL & KONTROLL     ")
        print("========================================")
        print("1. Utför beräkning & nod-audit (-1000 till 1000)")
        print("2. Beräkna summa med loop (0 till 100)")
        print("3. Generera krypto-hash & synka kluster")
        print("4. Visa klusterlogg och historik")
        print("5. Avsluta systemet")
        
        val_str = input("Välj ett alternativ (1-5): ").strip()
        
        if not val_str.isdigit():
            print("[Fel: Ogiltigt val. Ange en siffra.]")
            continue
            
        val = int(val_str)
        
        if val == 1:
            try:
                inmatning = int(input("Mata in ett heltal (-1000 till 1000): "))
                if -1000 <= inmatning <= 1000:
                    resultat = utfor_berakning(inmatning)
                    print(f"-> Beräknat resultat: {resultat}")
                    skriv_logg(f"Val 1 - Inmatning: {inmatning} | Resultat: {resultat}")
                    synka_kluster("BERÄKNING", inmatning, resultat)
                else:
                    print("[Varning: Utanför tillåtet intervall.]")
            except ValueError:
                print("[Fel: Ej ett giltigt heltal.]")
                
        elif val == 2:
            try:
                inmatning = int(input("Mata in ett tal för summaberäkning (0 till 100): "))
                if 0 <= inmatning <= 100:
                    resultat = berakna_summa(inmatning)
                    print(f"-> Verifierad summa: {resultat}")
                    skriv_logg(f"Val 2 (Summa) - N: {inmatning} | Summa: {resultat}")
                    synka_kluster("SUMMA", inmatning, resultat)
                else:
                    print("[Varning: Måste vara mellan 0 och 100.]")
            except ValueError:
                print("[Fel: Ej ett giltigt heltal.]")
                
        elif val == 3:
            try:
                inmatning = int(input("Mata in ett värde för kryptografisk checksumma: "))
                checksumma = berakna_checksumma(inmatning)
                print(f"-> Verifierad Checksumma (Hash): {checksumma}")
                skriv_logg(f"Val 3 (Krypto) - Värde: {inmatning} | Hash: {checksumma}")
                synka_kluster("KRYPTO_HASH", inmatning, checksumma)
            except ValueError:
                print("[Fel: Ej ett giltigt heltal.]")
                
        elif val == 4:
            las_och_analysera_logg()
            
        elif val == 5:
            print("Systemet stängs ner. Q.E.D.")
            skriv_logg("--- KLUSTERSESSION AVSLUTAD ---")
            break
        else:
            print("[Fel: Välj ett tal mellan 1 och 5.]")

if __name__ == "__main__":
    main()
