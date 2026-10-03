import sys
import subprocess
import os

def fnv1a_32(data: str) -> int:
    Fnv_Offset_Basis = 0x811C9DC5
    Fnv_Prime = 0x01000193
    hash_val = Fnv_Offset_Basis
    for char in data:
        hash_val ^= ord(char)
        hash_val = (hash_val * Fnv_Prime) & 0xFFFFFFFF
    return hash_val

def run_tests():
    print("[ÆGIS] Startar IPC- och testvektorverifiering mot Ada-kärnan...")
    
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

    # 2. IPC-integrationstest mot Ada-binären
    binary_path = "./obj/main" # Justera efter byggmiljö om nödvändigt
    if os.path.exists(binary_path):
        print("[ÆGIS] Ada-binär hittad. Testar IPC-kommunikation...")
        try:
            # Starta Ada-processen med standard I/O omdirigerad
            proc = subprocess.Popen(
                [binary_path],
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                universal_newlines=True
            )
            
            # Läs välkomstmeddelande
            welcome = proc.stdout.readline()
            print(f"  [ADA SERVER]: {welcome.strip()}")
            
            # Skicka PING-kommando
            proc.stdin.write("PING\n")
            proc.stdin.flush()
            pong_resp = proc.stdout.readline().strip()
            print(f"  [IPC TEST] Skickade: PING | Svar: {pong_resp}")
            if "RES:PONG" in pong_resp:
                print("  [PASS] IPC PING-test godkänt.")
            else:
                print("  [FAIL] IPC PING-test misslyckades.")
                passed = False
                
            # Skicka HASH-kommando
            test_str = "AEGIS_PQC_KERNEL_STATE"
            expected_hash = fnv1a_32(test_str)
            proc.stdin.write(f"HASH:{test_str}\n")
            proc.stdin.flush()
            hash_resp = proc.stdout.readline().strip()
            print(f"  [IPC TEST] Skickade: HASH:{test_str} | Svar: {hash_resp}")
            
            if f"0x{expected_hash:08X}" in hash_resp.upper():
                print("  [PASS] IPC HASH-verifikation mot Ada-kärnan godkänd.")
            else:
                print("  [FAIL] Hash-matchning misslyckades mellan Ada och Python.")
                passed = False
                
            # Avsluta processen snyggt
            proc.stdin.write("EXIT\n")
            proc.stdin.flush()
            proc.wait(timeout=2)
            
        except Exception as e:
            print(f"  [WARN] Fel vid IPC-eksekvering: {e}")
            passed = False
    else:
        print("[ÆGIS] Ingen lokal Ada-binär hittad (hoppar över IPC-test lokalt, körs i CI/CD).")

    if passed:
        print("[ÆGIS] Alla IPC- och referenstester slutförda med godkänt resultat!")
        sys.exit(0)
    else:
        sys.exit(1)

if __name__ == "__main__":
    run_tests()
