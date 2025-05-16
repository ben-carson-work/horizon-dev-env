FUNCTION [dbo].[fnDecodeIntTime] (
  @input int  -- integer time (ie: tbProduct.OnSaleTimeFrom)
)
/*
 * Decode an encoded integer time (ie: tbProduct.OnSaleTimeFrom) into a date time. Date portion will be 1/1/1900
 */
RETURNS time
AS
BEGIN
  RETURN (select DATEADD(mi, @input, TIMEFROMPARTS(0, 0, 0, 0, 0)));
END
