FUNCTION [dbo].[fnDSSN]
/*
 * Encode a DSSN String (ie: T:1000.1.240111.123) starting from individual values (license/station/date/serial) 
 */
(
  @entityType int,  -- LK[131] Transaction, Ticket, Media
  @license int,     -- LicenseId of the DSSN
  @station int,     -- StationSerial of the DSSN
  @date date,       -- FiscalDate of the DSSN
  @serial int       -- Serial of the DSSN
)
RETURNS varchar(max)
AS
BEGIN
  declare @result varchar(max);
  declare @entityTypePart char(1) = null;
  
  if (@entityType = 20)
    set @entityTypePart = 'T';
  else if (@entityType = 22)
    set @entityTypePart = 'P';
  else if (@entityType = 23)
    set @entityTypePart = 'M';
  else
    set @result = dbo.fnRaiseError('Unsupported @entityType: ' + Cast(@entityType as varchar(max)));
    
  set @result = @entityTypePart + ':' + Cast(@license as varchar(max)) + '.' + Cast(@station as varchar(max)) + '.' + Convert(varchar(max), @date, 12) + '.' + Cast(@serial as varchar(max));
  return @result; 
END
