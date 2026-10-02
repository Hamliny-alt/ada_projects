package Berakningar with SPARK_Mode is
   function Utfor_Berakning (X : Integer) return Integer with
     Pre  => X in -1000 .. 1000,
     Post => Utfor_Berakning'Result >= 0;

   function Berakna_Summa (N : Integer) return Integer with
     Pre  => N in 0 .. 100,
     Post => Berakna_Summa'Result >= 0;
end Berakningar;
