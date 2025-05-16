FUNCTION [dbo].[fnInvoiceItemTaxJSON]
/*
 * Returns invoice item taxes JSON mapped to DOPrint_Invoice.DOInvoiceTax
 */
(
  @InvoiceItemId uniqueidentifier    -- Invoice item ID
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select distinct
      TAX.TaxId,
      TAX.TaxCode,
      TAX.TaxName,
      SIT.TaxAmount as UnitAmount,
      (SIT.TaxAmount * II.Quantity) as TotalAmount
    from
      tbInvoiceItem II inner join
      tbSaleItemTax SIT on SIT.SaleItemId=II.SaleItemId inner join
      tbTax TAX on TAX.TaxId=SIT.TaxId
    where
      II.InvoiceItemId=@InvoiceItemId
      
    FOR JSON PATH
  ) 
END
