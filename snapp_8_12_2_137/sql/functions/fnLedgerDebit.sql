FUNCTION [dbo].[fnLedgerDebit] 
/* 
 * Returns absolute debit ledger amount
 * */
(
  @amount money -- Ledger amount
)
RETURNS money
AS
BEGIN
  declare @result money;
  select @result = (case 
                      when @amount<0 then -@amount
                      else 0
                    end)
  return @result;
END
