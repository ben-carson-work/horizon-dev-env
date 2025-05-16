FUNCTION [dbo].[fnEventProductRawJSON]
/*
 * Returns a JSON containing list of products per event
 * Maps to com.vgs.snapp.dataobject.DOPerformanceRef.DOPerfProductRef
 * 
 * PLEASE NOTE that this JSON is incomplete: it is completed and filtered java side 
 */
(
  @eventId        uniqueidentifier,  -- Performance's Event ID  (MANDATORY)
  @fiscalDate     date            ,  -- Current fiscal date     (MANDATORY)
  @localDateTime  datetime        ,  -- Current local date/time (MANDATORY)
  @eventCatalogId uniqueidentifier   -- Catalog node's event ID (used to filter only products applicable to that catalog's node)
)
RETURNS nvarchar(max)
AS
BEGIN
	declare @localTime time = Cast(@localDateTime as time);
	
  return (
    select
      PRD.ProductId,
      PRD.ProductCode,
      PRD.ProductName
    from
      tbProduct PRD 
    where
      PRD.ProductId in (select ProductId from dbo.fnEventProductTable(@eventId)) and
      PRD.ProductStatus in (2/*onsale*/, 3/*onsale_online*/) and
      (PRD.OnSaleDateFrom      is null or PRD.OnSaleDateFrom                          <=@fiscalDate) and
      (PRD.OnSaleDateTo        is null or PRD.OnSaleDateTo                            >=@fiscalDate) and
      (PRD.OnSaleTimeFrom      is null or dbo.fnDecodeIntTime(PRD.OnSaleTimeFrom)     <=@localTime) and
      (PRD.OnSaleTimeTo        is null or dbo.fnDecodeIntTime(PRD.OnSaleTimeTo)       >=@localTime) and
      (
        @eventCatalogId is null or
        not exists (select * from tbCatalog where ParentCatalogId=@eventCatalogId) or
        exists (select * from tbCatalog where ParentCatalogId=@eventCatalogId and EntityId=PRD.ProductId)
      )
    order by
      PRD.PriorityOrder,
      PRD.ProductName
      
    FOR JSON PATH
  ) 
END
