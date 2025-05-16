FUNCTION [dbo].[fnGetBaseChars]
/*
 * Given an encoding @base, returns a string with all the usable characters
 */
(
  @base tinyint -- Number of bits per character
)
RETURNS varchar(max)
AS
BEGIN
  declare @result varchar(max);
  declare @chars varchar(32) = '0123456789ABCDEFGHJKMPQRSTUVWXYZ';
  
  if ((@base = 10) or (@base = 16) or (@base = 32))
    set @result = SubString(@chars, 1, @base);
  else
    set @result = dbo.fnRaiseError('Unsupported BASE: ' + Cast(@base as varchar(max)));

  return @result;
END
