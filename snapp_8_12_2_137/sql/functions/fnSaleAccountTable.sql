FUNCTION [dbo].[fnSaleAccountTable]
/*
 * Returns list of sale accounts (ie: ower, guest, association, etc...)
 */
(
  @saleId uniqueidentifier  -- Sale identifier (MANDATORY)
)
RETURNS TABLE 
AS

RETURN (
	select
	  S2A.SaleAccountType,
    ACC.EntityType,
	  ACC.AccountId,
	  ACC.AccountCode,
	  ACC.DisplayName as AccountName,
    ACC.AccountStatus,
	  AD.FirstName,
	  AD.LastName,
	  AD.EmailAddress
	from
	  tbSale2Account S2A inner join
	  tbAccount ACC on ACC.AccountId=S2A.AccountId left join
	  tbAccountDetail AD on AD.AccountId=ACC.AccountId
	where
	  S2A.SaleId=@saleId
)
