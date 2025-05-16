FUNCTION [dbo].[fnPaymentDataJSON]
/*
 * Returns a json containing all payment-date of a payment
 * Maps to com.vgs.snapp.dataobject.DOPaymentData
 */
(
  @paymentId uniqueidentifier    -- Payment ID
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select
      PD.ParamName,
      Coalesce(PD.ParamValue, PD.ParamValueLong) as ParamValue
    from
      tbPaymentData PD
    where
      PD.PaymentId=@paymentId

    FOR JSON PATH
  ) 
END
