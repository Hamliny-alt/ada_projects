with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Berakningar;
with Loggning;
with Krypto;

procedure Main is
   Val         : Integer;
   Inmatning   : Integer;
   Resultat    : Integer;
   Checksumma  : Integer;
   Korrekt     : Boolean;
begin
   Loggning.Skriv_Logg ("--- NY SESSION STARTAD (TERMUX) ---");

   loop
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line ("========================================");
      Ada.Text_IO.Put_Line ("   ÆGIS ADA-TERMINAL & KONTROLLPANEL    ");
      Ada.Text_IO.Put_Line ("========================================");
      Ada.Text_IO.Put_Line ("1. Utför beräkning (-1000 till 1000)");
      Ada.Text_IO.Put_Line ("2. Beräkna summa med SPARK-loop (0 till 100)");
      Ada.Text_IO.Put_Line ("3. Generera krypto-checksumma för värde");
      Ada.Text_IO.Put_Line ("4. Visa logghistorik och analys");
      Ada.Text_IO.Put_Line ("5. Avsluta systemet");
      Ada.Text_IO.Put ("Välj ett alternativ (1-5): ");

      begin
         Ada.Integer_Text_IO.Get (Val);
         Ada.Text_IO.Skip_Line;
      exception
         when Ada.Text_IO.Data_Error =>
            Ada.Text_IO.Put_Line ("[Fel: Ogiltigt val. Ange en siffra.]");
            Ada.Text_IO.Skip_Line;
            goto Nasta_Varv;
      end;

      if Val = 1 then
         Korrekt := False;
         while not Korrekt loop
            Ada.Text_IO.Put ("Mata in ett heltal (-1000 till 1000): ");
            begin
               Ada.Integer_Text_IO.Get (Inmatning);
               Ada.Text_IO.Skip_Line;
               if Inmatning >= -1000 and Inmatning <= 1000 then
                  Korrekt := True;
               else
                  Ada.Text_IO.Put_Line ("[Varning: Utanför tillåtet intervall.]");
               end if;
            exception
               when Ada.Text_IO.Data_Error =>
                  Ada.Text_IO.Put_Line ("[Fel: Ej ett giltigt heltal.]");
                  Ada.Text_IO.Skip_Line;
            end;
         end loop;

         Resultat := Berakningar.Utfor_Berakning (Inmatning);
         Ada.Text_IO.Put ("-> Beräknat resultat: ");
         Ada.Integer_Text_IO.Put (Resultat, Width => 1);
         Ada.Text_IO.New_Line;
         Loggning.Skriv_Logg ("Val 1 - Inmatning: " & Integer'Image(Inmatning) & " | Resultat: " & Integer'Image(Resultat));

      elsif Val = 2 then
         Korrekt := False;
         while not Korrekt loop
            Ada.Text_IO.Put ("Mata in ett tal för summaberäkning (0 till 100): ");
            begin
               Ada.Integer_Text_IO.Get (Inmatning);
               Ada.Text_IO.Skip_Line;
               if Inmatning >= 0 and Inmatning <= 100 then
                  Korrekt := True;
               else
                  Ada.Text_IO.Put_Line ("[Varning: Måste vara mellan 0 och 100.]");
               end if;
            exception
               when Ada.Text_IO.Data_Error =>
                  Ada.Text_IO.Put_Line ("[Fel: Ej ett giltigt heltal.]");
                  Ada.Text_IO.Skip_Line;
            end;
         end loop;

         Resultat := Berakningar.Berakna_Summa (Inmatning);
         Ada.Text_IO.Put ("-> Verifierad summa: ");
         Ada.Integer_Text_IO.Put (Resultat, Width => 1);
         Ada.Text_IO.New_Line;
         Loggning.Skriv_Logg ("Val 2 (SPARK Summa) - N: " & Integer'Image(Inmatning) & " | Summa: " & Integer'Image(Resultat));

      elsif Val = 3 then
         Ada.Text_IO.Put ("Mata in ett värde för kryptografisk checksumma: ");
         begin
            Ada.Integer_Text_IO.Get (Inmatning);
            Ada.Text_IO.Skip_Line;
            Checksumma := Krypto.Berakna_Checksumma (Inmatning);
            Ada.Text_IO.Put ("-> Verifierad Checksumma (Hash): ");
            Ada.Integer_Text_IO.Put (Checksumma, Width => 1);
            Ada.Text_IO.New_Line;
            Loggning.Skriv_Logg ("Val 3 (Krypto) - Värde: " & Integer'Image(Inmatning) & " | Hash: " & Integer'Image(Checksumma));
         exception
            when Ada.Text_IO.Data_Error =>
               Ada.Text_IO.Put_Line ("[Fel: Ej ett giltigt heltal.]");
               Ada.Text_IO.Skip_Line;
         end;

      elsif Val = 4 then
         Loggning.Las_Och_Analysera_Logg;

      elsif Val = 5 then
         Ada.Text_IO.Put_Line ("Systemet stängs ner. Q.E.D.");
         Loggning.Skriv_Logg ("--- SESSION AVSLUTAD ---");
         exit;
      else
         Ada.Text_IO.Put_Line ("[Fel: Välj ett tal mellan 1 och 5.]");
      end if;

      <<Nasta_Varv>>
      null;
   end loop;
end Main;
