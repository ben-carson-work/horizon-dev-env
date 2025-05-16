FUNCTION [dbo].[fnLeadZero] 
/* 
 * Converts the number @num into a string of the required @length filling with '0' in front if necessary
 * */
(
  @num bigint,      -- Number to be formatted
  @length tinyint   -- Length of the output string
)
RETURNS varchar(max)
WITH ENCRYPTION
AS
BEGIN
  declare @result varchar(max) = Cast(@num as varchar(max));
  
  while (Len(@result) < @length)
  begin
    set @result = '0' + @result;
  end;

  return @result;
END
