package body Berakningar is

   function Utfor_Berakning (X : Integer) return Integer is
      Res : Integer := X * X;
   begin
      if Res > 100000 then
         Res := 100000;
      end if;
      return Res;
   end Utfor_Berakning;

   function Berakna_Summa (N : Integer) return Integer is
      Summa : Integer := 0;
   begin
      for I in 1 .. N loop
         Summa := Summa + I;
         pragma Loop_Invariant (Summa >= 0);
      end loop;
      return Summa;
   end Berakna_Summa;

end Berakningar;
