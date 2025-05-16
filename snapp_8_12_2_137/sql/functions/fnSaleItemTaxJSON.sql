FUNCTION [dbo].[fnSaleItemTaxJSON]
/*
 * Returns sale item taxes JSON mapped to DOSale.DOSaleItemTax
 */
(
  @SaleItemId uniqueidentifier    -- Sale item ID
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select distinct
      TAX.TaxId,
      TAX.TaxCode,
      TAX.TaxName,
      SIT.TaxRate,
      SIT.TaxAmount as UnitAmount,
      (SIT.TaxAmount * SI.Quantity) as TotalAmount
    from
      tbSaleItem SI inner join
      tbSaleItemTax SIT on SIT.SaleItemId=SI.SaleItemId inner join
      tbTax TAX on TAX.TaxId=SIT.TaxId
    where
      SI.SaleItemId=@SaleItemId
      
    FOR JSON PATH
  ) 
END
