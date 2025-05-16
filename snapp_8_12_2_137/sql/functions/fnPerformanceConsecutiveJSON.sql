FUNCTION [dbo].[fnPerformanceConsecutiveJSON]
/*
 * Returns a JSON (mapped to com.vgs.snapp.dataobject.DOPerformanceConsecutive) with performance's consecutive performances
 */
(
  @eventId        uniqueidentifier, -- Performance's event
  @dbDateTimeFrom datetime,         -- Performance's DBDateTimeFrom
  @quantity       int               -- Requested quantity of consecutive performances (including input performance)
)
RETURNS nvarchar(max)
AS
BEGIN
  RETURN (
		select top(@quantity)
		  PRF.PerformanceId, 
		  PRF.DateTimeFrom, 
		  EVT.EventId, 
		  EVT.EventCode, 
		  EVT.EventName
	  from
	    tbPerformance    PRF WITH(INDEX(IX_Performance_Event_Status_DateTimeTo)) left outer join
	    tbEvent          EVT WITH(FORCESEEK) on EVT.EventId=PRF.EventId left outer join
	    tbCalendarDetail CDT on CDT.CalendarId=Coalesce(PRF.CalendarId, EVT.CalendarId) and CDT.CalendarDate=Cast(PRF.DateTimeFrom as date)
	  where
	    PRF.EventId=@eventId and
	    PRF.PerformanceStatus=2/*onsale*/ and
	    PRF.DBDateTimeTo>=@dbDateTimeFrom and
	    (
	      PRF.PerformanceTypeFromCalendar=0 or 
	      EVT.CalendarId is null 
	      or CDT.CalendarDate is not null
	    )
	  order by
	    PRF.DBDateTimeFrom

	  FOR JSON PATH
  ) 
END
