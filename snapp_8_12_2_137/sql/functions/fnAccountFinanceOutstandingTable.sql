FUNCTION [dbo].[fnAccountFinanceOutstandingTable]
/*
 * Returns count and total amount of outstanding credits 
 */
(
  @AccountId uniqueidentifier,    -- Account identifier
  @FiscalDate date                -- Current fiscal date
)
RETURNS @result TABLE (
  OutstandingDebt bit,            -- 1 = client has outstanding debts
  OutstandingCount int,           -- total outstanding credit count
  OutstandingAmount money         -- total outstanding credit amount
)
AS
BEGIN
  insert into @result (OutstandingDebt, OutstandingCount, OutstandingAmount)
  select 
    Cast((case when Count(*)=0 then 0 else 1 end) as bit) as OutstandingDebt,
    Count(*) as OutstantingCount,
    Sum(P.PaymentAmount) as OutstantingAmount
  from 
    tbAccountFinance AF inner join
    tbPaymentCredit PC on PC.AccountId=AF.AccountId inner join
    tbPayment P on P.PaymentId=PC.PaymentId
  where
    AF.AccountId=@AccountId and
    DateAdd(day, AF.GracePeriodDays, PC.DueDate)<@FiscalDate and
    PC.CreditStatus in (1/*opened*/, 2/*invoiced*/)
  
  return;
END
