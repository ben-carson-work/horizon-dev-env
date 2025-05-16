FUNCTION [dbo].[fnTicketRevenueJSON]
/*
 * Returns a json containing ticket revenue config stored by gate category
 * Maps to com.vgs.snapp.web.queue.ledger.BLBO_LedgerWorkerBase.GateCategoryBean
 */
(
  @ticketId uniqueidentifier    -- Ticket identifier
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select 
      GateCategoryId as gateCategoryId,
      ClearingLimit as gateCategoryClearingLimit,
      ClearingAllocated as gateCategoryClearingUsed
    from
      tbTicketRevenue
    where
      TicketId=@ticketId
    order by
      ClearingLimit desc
    FOR JSON PATH
  ) 
END