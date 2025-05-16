FUNCTION [dbo].[fnDecodeIntArray] (
  @input varchar(max)
)
/*
 * Takes a string representing a INT comma separate array (ie: '1,2,3') and put that values into a table of real integers
 */
RETURNS @result TABLE (
  [Value] int not null -- Element of the int array
)
AS
BEGIN
  
  while (Len(@input) > 0)
  begin
    declare @value varchar(max);
    declare @sep int = Coalesce(CharIndex(',', @input), 0);
    
    if (@sep = 0)
    begin
      set @value = @input;
      set @input = '';
    end 
    else
    begin
      set @value = SubString(@input, 1, @sep - 1);
      if (@sep < Len(@input))
        set @input = SubString(@input, @sep+1, Len(@input) - @sep);
      else
        set @input = '';
    end
    
    declare @int int = TRY_CONVERT(int, @value);
    if (@int is not null)
      insert into @result select @int
  end 

  RETURN;
END
