FUNCTION [dbo].[fnGetSerialRange] ()
/*
 * For DSSN encoding, the StationSerial/EntitySerial values have a dynamic length.
 * A first small information (named "wks2bit"), a value from 0 to 3, tells what are these lengths
 */
RETURNS @result TABLE (
  [Wks2bit] int null,         -- Number from 0 to 3 (see above comment)
  [WksBits] int null,         -- Number of bits dedicated to store the StationSerial
  [SerialBits] int null,      -- Number of bits dedicated to store the EntitySerial (TicketSerial, MediaSerial, etc...)
  [MaxStationSerial] int null -- Max assignable StationSerial
)
WITH ENCRYPTION
AS
BEGIN
  
  declare @LOCAL_TABLEVARIABLE table (wks2bit int, wksBits int);
  insert into @LOCAL_TABLEVARIABLE (wks2bit, wksBits) 
  values 
    (0, 0), 
    (1, 5), 
    (2, 10), 
    (3, 13);
  
  declare @maxSerialBits int = 27;
  insert into @result
    select 
      wks2bit,
      wksBits,
      (@maxSerialBits - wksBits) as [serialBits],
      Power(2, wksBits)
    from
      @LOCAL_TABLEVARIABLE

  RETURN;
END
