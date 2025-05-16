FUNCTION [dbo].[fnEventProductTable]
/*
 * Returns list of products potentially sellable for the given event 
 */
(
  @eventId uniqueidentifier  -- Event identifier (MANDATORY)
)
RETURNS TABLE 
AS

RETURN (
  select ProductId from tbProduct where ParentEntityId=@eventId
    
  union
    
  select Coalesce(P2AI.ProductId, E.EntityId)
  from
	  tbEntitlement2Event E2E inner join
	  tbEntitlement E on E.EntitlementId=E2E.EntitlementId left join
	  tbProduct2AttributeItem P2AI on P2AI.AttributeItemId=E.EntityId
  where
	  E2E.EventId=@eventId and
	  E.EntityType in (11/*attr.item*/, 12/*prod.type*/)
)
