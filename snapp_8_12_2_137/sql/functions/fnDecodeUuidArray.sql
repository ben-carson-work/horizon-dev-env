FUNCTION [dbo].[fnDecodeUuidArray] (
  @input varchar(max)
)
/*
 * Takes a string representing a UUID comma separate array (ie: 'xxxx,yyyy,zzzz') and put that values into a table of real UUIDs
 */
RETURNS @result TABLE (
  [Value] uniqueidentifier not null -- Element of the UUID array
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
    
    declare @uuid uniqueidentifier = TRY_CONVERT(uniqueidentifier, @value);
    if (@uuid is not null)
      insert into @result select @uuid
  end 

  RETURN;
END
