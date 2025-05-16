FUNCTION [dbo].[fnPortfolioHasPrincipal] 
/* 
 * Returns 1 if given "portfolioId" contains any active ticket flagged as "principal". Else return 0;
 * */
(
  @portfolioId uniqueidentifier -- Portfolio ID
)
RETURNS bit
AS
BEGIN
  declare @ticketId uniqueidentifier;
  declare @result bit;
  
  select @result = 
      (case
        when dbo.fnFindFirstPrincipalTicket(@portfolioId) is null then 0
        else 1
      end)
  
  return @result;
END
