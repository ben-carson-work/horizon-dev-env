FUNCTION [dbo].[fnTicketBiometricJSON]
/*
 * Returns a json containing all biometric templates assigned to a ticket
 * Maps to com.vgs.snapp.dataobject.DOTicket.DOTicketBiometric
 */
(
  @ticketId uniqueidentifier    -- Ticket identifier
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select 
      BIO.BiometricType,
      BIO.EnrollmentDateTime,
      BIO.ExpirationDate
    from 
      tbBiometric BIO
    where
      BIO.EntityId=@ticketId
	  order by
	    BIO.EnrollmentDateTime
    FOR JSON PATH
  ) 
END
