FUNCTION [dbo].[fnSaleAccountJSON]
/*
 * Returns a json containing all sale's accounts
 * Maps to com.vgs.snapp.dataobject.transaction.DOSaleAccountRef
 */
(
  @saleId uniqueidentifier    -- Sale identifier
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select *
    from dbo.fnSaleAccountTable(@saleId)
	  order by
	    SaleAccountType,
	    AccountName
    FOR JSON PATH
  ) 
END
