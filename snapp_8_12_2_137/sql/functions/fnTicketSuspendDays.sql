FUNCTION [dbo].[fnTicketSuspendDays]
/*
 * Return the numebr of days in which the ticket has been suspended to increment expiration date
 */
(
	@TicketId uniqueidentifier,	-- Unique identifier of the ticket
	@CheckDate date				-- Date of when the check is performed
)
RETURNS int
AS
BEGIN
  declare @result int;  

  select @result=Sum(DATEDIFF(
      day, 
      case 
	    when X.SuspendDateFrom>X.TicketDate then X.SuspendDateFrom 
	    else X.TicketDate 
  	  end, 
	  X.SuspendDateTo) + 1)
  from	
    (select
	  PSUS.SuspendDateFrom as SuspendDateFrom,
	  PSUS.SuspendDateTo as SuspendDateTo,
	  case 
		when TCK.EncodeFiscalDate<TCK.ValidDateFrom then TCK.ValidDateFrom
		else TCK.EncodeFiscalDate
	  end as TicketDate
	from
	  tbTicket TCK left join
	  tbProductSuspend PSUS on 
		PSUS.ProductId=TCK.ProductId and
		PSUS.SuspendDateTo>=TCK.EncodeFiscalDate and
		((TCK.ValidDateFrom is null) or (PSUS.SuspendDateTo>=TCK.ValidDateFrom)) and
		PSUS.SuspendDateTo<@CheckDate
	where
	  TCK.TicketId=@TicketId
    ) X

  RETURN(@result);
END