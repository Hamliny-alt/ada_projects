package body Krypto with SPARK_Mode is

   function Mix_Hash_Block (Current_Hash : Hash_State; Input_Val : Crypto_Word) return Hash_State is
      New_State : Hash_State := Current_Hash;
      Const_Key : constant Crypto_Word := 16#9E3779B9#;
   begin
      New_State (1) := New_State (1) xor (Input_Val + Const_Key);
      New_State (2) := New_State (2) + (New_State (1) rotate_left 5);
      New_State (3) := New_State (3) xor New_State (2);
      New_State (4) := New_State (4) + Input_Val;
      return New_State;
   end Mix_Hash_Block;

   function Berakna_Checksumma (Input_Val : Integer) return Integer is
      State  : Hash_State := (others => 0);
      Value  : Crypto_Word;
      Result : Crypto_Word;
   begin
      Value := Crypto_Word (abs Input_Val mod 1_000_000);
      State := Mix_Hash_Block (State, Value);
      Result := State (1) xor State (2) xor State (3) xor State (4);
      return Integer (Result);
   end Berakna_Checksumma;

end Krypto;
