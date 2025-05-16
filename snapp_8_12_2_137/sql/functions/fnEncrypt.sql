FUNCTION [dbo].[fnEncrypt] 
/*
 * Encrypts a barcode portion. This function "obfuscate" better than function dbo.fnEncryptOld()
 */
(
  @value varchar(max), -- Plain string to be encrypted
  @seed smallint,      -- Seed/Password to be used for encryption
  @base tinyint        -- Number of bits per each character. 10 means numerical onyl; 16 means hexdecimal; etc...
)
RETURNS varchar(max)
WITH ENCRYPTION
AS
BEGIN
  declare @result varchar(max) = '';
  declare @baseChars varchar(max) = dbo.fnGetBaseChars(@base);
  declare @seedStr varchar(max) = Cast(@seed % 2500 as varchar(max));
  declare @salt int = 57;
  
  declare @i int = 1;
  while (@i <= Len(@value))
  begin
    declare @char varchar(1) = SubString(@value, @i, 1);
    declare @num bigint = CharIndex(@char, @baseChars) - 1;
    if (@num < 0)
      set @num = dbo.fnRaiseError('Invalid character ''' + @char + ''' for base' + Cast(@base as varchar(max)));

    declare @multiplier int = Cast(SubString(@seedStr, (@i - 1) % Len(@seedStr) + 1, 1) as int);
    set @num = (@num + (@i * @multiplier) + (@seed * @salt)) % @base;
    set @result = @result + SubString(@baseChars, @num + 1, 1);

    set @i = @i + 1;
  end;

  return @result;
END
