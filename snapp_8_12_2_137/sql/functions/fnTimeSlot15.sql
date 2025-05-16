FUNCTION [dbo].[fnTimeSlot15] 
/* 
 * Round give datetime by 15 minutes timeslot: 12:14->12:00, 12:15->12:15, 12:16->12:15, etc
 * */
(
  @dateTime datetime -- Date/ime to be rounded
)
RETURNS datetime
AS
BEGIN
	declare @minute int = DatePart(minute, @dateTime);
	
  return 
    SmallDateTimeFromParts(Year(@dateTime), Month(@dateTime), Day(@dateTime), DatePart(hour, @dateTime),
      (case
        when @minute < 15 then 0
        when @minute < 30 then 15
        when @minute < 45 then 30
        else 45
      end)
    )
END
