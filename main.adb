with Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with Krypto;
with Interfaces; use Interfaces;

procedure Main is
   Server      : Socket_Type;
   Client      : Socket_Type;
   Address     : Socket_Add_Type;
   Channel     : Stream_Access;
   Hash_Result : Unsigned_32;
   Running     : Boolean := True;
begin
   Initialize;
   Create_Socket (Server, Family_Inet, Socket_Stream);
   Set_Socket_Option (Server, Socket_Level, Reuse_Address_Option, True);
   
   Address.Addr := Inet_Addr ("127.0.0.1");
   Address.Port := 8081;
   
   Bind_Socket (Server, Address);
   Listen_Socket (Server);
   
   Ada.Text_IO.Put_Line ("[ÆGIS_DAEMON] Lager 2 aktivt. Lyssnar på 127.0.0.1:8081...");

   while Running loop
      Accept_Socket (Server, Client, Address);
      Channel := Stream (Client);
      
      Ada.Text_IO.Put_Line ("[ÆGIS_DAEMON] Klient ansluten via Lager 2.");
      
      begin
         while not End_Of_File (Channel.all) loop
            declare
               Buf : String (1 .. 256);
               Len : Natural := 0;
               Ch  : Character;
            begin
               -- Läs rad tecken för tecken till ny rad (ASCII.LF)
               loop
                  Character'Read (Channel, Ch);
                  exit when Ch = ASCII.LF or else Len = Buf'Last;
                  Len := Len + 1;
                  Buf (Len) := Ch;
               end loop;
               
               -- Rensa bort eventuell CR (stöd för CRLF)
               if Len > 0 and then Buf (Len) = ASCII.CR then
                  Len := Len - 1;
               end if;
               
               declare
                  Cmd : constant String := Buf (1 .. Len);
               begin
                  if Cmd'Length >= 4 and then Cmd (Cmd'First .. Cmd'First + 3) = "HASH" then
                     if Cmd'Length > 5 then
                        declare
                           Data : constant String := Cmd (Cmd'First + 5 .. Cmd'Last);
                        begin
                           Hash_Result := Krypto.Generera_Hash (Data);
                           String'Write (Channel, "RES:HASH 0x" & Unsigned_32'Image (Hash_Result) & ASCII.LF);
                        end;
                     else
                        String'Write (Channel, "ERR: MISSING_DATA" & ASCII.LF);
                     end if;
                     
                  elsif Cmd = "PING" then
                     String'Write (Channel, "RES:PONG" & ASCII.LF);
                     
                  elsif Cmd = "EXIT" then
                     String'Write (Channel, "RES:SHUTTING_DOWN" & ASCII.LF);
                     Running := False;
                     exit;
                     
                  else
                     String'Write (Channel, "ERR: UNKNOWN_COMMAND" & ASCII.LF);
                  end if;
               end;
            end;
         end loop;
      exception
         when others =>
            Ada.Text_IO.Put_Line ("[ÆGIS_DAEMON] Klientanslutning avbruten.");
      end;
      
      Close_Socket (Client);
      
      if not Running then
         exit;
      end if;
   end loop;
   
   Close_Socket (Server);
   Finalize;
   Ada.Text_IO.Put_Line ("[ÆGIS_DAEMON] Stängd.");
end Main;
