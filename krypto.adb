package body Krypto is

   function FNV1a_Hash (Data : String) return Integer is
      Fnv_Offset_Basis : constant Integer := 16#811C9DC5#;
      Fnv_Prime        : constant Integer := 16777619;
      Hash             : Integer := Fnv_Offset_Basis;
   begin
      for C of Data loop
         Hash := Hash xor Character.Pos (C);
         Hash := Hash * Fnv_Prime;
      end loop;
      return Hash;
   end Fnv1a_Hash;

   function Validate_Lattice_State 
     (Vec : Lattice_Vector) return Boolean is
      Valid : Boolean := True;
   begin
      for I in Vec'Range loop
         if Vec (I) < 0 or else Vec (I) >= Modulus then
            Valid := False;
         end if;
         pragma Loop_Invariant 
           (for all J in Vec'First .. I => (Vec (J) >= 0 and Vec (J) < Modulus));
      end loop;
      return Valid;
   end Validate_Lattice_State;

end Krypto;
