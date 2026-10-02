import hmac
import hashlib
import json
import math

SECRET_KEY = b"AEGIS_STEADY_STATE_KEY_2026"
PHI = (1 + math.sqrt(5)) / 2  # Gyllene snittet (~1.618033)

def hämta_sista_signatur():
    try:
        with open("cluster_history.log", "r") as f:
            lines = f.readlines()
            if not lines: return "GENESIS_STATE"
            return json.loads(lines[-1].strip()).get("sig", "GENESIS_STATE")
    except Exception:
        return "GENESIS_STATE"

def iotatime_tick(steg_index):
    fas_tid = steg_index * PHI
    return round(fas_tid, 4)

def logga_iotatime_händelse(steg_index):
    prev_sig = hämta_sista_signatur()
    t_tick = iotatime_tick(steg_index)
    event_text = f"IOTATIME_TICK: [Phi-Phase: {t_tick}]"
    
    payload = f"{prev_sig}:{event_text}".encode('utf-8')
    sig = hmac.new(SECRET_KEY, payload, hashlib.sha256).hexdigest()
    
    log_entry = {
        "iotatime": t_tick,
        "event": event_text,
        "prev_sig": prev_sig,
        "sig": sig
    }
    
    with open("cluster_history.log", "a") as f:
        f.write(json.dumps(log_entry) + "\n")
    print(f"[IOTATIME] Tick {steg_index} loggat. Fas-tid: {t_tick} | Sig: {sig[:10]}...")

print("--- STARTAR IOTATIME-MOTOR ---")
for i in range(1, 4):
    logga_iotatime_händelse(i)
print("--- MOTOR AKTIV I STEADY STATE ---")
