with Interfaces; use Interfaces;

package Krypto is
   -- Typer för gitterkrypto och hashning
   type Lattice_Element is range -2147483648 .. 2147483647;
   type Lattice_Vector is array (Positive range <>) of Lattice_Element;

   Modulus : constant := 8380417; -- Standard Q-modul för PQC (t.ex. Kyber)

   function Generera_Hash (Data : String) return Unsigned_32;
   function Validera_Gitter (Vec : Lattice_Vector) return Boolean;

end Krypto;
