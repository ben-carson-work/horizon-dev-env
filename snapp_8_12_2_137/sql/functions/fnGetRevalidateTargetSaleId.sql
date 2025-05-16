FUNCTION [dbo].[fnGetRevalidateTargetSaleId]
/*
 * Given input @saleId as "revalidated order", this function returns the target revalidation SaleId, else NULL
 */
(
  @saleId uniqueidentifier    -- Revalidation source sale identifier
)
RETURNS uniqueidentifier
AS
BEGIN
	declare @targetSaleId uniqueidentifier = null;
	
	select top 1
	  @targetSaleId=TRN.SaleId
	from
	  tbSaleItem SI inner join
	  tbSaleItemDetail SID on SID.SaleItemId=SI.SaleItemId inner join
	  tbSaleItemDetailRevalidate SIDR on SIDR.SaleItemDetailId=SID.SaleItemDetailId inner join
	  tbTransaction TRN on TRN.TransactionId=SIDR.TransactionId
	where
	  SI.SaleId=@SaleId
	  
	RETURN @targetSaleId;
END
