FUNCTION [dbo].[fnTransactionCommissionRecapJSON]
/*
 * Returns a json containing sales commissions applied by a transaction
 * Map to com.vgs.snapp.dataobject.commission.DOTransactionCommissionRecap
 */
(
  @TransactionId uniqueidentifier    -- Transaction ID
)
RETURNS nvarchar(max)
AS
BEGIN
  DECLARE @Result nvarchar(max);
  DECLARE @EntityType_Ticket int = 22;
  
  WITH CTE AS (
    select
      ACC.AccountId           as [AccountId],
      ACC.AccountCode         as [AccountCode],
      ACC.DisplayName         as [AccountName],
      COM.CommissionId        as [CommissionRuleId],
      COM.CommissionCode      as [CommissionRuleCode],
      COM.CommissionName      as [CommissionRuleName],
      TFG.TagId               as [FinanceGroupTagId],
      TFG.TagCode             as [FinanceGroupTagCode],
      TFG.TagName             as [FinanceGroupTagName],
      TRNCOM.ExternalPricing  as [ExternalPricing],
      PRD.ProductId           as [ProductId],
      PRD.ProductCode         as [ProductCode],
      PRD.ProductName         as [ProductName],
      TCK.TicketId            as [TicketId],
      dbo.fnDSSN(@EntityType_Ticket, TCK.LicenseId, TCK.StationSerial, TCK.EncodeFiscalDate, TCK.TicketSerial)
                              as [TicketCode],
      TRNCOM.FiscalDate       as [FiscalDate],
      TRNCOM.Quantity         as [CommissionQuantity],
      TRNCOM.CommissionAmount as [CommissionAmount],
      TRNCOM.CommissionTax    as [CommissionTax]
    from
      tbTransactionCommission TRNCOM left join
      tbAccount               ACC on ACC.AccountId=TRNCOM.AccountId left join
      tbCommission            COM on COM.CommissionId=TRNCOM.CommissionId left join
      tbTag                   TFG on TFG.TagId=TRNCOM.FinanceGroupTagId left join
      tbSaleItem              SI  on SI.SaleItemId=TRNCOM.SaleItemId left join
      tbProduct               PRD on PRD.ProductId=SI.ProductId left join
      tbTicket                TCK on TCK.TicketId=TRNCOM.TicketId
    where
      TRNCOM.TransactionId=@TransactionId
  )
  
  select @Result = (
    select
      Sum(CommissionQuantity) as [CommissionQuantity],
      Sum(CommissionAmount)   as [CommissionAmount],
      Sum(CommissionTax)      as [CommissionTax],
      (
        select
          AccountId,
          AccountCode,
          AccountName,
          CommissionRuleId,
          CommissionRuleCode,
          CommissionRuleName,
          ExternalPricing,
          Sum(CommissionQuantity) as [CommissionQuantity],
          Sum(CommissionAmount)   as [CommissionAmount],
          Sum(CommissionTax)      as [CommissionTax],
          (
            select
				      FinanceGroupTagId,
				      FinanceGroupTagCode,
				      FinanceGroupTagName,
              ProductId,
              ProductCode,
              ProductName,
              TicketId,
              TicketCode,
              FiscalDate,
              CommissionQuantity,
              CommissionAmount,
              CommissionTax
            from
              CTE CTE_I
            where
              CTE_I.AccountId=CTE_G.AccountId and
              CTE_I.CommissionRuleId=CTE_G.CommissionRuleId and
              CTE_I.ExternalPricing=CTE_G.ExternalPricing

            FOR JSON PATH
          ) as [ItemList]
        from
          CTE CTE_G
        group by
          AccountId,
          AccountCode,
          AccountName,
          CommissionRuleId,
          CommissionRuleCode,
          CommissionRuleName,
          ExternalPricing

        FOR JSON PATH
      ) as [GroupList]
    from
      CTE
      
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
  )
  
  RETURN @Result;

END