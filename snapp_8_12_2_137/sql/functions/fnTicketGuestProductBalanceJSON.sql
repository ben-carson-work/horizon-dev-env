FUNCTION [dbo].[fnTicketGuestProductBalanceJSON]
/*
 * Returns a json containing guest product balance for a given host ticket
 * Maps to com.vgs.snapp.dataobject.DOTicketGuestProductBalance
 */
(
  @TicketId uniqueidentifier    -- Host ticket identifier
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select
      PRD.ProductId,
      PRD.ProductCode,
      PRD.ProductName,
      TG.QtyTotal,
      TG.QtyEncoded
    from
      tbTicketGuest TG inner join
      tbProduct PRD on PRD.ProductId=TG.GuestProductId
    where
      TG.TicketId=@TicketId
    order by
      PRD.ProductName

    FOR JSON PATH
  ) 
END