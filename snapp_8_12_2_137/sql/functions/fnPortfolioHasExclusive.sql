FUNCTION [dbo].[fnPortfolioHasExclusive] 
/* 
 * Returns 1 if given "portfolioId" contains any ticket or media flagged as "exclusive use". Else return 0;
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
        when (
            select top 1 MediaId 
            from tbMedia 
            where
              TicketMediaMatchId=@portfolioId and 
              ExclusiveUse=1
          ) is not null then 1 
        
        when (
            select top 1 TicketId 
            from 
              tbTicket TCK inner join
              tbProductFlag PF on
                PF.ProductId=TCK.ProductId and
                PF.ProductFlag=9--MediaExclusiveUse
            where
              TCK.TicketMediaMatchId=@portfolioId
          ) is not null then 1 
        
        else 0
      end)
  
  return @result;
END
