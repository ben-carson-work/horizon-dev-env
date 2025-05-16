FUNCTION [dbo].[fnPortfolioBalanceRawJSON]
/*
 * Returns a list of "Portfolio slot balance" of a portfolio - JSON mapped to DOPortfolioBalanceRefItem except field "BalanceAmount and "IsExpired"
 */
(
  @PortfolioId uniqueidentifier   -- Portfolio ID
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select 
      PSB.PortfolioId as MainPortfolioId,
      coalesce(TCK.TicketMediaMatchId, PSB.PortfolioId) as PortfolioId,
      PSB.MembershipPointId,
      REWARD.MembershipPointCode,
      REWARD.MembershipPointName,
      REWARD.RoundDecimals,
      REWARD.ValidityType,
      REWARD.ExpirationType,
      REWARD.ExpirationManualChange,
      coalesce(PSB.ExpireDate, PS.ExpireDate) as ExpireDate,
      PSB.PortfolioSlotBalanceSerial,
      PSB.TicketId as TicketId,
      dbo.fnEntityDesc(22, PSB.TicketId) as TicketCode,
      TCK.BindWalletRewardToProduct as BindedToProduct,  
      PSB.Balance as Balance
    from
      tbPortfolioSlotBalance PSB inner join
      tbPortfolioSlot PS on PS.PortfolioId=PSB.PortfolioId and PS.MembershipPointId=PSB.MembershipPointId inner join
      tbMembershipPoint REWARD on REWARD.MembershipPointId=PSB.MembershipPointId left join
      tbTicket TCK WITH(FORCESEEK, INDEX(PK_Ticket)) on TCK.TicketId=PSB.TicketId
    where
      PSB.PortfolioId=@PortfolioId
    order by  
      PSB.TicketId,
      (case when REWARD.MembershipPointCode='#WALLET' then 0 else 1 end),
      PSB.Balance
      
    FOR JSON PATH
  ) 
END
