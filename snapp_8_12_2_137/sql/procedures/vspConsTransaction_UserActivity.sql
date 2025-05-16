PROCEDURE vspConsTransaction_UserActivity
/*
 * Populate tbUserActivity
 */
  @minSequence bigint, -- consolidate all tbTransaction where TransactionSequence>@minSequence
  @maxSequence bigint  -- consolidate all tbTransaction where TransactionSequence>@maxSequence
AS

/*
DECLARE @Table TABLE (
  FiscalDate           date,
  UserAccountId        uniqueidentifier,
  UserActivitySerial   int,
  WorkstationId        uniqueidentifier,
  FirstSerialDateTime  datetime,
  ProductCount         int,
  TransactionCount     int,
  TotalSelectionTime   int,
  TotalPaymentTime     int,
  TotalPrintTime       int
)

insert into @Table (
  FiscalDate,
  UserAccountId,
  UserActivitySerial,
  WorkstationId,
  FirstSerialDateTime,
  ProductCount,
  TransactionCount,
  TotalSelectionTime,
  TotalPaymentTime,
  TotalPrintTime
)
select
  X.SerialFiscalDate,
  X.UserAccountId,
  X.UserActivitySerial,
  X.WorkstationId,
  Min(X.SerialDateTime) as FirstSerialDateTime,
  Sum(X.PrintedCount) as [ProductCount],
  Count(distinct X.TransactionId) as [TransactionCount],
  Sum(X.DurationSelection) as [TotalSelectionTime],
  Sum(X.DurationPayment) as [TotalPaymentTime],
  Sum(X.DurationPrint) as [TotalPrintTime]
from
  (
    select
      TRN.SerialFiscalDate,
      TRN.SerialDateTime,
      TRN.UserAccountId,
      Max(UA.UserActivitySerial) as UserActivitySerial,
      TRN.WorkstationId,
      TRN.PrintedCount,
      TRN.TransactionId,
      TRN.DurationSelection,
      TRN.DurationPayment,
      TRN.DurationPrint
    from
      tbTransaction TRN WITH(INDEX(UQ_Transaction_TransactionSequence)) left join
      tbUserActivity UA WITH(INDEX(PK_UserActivity)) on 
        UA.FiscalDate=TRN.SerialFiscalDate and
        UA.UserAccountId=TRN.UserAccountId and
        UA.WorkstationId=TRN.WorkstationId and
        UA.LoginDateTime<=TRN.SerialDateTime and
       (UA.LogoutDateTime>=TRN.SerialDateTime or UA.LogoutDateTime is null)
    where
      TRN.TransactionSequence>=@minSequence and
      TRN.TransactionSequence<=@maxSequence and
      TRN.UserAccountId is not null
    group by
      TRN.SerialFiscalDate,
      TRN.SerialDateTime,
      TRN.UserAccountId,
      TRN.WorkstationId,
      TRN.PrintedCount,
      TRN.TransactionId,
      TRN.DurationSelection,
      TRN.DurationPayment,
      TRN.DurationPrint
  ) X
group by
  X.UserAccountId,
  X.SerialFiscalDate,
  X.WorkstationId,
  X.UserActivitySerial


merge into tbUserActivity as UA using @Table as CTE on (
  UA.FiscalDate         = CTE.FiscalDate and
  UA.UserAccountId      = CTE.UserAccountId and
  UA.UserActivitySerial = CTE.UserActivitySerial
)
when matched then
  update set 
    UA.ProductCount       = UA.ProductCount       + CTE.ProductCount,
    UA.TransactionCount   = UA.TransactionCount   + CTE.TransactionCount,
    UA.TotalSelectionTime = UA.TotalSelectionTime + CTE.TotalSelectionTime,
    UA.TotalPaymentTime   = UA.TotalPaymentTime   + CTE.TotalPaymentTime,
    UA.TotalPrintTime     = UA.TotalPrintTime     + CTE.TotalPrintTime
when not matched then
  insert (
    FiscalDate,
    UserAccountId,
    UserActivitySerial,
    WorkstationId,
    LoginDateTime,
    ProductCount,
    TransactionCount,
    TotalSelectionTime,
    TotalPaymentTime,
    TotalPrintTime
  )
  values (
    CTE.FiscalDate,
    CTE.UserAccountId,
    Coalesce((
      select Max(X.UserActivitySerial)
      from tbUserActivity X WITH(INDEX(PK_UserActivity))
      where 
        X.FiscalDate=CTE.FiscalDate and 
        X.UserAccountId=CTE.UserAccountId
    ), 0) + 1,
    CTE.WorkstationId,
    CTE.FirstSerialDateTime,
    CTE.ProductCount,
    CTE.TransactionCount,
    CTE.TotalSelectionTime,
    CTE.TotalPaymentTime,
    CTE.TotalPrintTime
  );
*/
  

/*
WITH CTE (
  FiscalDate,
  UserAccountId,
  WorkstationId,
  ProductCount,
  TransactionCount,
  TotalSelectionTime,
  TotalPaymentTime,
  TotalPrintTime
)
AS (
  select
    TRN.TransactionFiscalDate,
    TRN.UserAccountId,
    Min(TRN.WorkstationId),
    Sum(TRN.PrintedCount),
    Count(distinct TRN.TransactionId),
    Sum(TRN.DurationSelection),
    Sum(TRN.DurationPayment),
    Sum(TRN.DurationPrint)
  from
    tbTransaction TRN WITH(INDEX(UQ_Transaction_TransactionSequence))
  where
    TRN.TransactionSequence>=@minSequence and
    TRN.TransactionSequence<=@maxSequence and
    TRN.UserAccountId is not null
  group by
    TRN.UserAccountId,
    TRN.TransactionFiscalDate
)


merge into tbUserActivity as UA using CTE on (
  UA.FiscalDate         = CTE.FiscalDate and
  UA.UserAccountId      = CTE.UserAccountId and
  UA.UserActivitySerial = Coalesce((select Max(X.UserActivitySerial) from tbUserActivity X with(index(PK_UserActivity)) where X.FiscalDate=CTE.FiscalDate), 0) and
  UA.LogoutDateTime     is null
)
when matched then
  update set 
    UA.ProductCount       = UA.ProductCount       + CTE.ProductCount,
    UA.TransactionCount   = UA.TransactionCount   + CTE.TransactionCount,
    UA.TotalSelectionTime = UA.TotalSelectionTime + CTE.TotalSelectionTime,
    UA.TotalPaymentTime   = UA.TotalPaymentTime   + CTE.TotalPaymentTime,
    UA.TotalPrintTime     = UA.TotalPrintTime     + CTE.TotalPrintTime
when not matched then
  insert (
    FiscalDate,
    UserAccountId,
    UserActivitySerial,
    WorkstationId,
    LoginDateTime,
    ProductCount,
    TransactionCount,
    TotalSelectionTime,
    TotalPaymentTime,
    TotalPrintTime
  )
  values (
    CTE.FiscalDate,
    CTE.UserAccountId,
    Coalesce((select Max(X.UserActivitySerial) from tbUserActivity X where X.FiscalDate=CTE.FiscalDate), 0) + 1,
    CTE.WorkstationId,
    CTE.FiscalDate,
    CTE.ProductCount,
    CTE.TransactionCount,
    CTE.TotalSelectionTime,
    CTE.TotalPaymentTime,
    CTE.TotalPrintTime
  );
*/
