import time

class Aegis5DEngine:
    def __init__(self, node_id="Termux-Local-Node"):
        self.node_id = node_id
        self.phi_ratio = 1.61803398875  # Gyllene snittet för fas-modulation
        
    def calculate_phase_matrix(self, spatial_x: float, spatial_y: float, spatial_z: float, temporal_t: float) -> dict:
        """
        Beräknar den 5-dimensionella temporalspatiala matrisen.
        5D = (X, Y, Z, T, Phi-Phase)
        """
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
