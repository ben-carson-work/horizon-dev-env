FUNCTION [dbo].[fnDecodeLookupArray] (
  @input varchar(max), -- comma separated int array  (ie: '1,2,3')
  @tableCode int       -- lookup table code for decoding
)
/*
 * Takes a string representing a INT comma separate array (ie: '1,2,3') and put that values into a table of real integers
 */
RETURNS @result TABLE (
  [ItemCode] int not null,
  [ItemName] varchar(max) null,
  [ItemNameRaw] varchar(max) null
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
    begin
      insert into @result 
      select 
        ItemCode,
        ItemName,
        ItemNameRaw
      from
        tbLookupItem
      where
        TableCode=@tableCode and
        ItemCode=@int
    end;
  end 

  RETURN;
END
