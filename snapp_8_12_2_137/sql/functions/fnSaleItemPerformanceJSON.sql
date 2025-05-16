FUNCTION [dbo].[fnSaleItemPerformanceJSON]
/*
 * Returns sale item stat items JSON mapped to com.vgs.snapp.dataobjectDOSaleItemPerformanceRef
 */
(
  @SaleItemId uniqueidentifier  -- Sale item ID
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select distinct
      PRF.PerformanceId,
      PRF.DateTimeFrom,
      PRF.DateTimeTo,
      PRF.DBDateTimeFrom, -- Not currently in the data object, but needs to be selected because of "distinct" clause
      EVT.EventId,
      EVT.EventCode,
      EVT.EventName,
      LOC.AccountId    as [LocationId],
      LOC.AccountCode  as [LocationCode],
      LOC.DisplayName  as [LocationName]
    from
      tbSaleItem             SI  inner join
      tbPerformanceSetDetail PSD on PSD.PerformanceSetId=SI.PerformanceSetId inner join
      tbPerformance          PRF on PRF.PerformanceId=PSD.PerformanceId inner join
      tbEvent                EVT on EVT.EventId=PRF.EventId left join
      tbAccount              LOC on LOC.AccountId=PRF.LocationAccountId
    where
      SI.SaleItemId=@SaleItemId
    order by
      PRF.DBDateTimeFrom
      
    FOR JSON PATH
  ) 
END
