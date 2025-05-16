PROCEDURE vspConsLedger
/*
 * 1) Populate tbLedgerDateTotal table.
 * 
 * Returns as resultset of 1 row with 2 fields:
 *   - MaxSequence bigint   // Max LegderSequence consolidated
 *   - Count int            // Total number of consolidated ledgers
 */
  @maxItems int     -- max records to be processed
AS

declare @dbInfoParamName varchar(50) = 'LedgerLastConsSequence';
declare @sequence bigint; -- consolidate all tbLedger where LedgerSequence>@sequence
declare @minSequence bigint;
declare @maxSequence bigint;
declare @count int;
declare @maxWriteDateTime datetime = DateAdd(minute, -1, GetDate())

select @sequence = Coalesce(CAST (dbo.[fnReadDBParam](@dbInfoParamName) AS bigint), 0);

select 
  @minSequence=@sequence+1,
  @maxSequence=Max(LedgerSequence),
  @count=Count(*)
from (
  select top (@maxItems) LedgerSequence
  from tbLedger WITH(INDEX(UQ_Ledger_LedgerSequence))
  where LedgerSequence>@sequence and WriteDateTime<@maxWriteDateTime
  order by LedgerSequence
) X

IF (@maxSequence IS NOT NULL)
BEGIN
  WITH CTE AS (
    select
      L.LedgerFiscalDate,
      L.LedgerAccountId, 
      L.AccountId,
      Sum(L.LedgerAmount) as Amount
    from
      tbLedger L WITH(FORCESEEK, INDEX(UQ_Ledger_LedgerSequence))
    where
      L.LedgerSequence>=@minSequence and
      L.LedgerSequence<=@maxSequence
    group by
      L.LedgerFiscalDate,
      L.LedgerAccountId, 
      L.AccountId
  )
  
  MERGE INTO tbLedgerDateTotal AS LDT using CTE on (
    LDT.LedgerFiscalDate = CTE.LedgerFiscalDate and
    LDT.LedgerAccountId  = CTE.LedgerAccountId and
    LDT.AccountId        = CTE.AccountId
  )
  WHEN MATCHED THEN
    update set 
      LDT.LedgerTotalBalance = LDT.LedgerTotalBalance + CTE.Amount
  WHEN NOT MATCHED THEN
    insert (
      LedgerFiscalDate,
      LedgerAccountId,
      AccountId,
      LedgerTotalBalance
    )
    values (
      LedgerFiscalDate,
      LedgerAccountId,
      AccountId,
      Amount
    );

  -- save DBParam
  exec vspSaveDBParam @dbInfoParamName, @maxSequence

END;


/**** RESULT ****/
select
  @maxSequence as [MaxSequence],
  @count as [Count]
