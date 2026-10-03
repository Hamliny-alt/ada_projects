with Interfaces; use Interfaces;

package Krypto is
   type Lattice_Element is range -2147483648 .. 2147483647;
   type Lattice_Vector is array (Positive range <>) of Lattice_Element;

   Modulus : constant := 8380417;

   function Generera_Hash (Data : String) return Unsigned_32;
   function Berakna_Checksumma (Data : String) return Unsigned_32;
   function Validera_Gitter (Vec : Lattice_Vector) return Boolean;

end Krypto;
