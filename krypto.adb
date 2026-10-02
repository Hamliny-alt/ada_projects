package body Krypto with SPARK_Mode is
   function Generera_Hash (Varde : Integer) return Hash_T is
      Base  : constant Hash_T := 2166136261;
      Prime : constant Hash_T := 16777619;
      Val   : constant Hash_T := Hash_T(abs(Varde));
   begin
      return (Base xor Val) * Prime mod 2**31;
   end Generera_Hash;
end Krypto;
