FUNCTION [dbo].[fnIsValidTicketUsage]
/*
 * Return 1 if ticket usage is "valid" and should be counted in statistics
 */
(
  @ValidateResult int, -- tbTicketUsage.ValidateResult
  @Invalidated bit,    -- tbTicketUsage.Invalidated
  @Simulated bit       -- tbTicketUsage.SimulatedRedemption
)
RETURNS bit
AS
BEGIN
  declare @result bit;
  set @result=0;

  if (@ValidateResult < 100) and (Coalesce(@Invalidated, 0) = 0) and (Coalesce(@Simulated, 0) = 0)
    set @result=1;

  RETURN(@result);
END

