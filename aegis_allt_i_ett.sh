#!/bin/bash

echo "========================================"
echo "   ÆGIS ALLT-I-ETT 5D & GIT-SYNK"
echo "========================================"

# 1. Säkerställ att aegis_5d.py finns
if [ ! -f "aegis_5d.py" ]; then
    cat << 'INNER_EOF' > aegis_5d.py
import time

class Aegis5DEngine:
    def __init__(self, node_id="Termux-Local-Node"):
        self.node_id = node_id
        self.phi_ratio = 1.61803398875  # Gyllene snittet för fas-modulation
        
    def calculate_phase_matrix(self, spatial_x: float, spatial_y: float, spatial_z: float, temporal_t: float) -> dict:
        phi_phase = (spatial_x + spatial_y + spatial_z) * (temporal_t / self.phi_ratio)
        matrix_state = {
            "Node": self.node_id,
            "Coordinates_5D": {
                "X": spatial_x,
                "Y": spatial_y,
                "Z": spatial_z,
                "T (Time/IOTATIME)": temporal_t,
                "Phi_Phase": round(phi_phase, 4)
            },
            "System_State": "STEADY STATE",
            "Timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        }
        return matrix_state
INNER_EOF
    echo "[*] aegis_5d.py skapad."
fi

# 2. Bygg Ada-projektet om gprbuild finns
if command -v gprbuild &> /dev/null; then
    echo "[*] Bygger Ada-komponenter via projekt.gpr..."
    gprbuild -P projekt.gpr
else
    echo "[!] gprbuild hittades inte, hoppar över Ada-kompilering."
fi

# 3. Git Add, Commit & Push
echo "[*] Synkar ändringar till GitHub..."
git add aegis_5d.py aegis_allt_i_ett.sh aegis_master.py 2>/dev/null
git commit -m "Integrerar 5D-fasrumsmotor och utökar kontrollpanelen" 2>/dev/null
git push origin main 2>/dev/null

# 4. Starta Python-mastermiljön
if [ -f "aegis_master.py" ]; then
    echo "[*] Startar ÆGIS Master..."
    python3 aegis_master.py
else
    echo "[!] aegis_master.py saknas i katalogen."
fi

echo "========================================"
echo "   SESSION AVSLUTAD. Q.E.D."
echo "========================================"
