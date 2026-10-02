with Ada.Text_IO;

package body Loggning is

   procedure Skriv_Logg (Meddelande : String) is
      Fil : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Open (Fil, Ada.Text_IO.Append_File, "aegis.log");
      Ada.Text_IO.Put_Line (Fil, Meddelande);
      Ada.Text_IO.Close (Fil);
   exception
      when Ada.Text_IO.Name_Error =>
         Ada.Text_IO.Create (Fil, Ada.Text_IO.Out_File, "aegis.log");
         Ada.Text_IO.Put_Line (Fil, Meddelande);
         Ada.Text_IO.Close (Fil);
   end Skriv_Logg;

   procedure Las_Och_Analysera_Logg is
      Fil : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line ("--- ÆGIS LOGGHISTORIK & ANALYS ---");
      begin
         Ada.Text_IO.Open (Fil, Ada.Text_IO.In_File, "aegis.log");
         while not Ada.Text_IO.End_Of_File (Fil) loop
            Ada.Text_IO.Put_Line (Ada.Text_IO.Get_Line (Fil));
         end loop;
         Ada.Text_IO.Close (Fil);
      exception
         when Ada.Text_IO.Name_Error =>
            Ada.Text_IO.Put_Line ("[Ingen loggfil hittad än.]");
      end;
      Ada.Text_IO.Put_Line ("-----------------------------------");
   end Las_Och_Analysera_Logg;

end Loggning;
