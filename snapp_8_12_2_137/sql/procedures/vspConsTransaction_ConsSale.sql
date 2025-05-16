PROCEDURE vspConsTransaction_ConsSale
/*
 * Populate tbConsSale 
 */
  @minSequence bigint, -- consolidate all tbTransaction where TransactionSequence>@minSequence
  @maxSequence bigint  -- consolidate all tbTransaction where TransactionSequence>@maxSequence
AS




DECLARE @Table TABLE
(
  ConsSaleType int,
  FiscalDate   date,
  TimeSlot     datetime,
  LocationId   uniqueidentifier,
  OpAreaId     uniqueidentifier,
  ProductId    uniqueidentifier,
  OptionSetId  uniqueidentifier,
  Amount       money,
  Quantity     int,
  EventId      uniqueidentifier
)


/**** PaidByDate ****/
insert into @Table (
  ConsSaleType,
  FiscalDate,
  TimeSlot,
  LocationId,
  OpAreaId,
  ProductId,
  OptionSetId,
  Amount,
  Quantity,
  EventId
)
select
  1,
  TRN.SerialFiscalDate,
  null,
  OPA.ParentAccountId,
  TRN.OpAreaId,
  SI.ProductId,
  SI.OptionSetId,
  Sum(SI.StatAmount*TI.QtyPaid),
  Sum(TI.QtyPaid),
  PF.EventId
from
  tbTransaction TRN inner join
  tbTransactionItem TI on TI.TransactionId=TRN.TransactionId inner join
  tbAccount OPA on OPA.AccountId=TRN.OpAreaId inner join
  tbSaleItem SI on SI.SaleItemId=TI.SaleItemId left outer join
  tbPerformance PF on PF.PerformanceId=SI.PerformanceId
where
  TRN.TransactionSequence>=@MinSequence and
  TRN.TransactionSequence<=@MaxSequence
group by
  TRN.SerialFiscalDate,
  OPA.ParentAccountId,
  TRN.OpAreaId,
  SI.ProductId,
  SI.OptionSetId,
  PF.EventId;

              
    
/**** PaidByTimeslot ****/
insert into @Table (
  ConsSaleType,
  FiscalDate,
  TimeSlot,
  LocationId,
  OpAreaId,
  ProductId,
  OptionSetId,
  Amount,
  Quantity,
  EventId
)
select
  2,
  TRN.SerialFiscalDate,
  dbo.fnTimeSlot15(SerialLocalDateTime),
  OPA.ParentAccountId,
  TRN.OpAreaId,
  null,
  null,
  Sum(TI.QtyPaid * SI.StatAmount),
  Sum(TI.QtyPaid),
  null
from
  tbTransaction TRN inner join
  tbTransactionItem TI on TI.TransactionId=TRN.TransactionId inner join
  tbAccount OPA on OPA.AccountId=TRN.OpAreaId inner join
  tbSaleItem SI on SI.SaleItemId=TI.SaleItemId left outer join
  tbPerformance PF on PF.PerformanceId=SI.PerformanceId
where
  TRN.TransactionSequence>=@MinSequence and
  TRN.TransactionSequence<=@MaxSequence
group by
  TRN.SerialFiscalDate,
  dbo.fnTimeSlot15(SerialLocalDateTime),
  OPA.ParentAccountId,
  TRN.OpAreaId;

  

/**** MERGE ****/
merge into tbConsSale as CS using @Table as CTE on (
  CS.ConsSaleType = CTE.ConsSaleType and
  CS.FiscalDate   = CTE.FiscalDate   and
  (CS.TimeSlot    = CTE.TimeSlot    or (CS.TimeSlot is null    and CTE.TimeSlot is null))     and 
  (CS.LocationId  = CTE.LocationId  or (CS.LocationId is null  and CTE.LocationId is null))   and 
  (CS.OpAreaId    = CTE.OpAreaId    or (CS.OpAreaId is null    and CTE.OpAreaId is null))     and 
  (CS.ProductId   = CTE.ProductId   or (CS.ProductId is null   and CTE.ProductId is null))    and 
  (CS.OptionSetId = CTE.OptionSetId or (CS.OptionSetId is null and CTE.OptionSetId is null))  and 
  (CS.EventId     = CTE.EventId     or (CS.EventId is null     and CTE.EventId is null))          
)
when matched then
  update set 
    CS.Amount   = CS.Amount   + CTE.Amount,
    CS.Quantity = CS.Quantity + CTE.Quantity
when not matched then
  insert (
    ConsSaleId,
    ConsSaleType,
	  FiscalDate,
	  TimeSlot,
	  LocationId,
	  OpAreaId,
	  ProductId,
	  OptionSetId,
	  Amount,
	  Quantity,
	  EventId
  )
  values (
    NewID(),
    CTE.ConsSaleType,
    CTE.FiscalDate,
    CTE.TimeSlot,
    CTE.LocationId,
    CTE.OpAreaId,
    CTE.ProductId,
    CTE.OptionSetId,
    CTE.Amount,
    CTE.Quantity,
    CTE.EventId
  );
