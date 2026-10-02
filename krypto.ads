package Krypto with SPARK_Mode is
   type Hash_T is range 0 .. 2**31 - 1;

   function Generera_Hash (Varde : Integer) return Hash_T
     with Pre  => Varde >= -100,
          Post => Generera_Hash'Result >= 0;
end Krypto;
