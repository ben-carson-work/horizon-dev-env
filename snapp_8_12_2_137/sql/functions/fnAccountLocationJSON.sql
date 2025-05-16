FUNCTION [dbo].[fnAccountLocationJSON]
/*
 * Returns a json containing all the parent locations of an accoun
 */
(
  @accountId uniqueidentifier    -- Account identifier
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select Cast((
        select AccountId, AccountCode, DisplayName from dbo.fnAccountLocationTable(@accountId)
        FOR JSON PATH
      ) as nvarchar(max))
  ) 
END
