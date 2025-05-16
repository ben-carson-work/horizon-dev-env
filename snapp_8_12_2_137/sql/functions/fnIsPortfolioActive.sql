FUNCTION [dbo].[fnIsPortfolioActive]
/*
 * Return true if the portfolio would has all its tickets expired for a specific date
 */
(
  @PortfolioId uniqueidentifier,  -- Unique identifier of the portfolio
  @FilterDate date        -- Date of when the check is performed
)
RETURNS bit
AS
BEGIN
  declare @result bit=0;  

  select top(1) @result = 
    (CASE 
       WHEN EXISTS (SELECT 1 FROM tbTicket PTCK WHERE PTCK.TicketMediaMatchId=@PortfolioId AND (PTCK.ValidDateTo IS NULL OR PTCK.ValidDateTo> @FilterDate)) THEN CAST(1 AS bit)
       ELSE CAST(0 AS bit)
     END)

  RETURN(@result);
END