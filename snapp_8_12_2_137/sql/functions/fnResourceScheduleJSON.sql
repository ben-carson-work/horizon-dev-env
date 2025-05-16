FUNCTION [dbo].[fnResourceScheduleJSON]
/*
 * Returns a json containing the resources linked to a ticket or a transaction
 * Maps to com.vgs.snapp.dataobject.DOResourceScheduleRef
 */
( 
  @typology varchar(8),       -- Entity typology (valid values are: TICKET, HANDOVER, RETURN) (MANDATORY)
  @entityId uniqueidentifier  -- Ticket or transaction identifier (MANDATORY)
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select Cast((
        select * from dbo.fnResourceScheduleTable(@typology, @entityId)
        FOR JSON PATH
      ) as nvarchar(max))
  ) 
END