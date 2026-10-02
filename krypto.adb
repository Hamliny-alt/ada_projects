package body Krypto is
   function Berakna_Checksumma (Data_Varde : Integer) return Integer is
      Svar : Integer;
   begin
      Svar := (Data_Varde * 31) mod 65536;
      if Svar < 0 then
         Svar := -Svar;
      end if;
      return Svar;
   end Berakna_Checksumma;
end Krypto;
