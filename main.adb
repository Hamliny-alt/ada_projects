with Ada.Text_IO;
with Ada.Command_Line;
with Krypto;
with Interfaces; use Interfaces;

procedure Main is
   Input_Data    : String (1 .. 256);
   Last          : Natural := 0;
   Hash_Result   : Unsigned_32;
   Sample_Vector : Krypto.Lattice_Vector (1 .. 3) := (100, 200, 300);
begin
   if Ada.Command_Line.Argument_Count > 0 then
      declare
         Arg : constant String := Ada.Command_Line.Argument (1);
      begin
         Hash_Result := Krypto.Generera_Hash (Arg);
         Ada.Text_IO.Put_Line ("HASH:" & Unsigned_32'Image (Hash_Result));
      end;
   else
      -- Standardkörning om inga argument ges
      Ada.Text_IO.Put_Line ("[ÆGIS] Kör standarddiagnostik...");
      Hash_Result := Krypto.Generera_Hash ("AEGIS_PQC_KERNEL_STATE");
      Ada.Text_IO.Put_Line ("HASH: 0x" & Unsigned_32'Image (Hash_Result));
   end if;

   if Krypto.Validera_Gitter (Sample_Vector) then
      Ada.Text_IO.Put_Line ("LATTICE: VALID");
   else
      Ada.Text_IO.Put_Line ("LATTICE: INVALID");
   end if;
end Main;
