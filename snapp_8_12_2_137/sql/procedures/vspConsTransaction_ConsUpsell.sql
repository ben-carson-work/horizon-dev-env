PROCEDURE vspConsTransaction_ConsUpsell
/*
 * Populate tbConsUpsell
 */
  @minSequence bigint, -- consolidate all tbTransaction where TransactionSequence>@minSequence
  @maxSequence bigint  -- consolidate all tbTransaction where TransactionSequence>@maxSequence
AS


DECLARE @Table TABLE
(
  FiscalDate      date,
  SourceProductId uniqueidentifier,
  TargetProductId uniqueidentifier,
  UpsellType      smallint,
  Quantity        smallint,
  UserAccountId   uniqueidentifier,
  WorkstationId   uniqueidentifier
)


insert into @Table (
  FiscalDate,      
  SourceProductId, 
  TargetProductId,
  UpsellType,        
  UserAccountId,   
  WorkstationId,     
  Quantity   
)
select
  TRN.SerialFiscalDate,
  UPS.SourceProductId,
  UPS.TargetProductId,
  UPS.UpsellType,
  TRN.UserAccountId,   
  TRN.WorkstationId,     
  Sum(UPS.Quantity)
from
  tbTransaction TRN inner join
  tbTransactionUpsell UPS on UPS.TransactionId=TRN.TransactionId
where
  TRN.TransactionSequence>=@MinSequence and
  TRN.TransactionSequence<=@MaxSequence
group by
  TRN.SerialFiscalDate,
  UPS.SourceProductId,
  UPS.TargetProductId,
  UPS.UpsellType,
  TRN.UserAccountId,   
  TRN.WorkstationId     

  

/**** MERGE ****/
merge into tbConsUpsell as CU using @Table as CTE on (
  CU.FiscalDate      = CTE.FiscalDate      and      
  CU.SourceProductId = CTE.SourceProductId and 
  CU.TargetProductId = CTE.TargetProductId and
  CU.UpsellType      = CTE.UpsellType      and
  CU.UserAccountId   = CTE.UserAccountId   and
  CU.WorkstationId   = CTE.WorkstationId     
)
when matched then
  update set 
    CU.Quantity = CU.Quantity + CTE.Quantity
when not matched then
  insert (
    ConsUpsellId,
    FiscalDate,      
    SourceProductId, 
    TargetProductId,
    UpsellType,        
    UserAccountId,   
    WorkstationId,     
    Quantity   
  )
  values (
    NewID(),
    CTE.FiscalDate,      
    CTE.SourceProductId, 
    CTE.TargetProductId,
    CTE.UpsellType,        
    CTE.UserAccountId,   
    CTE.WorkstationId,     
    CTE.Quantity   
  );
