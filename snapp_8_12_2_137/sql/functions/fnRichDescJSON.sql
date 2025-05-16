FUNCTION [dbo].[fnRichDescJSON]
/*
 * Returns a json containing html descriptions for required entity
 * Maps to com.vgs.snapp.dataobject.DORichDescItem
 */
(
  @entityId     uniqueidentifier    -- Entity identifier identifier (ie: ProductId, EventId, etc...)
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select 
      RD.LangISO,
      Rd.Description
    from 
      tbRichDesc RD
    where
      RD.EntityId=@entityId
	  order by
	    RD.LangISO
    FOR JSON PATH
  ) 
END
