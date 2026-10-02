package Krypto with SPARK_Mode is
   type Crypto_Word is mod 2**32;
   type Hash_State is array (1 .. 4) of Crypto_Word;

   function Mix_Hash_Block (Current_Hash : Hash_State; Input_Val : Crypto_Word) return Hash_State
     with
       Pre  => Input_Val < 2**31,
       Post => Mix_Hash_Block'Result (1) /= Current_Hash (1);
end Krypto;
