FUNCTION [dbo].[fnIsCalendarOK]
/*
 * Tells if a calendar is active for a given date
 */
(
  @calendarId uniqueidentifier, -- Calendar to be checked
  @date       date              -- Date to be checked
)
RETURNS bit
AS
BEGIN
	declare @result bit = 0;
	
	if exists(
	  select *
	  from
	    tbCalendar CAL inner join
	    tbCalendarDetail CD on 
	      CD.CalendarId=CAL.CalendarId and
	      CD.Calendardate=@date
	  where
	    CAL.CalendarId=@calendarId and
	    CAL.Enabled=1
	)
	  set @result = 1;

  return @result;
END
