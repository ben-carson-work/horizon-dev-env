FUNCTION [dbo].[fnIsPortfolioEmpty]
/*
 * Return 1 if portfolio does not contain any ticket or media
 */
(
  @PortfolioId uniqueidentifier	-- Portfolio internal ID
)
RETURNS bit
AS
BEGIN
  declare @result bit;  
  
  select @result = 
    (case
      when exists(select * from tbTicket where TicketMediaMatchId=@portfolioId) then 0
      when exists(select * from tbMedia where TicketMediaMatchId=@portfolioId) then 0 
      else 1
    end);
    
  RETURN(@result);
END