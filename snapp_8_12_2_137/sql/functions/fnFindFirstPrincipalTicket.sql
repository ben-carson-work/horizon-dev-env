FUNCTION [dbo].[fnFindFirstPrincipalTicket] 
/* 
 * Returns the first (active and flagged as "principal") TicketId of the given portfolio, sorted by PriorityOrder
 * */
(
  @portfolioId uniqueidentifier -- Portfolio ID
)
RETURNS uniqueidentifier
AS
BEGIN
  declare @result uniqueidentifier;
  
  select top 1
    @result = TCK.TicketId
  from
    tbTicket TCK with(index(IX_Ticket_PortfolioId)) inner join
    tbProductFlag PF on
      PF.ProductId=TCK.ProductId and
      PF.ProductFlag=57/*principal*/
  where
    TCK.TicketMediaMatchId=@portfolioId and
    TCK.TicketStatus<100
  order by
    TCK.PriorityOrder

  return @result;
END
