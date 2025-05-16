FUNCTION [dbo].[fnDecodeBase]
/*
 * Decodes a portion of a barcode (@value) into its numerical representation which is calculated depending on the @base
 */
(
  @value varchar(max), -- Barcode portion to be decoded
  @base tinyint        -- Number of bits for each character of the @value. 10 mean numerical only; 16 hexdecimal; etc...
)
RETURNS bigint
WITH ENCRYPTION
AS
BEGIN
  declare @baseChars varchar(max) = dbo.fnGetBaseChars(@base);
  declare @result bigint = 0;
  declare @i int = 0;
  
  while (@i < Len(@value)) 
  begin
    declare @si int = Len(@value) - @i;
    declare @char varchar(1) = SubString(@value, @si, 1);
    declare @idx int = CharIndex(@char, @baseChars) - 1;
    
    if (@i > 0)
      set @idx = @idx * Power(@base, @i);

    set @result = @result + @idx;
    set @i = @i + 1;
  end;

  return @result;	
END
