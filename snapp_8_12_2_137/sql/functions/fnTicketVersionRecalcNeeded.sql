FUNCTION [dbo].[fnTicketVersionRecalcNeeded]
/*
 * Return true if ticket needs entitlement replacement or date (expiration and amortization) recalc after a suspend period
 */
(
  @TicketId uniqueidentifier, -- Unique identifier of the ticket
  @CheckDate date             -- Date of when the check is performed
)

RETURNS bit
AS
BEGIN
  declare @result bit;  

  select @result=(case 
          when X.TicketStatus>100 then 0
					when ((X.EntitlementReplaceVersion is not null) AND (X.EntitlementVersion is null OR (X.EntitlementVersion < X.EntitlementReplaceVersion))) OR
						 ((X.ProductSuspendVersion is not null) AND (X.TicketSuspendVersion is null OR (X.TicketSuspendVersion <> X.ProductSuspendVersion))) then 1
					else 0
				  end)
  from 
    (select 
    TCK.TicketStatus,
		TCK.ProductSuspendSerial as TicketSuspendVersion,
		TCK.EntitlementVersion as EntitlementVersion,
	    dbo.fnEntitlementReplaceVersion(TCK.ProductId, TCK.EncodeFiscalDate) as EntitlementReplaceVersion,
	    dbo.fnProductSuspendVersion(TCK.TicketId, @CheckDate) as ProductSuspendVersion
	from 
	    tbTicket TCK 
	where
	    TCK.TicketId=@TicketId
	) X

  RETURN(@result);
END

