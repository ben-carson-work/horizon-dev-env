FUNCTION [dbo].[fnLedgerClearingJSON]
/*
 * Returns a json containing all "ledger clearing" for a given ticket
 * Maps to com.vgs.snapp.dataobject.DOLedgerClearing
 */
(
  @TicketId uniqueidentifier    -- Ticket identifier
)
RETURNS nvarchar(max)
AS
BEGIN
	
  RETURN (
	  select
		  LC.GateCategoryId,
		  GC.GateCategoryCode,
		  GC.GateCategoryName,
		  LC.LedgerTriggerType,
		  LC.LedgerTriggerEntityType,
		  LC.LedgerTriggerEntityId,
		  LC.LedgerFiscalDate,
		  LC.LedgerDateTime,
		  LC.DeltaAmount,
		  LC.ClearingAllocated,
		  LC.InheritedEntry
	  from
	    tbLedgerClearing LC WITH(INDEX(IX_LedgerClearing_TicketId)) inner join
	    tbGateCategory GC (FORCESEEK) on GC.GateCategoryId=LC.GateCategoryId
	  where
	    LC.TicketId=@TicketId
	  order by
	    LC.LedgerDateTime DESC
	    
    FOR JSON PATH
  )
  
END
