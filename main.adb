with Ada.Text_IO;
with Krypto;
with Interfaces; use Interfaces;

procedure Main is
   Test_Data : constant String := "AEGIS_PQC_KERNEL_STATE";
   Hash_Result : Unsigned_32;
   Checksum : Unsigned_32;
   Sample_Vector : Krypto.Lattice_Vector (1 .. 3) := (100, 200, 300);
begin
   Ada.Text_IO.Put_Line ("[ÆGIS] Initialiserar formell verifiering och kärna...");
   
   Hash_Result := Krypto.Generera_Hash (Test_Data);
   Checksum := Krypto.Berakna_Checksumma (Test_Data);
   
   Ada.Text_IO.Put_Line ("[KRYPTO] Hash genererad med framgång.");
   
   if Krypto.Validera_Gitter (Sample_Vector) then
      Ada.Text_IO.Put_Line ("[GITTER] Vektor godkänd inom modulen.");
   else
      Ada.Text_IO.Put_Line ("[GITTER] Vektor utanför tillåtet intervall.");
   end if;
end Main;
