FUNCTION [dbo].[fnProductSuspendVersion]
/*
 * Return serial of the last suspension period for a particular ticket, used later to understand if ticket needs recalc of expiration and amortization
 */
(
	@TicketId uniqueidentifier,	-- Unique identifier of the ticket
	@CheckDate date				-- Date of when the check is performed
)
RETURNS int
AS
BEGIN
  declare @result int;  

  select top(1) @result=PSO.ProductSuspendSerial
  from
    tbTicket TCK left join
    tbProductSuspend PSO on 
      PSO.ProductSuspendId in (
	    select top 1 
		  PSX.ProductSuspendId
		from
		  tbProductSuspend PSX
		where
		  PSX.ProductId=TCK.ProductId and
    	  PSX.SuspendDateTo is not null and
    	  PSX.SuspendDateTo<@CheckDate and
    	  PSX.SuspendDateTo>=TCK.EncodeFiscalDate
		order by
		  PSX.SuspendDateFrom desc
		)
  where
    TCK.TicketId=@TicketId

  RETURN(@result);
END