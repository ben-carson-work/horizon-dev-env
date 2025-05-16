FUNCTION [dbo].[fnSaleCommissionRecapJSON]
/*
 * Returns a json containing the list of transactions which applied sales commissions
 * Map to com.vgs.snapp.dataobject.commission.DOSaleCommissionRecap
 */
(
  @SaleId uniqueidentifier    -- Sale ID
)
RETURNS nvarchar(max)
AS
BEGIN
  DECLARE @Result nvarchar(max);
  DECLARE @EntityType_Transaction int = 20;
  
  WITH CTE AS (
    select
      TRN.TransactionId,
      dbo.fnDSSN(@EntityType_Transaction, TRN.LicenseId, TRN.StationSerial, TRN.SerialFiscalDate, TRN.TransactionSerial) as [TransactionCode],
      TRN.SerialDateTime as TransactionSerialDateTime,
      ACC.AccountId,
      ACC.AccountCode,
      ACC.DisplayName as AccountName,
      Sum(TRNCOM.Quantity) as CommissionQuantity,
      Sum(TRNCOM.CommissionAmount) as CommissionAmount,
      Sum(TRNCOM.CommissionTax) as CommissionTax
    from
      tbTransaction TRN inner join
      tbTransactionCommission TRNCOM on TRNCOM.TransactionId=TRN.TransactionId left join
      tbAccount ACC on ACC.AccountId=TRNCOM.AccountId
    where
      TRN.SaleId=@SaleId
    group by
      TRN.TransactionId,
      TRN.LicenseId,
      TRN.StationSerial,
      TRN.SerialFiscalDate,
      TRN.TransactionSerial,
      TRN.SerialDateTime,
      ACC.AccountId, 
      ACC.AccountCode, 
      ACC.DisplayName
  )
  
  select @Result = (
    select
      Sum(CommissionQuantity) as CommissionQuantity,
      Sum(CommissionAmount) as CommissionAmount,
      Sum(CommissionTax) as CommissionTax,
      (
        select
          TransactionId,
          TransactionCode,
          TransactionSerialDateTime,
          AccountId,
          AccountCode,
          AccountName,
          CommissionQuantity,
          CommissionAmount,
          CommissionTax
        from
          CTE

    FOR JSON PATH
      ) as TransactionList
    from
      CTE
      
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
  )
  
  RETURN @Result;

END