FUNCTION [dbo].[fnSaleItemStatJSON]
/*
 * Returns sale item stat items JSON mapped to DOSale.DOSaleItemStat
 */
(
  @SaleItemId uniqueidentifier    -- Sale item ID
)
RETURNS nvarchar(max)
AS
BEGIN
  declare @table table (SaleItemId uniqueidentifier);

  insert into @table(SaleItemId)
  select SaleItemId 
  from tbSaleItem 
  where MainSaleItemId=@SaleItemId 

  IF (exists(select * from @table))
  BEGIN
    insert into @table(SaleItemId)
    select @SaleItemId 
  END;

  return (
    select distinct
      PRD.ProductId,
      PRD.ProductCode,
      PRD.ProductName,
      SI.SaleItemId,
      SI.Quantity,
      SI.StatAmount,
      (SI.StatAmount * SI.Quantity) as TotalAmount
    from
      @table T inner join
      tbSaleItem SI on SI.SaleItemId=T.SaleItemId inner join
      tbProduct PRD on PRD.ProductId=SI.ProductId
      
    FOR JSON PATH
  ) 
END
