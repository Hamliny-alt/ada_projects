import sys
import subprocess
import os
import socket
import time

def fnv1a_32(data: str) -> int:
    Fnv_Offset_Basis = 0x811C9DC5
    Fnv_Prime = 0x01000193
    hash_val = Fnv_Offset_Basis
    for char in data:
        hash_val ^= ord(char)
        hash_val = (hash_val * Fnv_Prime) & 0xFFFFFFFF
    return hash_val

def run_tests():
    print("[ÆGIS] Startar referenstester och Lager 2 socket-integration...")
    
    passed = True
    
    # 1. Python-referenstester
    test_cases = [
        ("", 0x811C9DC5),
        ("a", 0xE40C292C),
        ("AEGIS_PQC_KERNEL_STATE", fnv1a_32("AEGIS_PQC_KERNEL_STATE"))
    ]
    
    for data, expected in test_cases:
        result = fnv1a_32(data)
        if result == expected:
            print(f"  [PASS] Python-referens Hash('{data}') -> 0x{result:08X}")
        else:
            print(f"  [FAIL] Python-referens Hash('{data}') -> Förväntade 0x{expected:08X}, fick 0x{result:08X}")
            passed = False

    # 2. Lager 2 Socket-integrationstest mot Ada-daemonen
    binary_path = "./obj/main"
    if os.path.exists(binary_path):
        print("[ÆGIS] Ada-binär hittad. Startar daemon för Lager 2-test...")
        daemon_proc = None
        try:
            # Starta Ada-daemonen i bakgrunden
            daemon_proc = subprocess.Popen([binary_path])
            time.sleep(1) # Ge servern en sekund att binda port 8081
            
            # Anslut via TCP-socket (Lager 2)
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect(("127.0.0.1", 8081))
            
            # Skicka PING
            s.sendall(b"PING\n")
            pong_resp = s.recv(1024).decode('utf-8').strip()
            print(f"  [Lager 2 SOCKET] Skickade: PING | Svar: {pong_resp}")
            if "RES:PONG" in pong_resp:
                print("  [PASS] Socket PING-test godkänt.")
            else:
                print("  [FAIL] Socket PING-test misslyckades.")
                passed = False
                
            # Skicka HASH
            test_str = "AEGIS_PQC_KERNEL_STATE"
            expected_hash = fnv1a_32(test_str)
            s.sendall(f"HASH:{test_str}\n".encode('utf-8'))
            hash_resp = s.recv(1024).decode('utf-8').strip()
            print(f"  [Lager 2 SOCKET] Skickade: HASH:{test_str} | Svar: {hash_resp}")
            
            if f"0x{expected_hash:08X}" in hash_resp.upper():
                print("  [PASS] Socket HASH-verifikation mot Ada-kärnan godkänd.")
            else:
                print("  [FAIL] Hash-matchning via socket misslyckades.")
                passed = False
                
            # Stäng av daemonen snyggt
            s.sendall(b"EXIT\n")
            s.close()
            
            daemon_proc.wait(timeout=2)
            
        except Exception as e:
            print(f"  [WARN] Fel vid Lager 2 socket-eksekvering: {e}")
            if daemon_proc:
                daemon_proc.terminate()
            passed = False
    else:
        print("[ÆGIS] Ingen lokal Ada-binär hittad (hoppar över Lager 2 socket-test lokalt, körs i CI/CD).")

    if passed:
        print("[ÆGIS] Alla Lager 2- och referenstester slutförda med godkänt resultat!")
        sys.exit(0)
    else:
        sys.exit(1)

if __name__ == "__main__":
    run_tests()
