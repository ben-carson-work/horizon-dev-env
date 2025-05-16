PROCEDURE vspConsTransaction
/*
 * Populate tbConsSale, tbConsPayment, tbConsAccountSale table.
 * Returns as resultset of 1 row with 2 fields:
 *   - Count int            // Total number of consolidated usages
 */
  @maxItems int     -- max records to be processed
AS

declare @sequence bigint; 
declare @minSequence bigint;
declare @maxSequence bigint;
declare @count int;
declare @dbInfoParamName varchar(50) = 'TransactionLastConsSequence';

select @sequence = Coalesce(CAST (dbo.[fnReadDBParam](@dbInfoParamName) AS bigint), 0);

select 
  @minSequence=@sequence+1,
  @maxSequence=Max(TransactionSequence),
  @count=Count(*)
from (
  select top (@maxItems) TransactionSequence
  from tbTransaction
  where TransactionSequence>@sequence
  order by TransactionSequence
) X


IF (@minSequence <= @maxSequence)
BEGIN
	exec vspConsTransaction_ConsSale              @minSequence, @maxSequence
	exec vspConsTransaction_ConsAccountSale       @minSequence, @maxSequence
	exec vspConsTransaction_ConsPayment           @minSequence, @maxSequence
  exec vspConsTransaction_BoxCashContentAmount  @minSequence, @maxSequence
  exec vspConsTransaction_ConsUpsell            @minSequence, @maxSequence
	--exec vspConsTransaction_UserActivity          @minSequence, @maxSequence
END;

if (@maxSequence IS NOT NULL)
BEGIN
	exec vspSaveDBParam @dbInfoParamName, @maxSequence
END;
  
/**** RESULT ****/
select
  @maxSequence as [MaxSequence],
  @count as [Count]
