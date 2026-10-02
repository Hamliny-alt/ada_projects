package Krypto with SPARK_Mode is
   function Berakna_Checksumma (Data_Varde : Integer) return Integer with
     Pre  => Data_Varde >= -10000 and Data_Varde <= 10000,
     Post => Berakna_Checksumma'Result >= 0;
end Krypto;
