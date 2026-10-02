with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Berakningar;
with Loggning;
with Krypto;

procedure Main is
   Val         : Integer := 0;
   Inmatning   : Integer := 0;
   Resultat    : Integer := 0;
   Checksumma  : Integer := 0;
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
            next;
      end;

      case Val is
         when 1 =>
            loop
               Ada.Text_IO.Put ("Mata in ett heltal (-1000 till 1000): ");
               begin
                  Ada.Integer_Text_IO.Get (Inmatning);
                  Ada.Text_IO.Skip_Line;
                  exit when Inmatning in -1000 .. 1000;
                  Ada.Text_IO.Put_Line ("[Varning: Utanför tillåtet intervall.]");
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
            Loggning.Skriv_Logg ("Val 1 - Inmatning: " & Integer'Image (Inmatning) & " | Resultat: " & Integer'Image (Resultat));

         when 2 =>
            loop
               Ada.Text_IO.Put ("Mata in ett tal för summaberäkning (0 till 100): ");
               begin
                  Ada.Integer_Text_IO.Get (Inmatning);
                  Ada.Text_IO.Skip_Line;
                  exit when Inmatning in 0 .. 100;
                  Ada.Text_IO.Put_Line ("[Varning: Måste vara mellan 0 och 100.]");
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
            Loggning.Skriv_Logg ("Val 2 (SPARK Summa) - N: " & Integer'Image (Inmatning) & " | Summa: " & Integer'Image (Resultat));

         when 3 =>
            Ada.Text_IO.Put ("Mata in ett värde för kryptografisk checksumma: ");
            begin
               Ada.Integer_Text_IO.Get (Inmatning);
               Ada.Text_IO.Skip_Line;
               Checksumma := Krypto.Berakna_Checksumma (Inmatning);
               Ada.Text_IO.Put ("-> Verifierad Checksumma (Hash): ");
               Ada.Integer_Text_IO.Put (Checksumma, Width => 1);
               Ada.Text_IO.New_Line;
               Loggning.Skriv_Logg ("Val 3 (Krypto) - Värde: " & Integer'Image (Inmatning) & " | Hash: " & Integer'Image (Checksumma));
            exception
               when Ada.Text_IO.Data_Error =>
                  Ada.Text_IO.Put_Line ("[Fel: Ej ett giltigt heltal.]");
                  Ada.Text_IO.Skip_Line;
            end;

         when 4 =>
            Loggning.Las_Och_Analysera_Logg;

         when 5 =>
            Ada.Text_IO.Put_Line ("Systemet stängs ner. Q.E.D.");
            Loggning.Skriv_Logg ("--- SESSION AVSLUTAD ---");
            exit;

         when others =>
            Ada.Text_IO.Put_Line ("[Fel: Välj ett tal mellan 1 och 5.]");
      end case;
   end loop;
end Main;
