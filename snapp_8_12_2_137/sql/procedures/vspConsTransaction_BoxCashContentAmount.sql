PROCEDURE vspConsTransaction_BoxCashContentAmount
/*
 * Populate tbBox for cash payments
 */
  @minSequence bigint, -- consolidate all tbTransaction where TransactionSequence>@minSequence
  @maxSequence bigint  -- consolidate all tbTransaction where TransactionSequence>@maxSequence
AS


update tbBox
set
  CashContentAmount = (CashContentAmount + X_PaymentAmount)
from (
  select
    TRN.BoxId as X_BoxId,
    Sum(Coalesce(PCUR.CurrencyAmount, PAY.PaymentAmount)) as X_PaymentAmount
  from
    tbTransaction TRN inner join
    tbBox BOX on BOX.BoxId=TRN.BoxId inner join
    tbPayment PAY on
      PAY.TransactionId=TRN.TransactionId and
      PAY.PaymentStatus=2/*approved*/ inner join
    tbPluginPaymentMethod PPM on
      PPM.PluginId=PAY.PluginId and
      PPM.CashPayment=1 left join
    tbPaymentCurrency PCUR on PCUR.PaymentId=PAY.PaymentId
  where
    TRN.TransactionSequence>=@minSequence and
    TRN.TransactionSequence<=@maxSequence
  group by
    TRN.BoxId
  ) X
where
  BoxId=X_BoxId
