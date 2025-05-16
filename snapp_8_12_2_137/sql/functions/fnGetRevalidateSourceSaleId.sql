FUNCTION [dbo].[fnGetRevalidateSourceSaleId]
/*
 * Given input @saleId as "revalidation order", this function returns the original/revalidated SaleId, else NULL
 */
(
  @saleId uniqueidentifier    -- Revalidation target sale identifier
)
RETURNS uniqueidentifier
AS
BEGIN
	declare @sourceSaleId uniqueidentifier = null;
	
	select top 1
	  @sourceSaleId=SI.SaleId
	from
	  tbTransaction TRN inner join
	  tbSaleItemDetailRevalidate SIDR on SIDR.TransactionId=TRN.TransactionId inner join
	  tbSaleItemDetail SID on SID.SaleItemDetailId=SIDR.SaleItemDetailId inner join
	  tbSaleItem SI on SI.SaleItemId=SID.SaleItemId
	where
	  TRN.SaleId=@SaleId
	  
	RETURN @sourceSaleId;
END
