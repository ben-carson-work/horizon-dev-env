FUNCTION [dbo].[fnEncryptOld] 
/*
 * Encrypts a barcode portion. This function "obfuscate" worse than function dbo.fnEncrypt(),
 * but is maintened because its the original way we used to encrypt barcodes from the beginning
 * and needs to be mantained for backward compability.
 * 
 * Both input and output are base32.
 */
(
  @value varchar(max), -- Plain string (Base32) to be encrypted
  @seed smallint       -- Seed/Password to be used for encryption
)
RETURNS varchar(max)
WITH ENCRYPTION
AS
BEGIN
  declare @result varchar(max) = '';
  declare @base int = 32;
  declare @baseChars varchar(max) = dbo.fnGetBaseChars(@base);
  set @seed = @seed % 8;
  
  declare @i int = 0;
  while (@i < Len(@value))
  begin
    declare @char varchar(1) = SubString(@value, @i+1, 1);
    declare @idx int = CharIndex(@char, @baseChars) - 1;
    set @idx = (@idx + @seed + (@i*@i*(@seed+1))) % @base;
	  set @result = @result + SubString(@baseChars, @idx + 1, 1);

    set @i = @i + 1;
  end;

  return @result;
END
