PROCEDURE vspConsTransaction_ConsPayment
/*
 * Populate tbConsPayment
 */
  @minSequence bigint, -- consolidate all tbTransaction where TransactionSequence>@minSequence
  @maxSequence bigint  -- consolidate all tbTransaction where TransactionSequence>@maxSequence
AS


DECLARE @Table TABLE
(
  FiscalDate      date,
  LocationId      uniqueidentifier,
  OpAreaId        uniqueidentifier,
  PaymentMethodId uniqueidentifier,
  Amount          money
)


insert into @Table (
  FiscalDate,
  LocationId,
  OpAreaId,
  PaymentMethodId,
  Amount
)
select
  TRN.TransactionFiscalDate,
  OPA.ParentAccountId,
  TRN.OpAreaId,
  PAY.PluginId,
  Sum(PAY.PaymentAmount)
from
  tbTransaction TRN inner join
  tbPayment PAY on PAY.TransactionId=TRN.TransactionId and PAY.PaymentStatus=2/*approved*/ inner join
  tbAccount OPA on OPA.AccountId=TRN.OpAreaId
where
  TRN.TransactionSequence>=@MinSequence and
  TRN.TransactionSequence<=@MaxSequence
group by
  TRN.TransactionFiscalDate,
  OPA.ParentAccountId,
  TRN.OpAreaId,
  PAY.PluginId

  

/**** MERGE ****/
merge into tbConsPayment as CP using @Table as CTE on (
  CP.FiscalDate      = CTE.FiscalDate      and
  CP.LocationId      = CTE.LocationId      and
  CP.OpAreaId        = CTE.OpAreaId        and
  CP.PaymentMethodId = CTE.PaymentMethodId
)
when matched then
  update set 
    CP.Amount   = CP.Amount   + CTE.Amount
when not matched then
  insert (
    ConsPaymentId,
	  FiscalDate,
	  LocationId,
	  OpAreaId,
	  PaymentMethodId,
	  Amount
  )
  values (
    NewID(),
    CTE.FiscalDate,
    CTE.LocationId,
    CTE.OpAreaId,
    CTE.PaymentMethodId,
    CTE.Amount
  );
