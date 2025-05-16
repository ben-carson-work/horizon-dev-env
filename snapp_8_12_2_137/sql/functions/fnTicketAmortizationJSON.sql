FUNCTION [dbo].[fnTicketAmortizationJSON]
/*
 * Returns a json containing all biometric templates assigned to a ticket
 * Maps to com.vgs.snapp.dataobject.ticket.DOTicketAmortizationRef
 */
(
  @ticketId uniqueidentifier    -- Ticket identifier
)
RETURNS nvarchar(max)
AS
BEGIN
  DECLARE @CommonStatus_Draft     int = 10;
  DECLARE @CommonStatus_Completed int = 50;
	
  return (
    select 
      TA.TicketAmortizationId,
      TA.TicketId,
      TA.AmortizationAmount,
      TA.AmortizationDate,
      TA.LedgerDateTime,
      TA.TicketAmortizationStatus,
      TA.GateCategoryId,
      GC.GateCategoryCode,
      GC.GateCategoryName,
      (CASE WHEN TA.LedgerDateTime IS NULL THEN @CommonStatus_Draft ELSE @CommonStatus_Completed END) as [CommonStatus]
    from 
      tbTicketAmortization TA left join
      tbGateCategory GC on GC.GateCategoryId=TA.GateCategoryId
    where
      TA.TicketId=@ticketId
	  order by
	    TA.AmortizationDate,
	    GC.GateCategoryName
    FOR JSON PATH
  ) 
END
