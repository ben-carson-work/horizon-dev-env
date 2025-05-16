FUNCTION [dbo].[fnDecryptOld] 
/*
 * Decrypts a barcode portion encrypted through dbo.fnEncryptOld() function.
 */
(
  @value varchar(max), -- Plain string to be encrypted. Supposed to be Base32
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
    set @idx = (@idx - @seed - (@i*@i*(@seed+1)));
    while (@idx < 0)
      set @idx = @idx + @base;
    
	  set @result = @result + SubString(@baseChars, @idx + 1, 1);

    set @i = @i + 1;
  end;

  return @result;
END
