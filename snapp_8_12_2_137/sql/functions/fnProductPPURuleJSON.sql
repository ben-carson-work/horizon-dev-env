FUNCTION [dbo].[fnProductPPURuleJSON]
/*
 * Returns product's variable preset amounts JSON mapped to DOProductPPURule
 */
(
  @ProductId uniqueidentifier    -- Product ID
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
  
    select
      EVT.EventId,
      EVT.EventCode,
      EVT.EventName,
      MPT.MembershipPointId,
      MPT.MembershipPointCode,
      MPT.MembershipPointName,
      PPU.MembershipPointValue,
      PPU.ValidDateFrom,
      PPU.ValidDateTo,
      PPU.ValidTimeFrom,
      PPU.ValidTimeTo
    from
      tbPPURuleLink      LNK    inner join
      tbPPURule          PPU    on PPU.PPURuleId=LNK.PPURuleId inner join
      tbPPURuleLink      LNKEVT on LNKEVT.PPURuleId=PPU.PPURuleId and LNKEVT.EntityType=5/*event*/ inner join
      tbEvent            EVT    on EVT.EventId=LNKEVT.EntityId inner join
      tbMembershipPoint  MPT    on MPT.MembershipPointId=PPU.MembershipPointId
    where
      LNK.EntityId=@ProductId
    order by
      EVT.EventName,
      MPT.MembershipPointName,
      PPU.ValidDateFrom,
      PPU.ValidDateTo
      
    FOR JSON PATH
  ) 
END
