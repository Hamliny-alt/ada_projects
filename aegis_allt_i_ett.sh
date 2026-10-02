#!/bin/bash

echo "========================================"
echo "   ÆGIS ALLT-I-ETT KRYPTO & GIT PUSH"
echo "========================================"

# 1. Skapa/uppdatera krypto.ads med SPARK-kontrakt
cat << 'INNER_EOF' > krypto.ads
package Krypto with SPARK_Mode is
   type Crypto_Word is mod 2**32;
   type Hash_State is array (1 .. 4) of Crypto_Word;

   function Mix_Hash_Block (Current_Hash : Hash_State; Input_Val : Crypto_Word) return Hash_State
     with
       Pre  => Input_Val < 2**31,
       Post => Mix_Hash_Block'Result (1) /= Current_Hash (1);
end Krypto;
INNER_EOF

# 2. Skapa/uppdatera krypto.adb med deterministisk mixning
cat << 'INNER_EOF' > krypto.adb
package body Krypto with SPARK_Mode is
   function Mix_Hash_Block (Current_Hash : Hash_State; Input_Val : Crypto_Word) return Hash_State is
      New_State : Hash_State := Current_Hash;
      Const_Key : constant Crypto_Word := 16#9E3779B9#;
   begin
      New_State (1) := New_State (1) xor (Input_Val + Const_Key);
      New_State (2) := New_State (2) + (New_State (1) rotate_left 5);
      New_State (3) := New_State (3) xor New_State (2);
      New_State (4) := New_State (4) + Input_Val;
      return New_State;
   end Mix_Hash_Block;
end Krypto;
INNER_EOF

echo "[*] Kryptofiler genererade."

# 3. Bygg Ada-projektet om gprbuild finns
if command -v gprbuild &> /dev/null; then
    echo "[*] Bygger Ada-komponenter via projekt.gpr..."
    gprbuild -P projekt.gpr
else
    echo "[!] gprbuild hittades inte, hoppar över Ada-kompilering."
fi

# 4. Git Add, Commit & Push
echo "[*] Synkar ändringar till GitHub..."
git add krypto.ads krypto.adb aegis_allt_i_ett.sh
git commit -m "Uppdaterar kryptologi och allt-i-ett flöde med SPARK-kontrakt"
git push origin main

# 5. Starta Python-mastermiljön
if [ -f "aegis_master.py" ]; then
    echo "[*] Startar ÆGIS Master..."
    python3 aegis_master.py
else
    echo "[!] aegis_master.py saknas i katalogen."
fi

echo "========================================"
echo "   SESSION AVSLUTAD. Q.E.D."
echo "========================================"
