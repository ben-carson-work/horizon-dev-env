FUNCTION [dbo].[fnTicketUpgradePriceChainJSON]
/*
 * Return the all the upgrade-chain tickets of the given ticketId (mapped to com.vgs.snapp.dataobject.DOTicket.DOTicketUpgradePrice)
 */
(
  @TicketId   uniqueidentifier -- Ticket ID
)
RETURNS nvarchar(max)
AS
BEGIN
  DECLARE @Result nvarchar(max) = NULL;
  DECLARE @PackagePriceOnItems int = 2001;

	RETURN (
    select distinct 
      DSTTCK.TicketId,
      DSTTRN.SaleId,
      (
        Coalesce((CASE
          WHEN DST_PF.ProductId IS NULL THEN DSTTCK.UnitAmount * DSTTCK.GroupQuantity
          ELSE (
            select Sum(PI.UnitAmount * PI.GroupQuantity)
            from tbTicket PI
            where PI.PackageTicketId=DSTTCK.TicketId
          ) END), 0)
          
          -
          
        Coalesce((CASE
          WHEN SRC_PF.ProductId IS NULL THEN SRCTCK.UnitAmount * SRCTCK.GroupQuantity
          ELSE (
            select Sum(PI.UnitAmount * PI.GroupQuantity)
            from tbTicket PI
            where PI.PackageTicketId=SRCTCK.TicketId
          ) END), 0)
          
      ) as [UpgradePrice]
    from
      (
		    select distinct 
		      TR.SourceTicketId as TicketId
		    from
		      tbTicketUpgrade TU inner join
		      tbTicketUpgrade TR on TR.RootTicketId=TU.RootTicketId
		    where
		      TU.TicketId=@TicketId
        
        union
        
        select @TicketId
      ) X inner join
      tbTicket        DSTTCK on DSTTCK.TicketId=X.TicketId inner join
      tbTransaction   DSTTRN on DSTTRN.TransactionId=DSTTCK.TransactionId left join
      tbTicketUpgrade TU on TU.TicketId=DSTTCK.TicketId left join
      tbTicket        SRCTCK on SRCTCK.TicketId=TU.SourceTicketId left join
      tbProductFlag   SRC_PF on SRC_PF.ProductId=SRCTCK.ProductId and SRC_PF.ProductFlag=@PackagePriceOnItems left join
      tbProductFlag   DST_PF on DST_PF.ProductId=DSTTCK.ProductId and DST_PF.ProductFlag=@PackagePriceOnItems
	
	  FOR JSON PATH
	)

END
