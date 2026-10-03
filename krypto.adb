with Interfaces; use Interfaces;
with Ada.Characters.Handling;

package body Krypto is

   function Generera_Hash (Data : String) return Unsigned_32 is
      Fnv_Offset_Basis : constant Unsigned_32 := 16#811C9DC5#;
      Fnv_Prime        : constant Unsigned_32 := 16#01000193#;
      Hash_Val         : Unsigned_32 := Fnv_Offset_Basis;
   begin
      for C of Data loop
         Hash_Val := Hash_Val xor Unsigned_32 (Character'Pos (C));
         Hash_Val := Hash_Val * Fnv_Prime;
      end loop;
      return Hash_Val;
   end Generera_Hash;

   function Validera_Gitter (Vec : Lattice_Vector) return Boolean is
   begin
      for I in Vec'Range loop
         if Vec (I) < 0 or else Lattice_Element(Vec (I)) >= Lattice_Element(Modulus) then
            return False;
         end if;
      end loop;
      return True;
   end Validera_Gitter;

end Krypto;
