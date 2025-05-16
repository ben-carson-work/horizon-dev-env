FUNCTION [dbo].[fnAccountLocationIDs]
/*
 * Returns all the parent locations of an account in a comma separated string
 */
(
  @accountId uniqueidentifier    -- Account identifier
)
RETURNS varchar(max)
AS
BEGIN
  return (
    select Stuff((
      select ',' + cast(AccountId as varchar(max)) from (
        select AccountId from dbo.fnAccountLocationTable(@accountId)
      ) x
      FOR XML PATH('')
    ), 1, 1, '')
  )
END
