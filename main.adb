with Ada.Text_IO;
with Krypto;
with Interfaces; use Interfaces;

procedure Main is
   Line        : String (1 .. 256);
   Last        : Natural;
   Hash_Result : Unsigned_32;
begin
   Ada.Text_IO.Put_Line ("[ÆGIS_KERNEL] IPC-server redo. Väntar på kommandon...");

   while not Ada.Text_IO.End_Of_File loop
      Ada.Text_IO.Get_Line (Line, Last);
      
      declare
         Cmd : constant String := Line (1 .. Last);
      begin
         if Cmd'Length >= 4 and then Cmd (Cmd'First .. Cmd'First + 3) = "HASH" then
            -- Exempel på kommando: HASH:data
            if Cmd'Length > 5 then
               declare
                  Data : constant String := Cmd (Cmd'First + 5 .. Cmd'Last);
               begin
                  Hash_Result := Krypto.Generera_Hash (Data);
                  Ada.Text_IO.Put_Line ("RES:HASH 0x" & Unsigned_32'Image (Hash_Result));
               end;
            else
               Ada.Text_IO.Put_Line ("ERR: MISSING_DATA");
            end if;
            
         elsif Cmd = "PING" then
            Ada.Text_IO.Put_Line ("RES:PONG");
            
         elsif Cmd = "EXIT" then
            Ada.Text_IO.Put_Line ("RES:SHUTTING_DOWN");
            exit;
            
         else
            Ada.Text_IO.Put_Line ("ERR: UNKNOWN_COMMAND");
         end if;
      end;
   end loop;
end Main;
