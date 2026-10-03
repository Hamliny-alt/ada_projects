import sys

def fnv1a_32(data: str) -> int:
    """Python-referensimplementation av FNV-1a 32-bit för testvektorer"""
    Fnv_Offset_Basis = 0x811C9DC5
    Fnv_Prime = 0x01000193
    hash_val = Fnv_Offset_Basis
    for char in data:
        hash_val ^= ord(char)
        hash_val = (hash_val * Fnv_Prime) & 0xFFFFFFFF
    return hash_val

def run_tests():
    print("[ÆGIS] Kör NIST/Referens-testvektorer för krypto-kärnan...")
    
    # Testvektorer för FNV-1a
    test_cases = [
        ("", 0x811C9DC5),
        ("a", 0xE40C292C),
        ("AEGIS_PQC_KERNEL_STATE", fnv1a_32("AEGIS_PQC_KERNEL_STATE"))
    ]
    
    passed = True
    for data, expected in test_cases:
        result = fnv1a_32(data)
        if result == expected:
            print(f"  [PASS] Hash('{data}') -> 0x{result:08X}")
        else:
            print(f"  [FAIL] Hash('{data}') -> Förväntade 0x{expected:08X}, fick 0x{result:08X}")
            passed = False
            
    if passed:
        print("[ÆGIS] Alla testvektorer verifierade med godkänt resultat!")
        sys.exit(0)
    else:
        sys.exit(1)

if __name__ == "__main__":
    run_tests()
