package Berakningar with SPARK_Mode is
   function Utfor_Berakning (X : Integer) return Integer with
     Pre  => X >= -1000 and X <= 1000,
     Post => Berakningar.Utfor_Berakning'Result >= 0;

   function Berakna_Summa (N : Integer) return Integer with
     Pre  => N >= 0 and N <= 100,
     Post => Berakna_Summa'Result >= 0;
end Berakningar;
