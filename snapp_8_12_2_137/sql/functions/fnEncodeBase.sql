FUNCTION [dbo].[fnEncodeBase]
/*
 * Convert a number into a string representation on a different @base
 */
(
  @value bigint,   -- Number to be converted
  @length tinyint, -- Length of the output string
  @base tinyint    -- Number of bits usable for each output char. 10 means numerical only; 16 mean hexdecimal; etc...
)
RETURNS varchar(max)
WITH ENCRYPTION
AS
BEGIN
  declare @baseChars varchar(max) = dbo.fnGetbaseChars(@base);
  declare @result varchar(max) = '';
  declare @v bigint = @value;

  while (@v > 0) 
  begin
    if (Len(@result) >= @length)
      return dbo.fnRaiseError('Value "' + Cast(@value as varchar(max)) + '" cannot fit a ' + Cast(@length as varchar(max)) + ' characters string base ' + Cast(@base as varchar(max)));
    
    set @result = SubString(@baseChars, (@v % @base) + 1, 1) + @result;
    set @v = @v / @base;
  end;

  while (Len(@result) < @length) 
    set @result = '0' + @result;

  return @result;	
END
