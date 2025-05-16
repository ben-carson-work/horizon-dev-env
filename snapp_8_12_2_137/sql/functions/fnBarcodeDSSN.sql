FUNCTION [dbo].[fnBarcodeDSSN]
/*
 * Encode a barcode leveraging on the "DSSN" logic (license/station/date/serial)
 */
(
  @type tinyint,    -- Type of barcode. Ordinal value of the java enum EncType
  @format tinyint,  -- Number from 0 to 3 which tells what kind of format/encoding should be used. Only 0 is supported for now
  @base tinyint,    -- Number of bits usable for output chars. 10 means numeric only; 16 means hexdecimal; etc...
  @seed smallint,   -- Seed/Password to be used for encryption
  @license int,     -- LicenseId of the DSSN
  @station int,     -- StationSerial of the DSSN
  @date date,       -- FiscalDate of the DSSN
  @serial int,      -- Serial of the DSSN
  @testMode bit,    -- Indicates if the barcode was produced by a non-production system
  @offlineMode bit  -- Indicates if the barcode was encoded offline
)
RETURNS varchar(max)
WITH ENCRYPTION
AS
BEGIN
  declare @result varchar(max);

  if (@format <> 0) -- Format can only be between 0..3
    set @result = dbo.fnRaiseError('Invalid @format: ' + Cast(@format as varchar(max)));

  if (@base <> 32) 
    set @result = dbo.fnRaiseError('Invalid @base: ' + Cast(@format as varchar(max)) + '. Only base32 is supported.');

  declare @baseChars varchar(max) = dbo.fnGetbaseChars(@base);
  declare @year int = DatePart(year, @date);
  declare @doy int = DatePart(dayofyear, @date);

  if ((@base = 32) and (@format = 0))
  begin
    declare @wks2bit int;
    declare @wksBits int;
    declare @serialBits int;
    
    select top 1 @wks2bit=wks2bit, @wksBits=wksBits, @serialBits=serialBits 
    from dbo.fnGetSerialRange() 
    where @station < MaxStationSerial
    order by wks2bit;

    declare @seedBits int = 3;
    declare @encodedSeed smallint = ((@seed % Power(2, @seedBits)) * 4) + @wks2bit; 

    declare @licenseAndFlags int = @license;
    if (@testMode <> 0)
      set @licenseAndFlags = @licenseAndFlags + Power(2, 14);
    if (@offlineMode <> 0)
      set @licenseAndFlags = @licenseAndFlags + Power(2, 13);
      
    declare @cksBits int = 3;
    declare @checksum int = (@license + @station + @year + @doy + @serial) % Power(2, @cksBits);
    declare @iSerial bigint = (@station * Power(2, @serialBits + @cksBits)) + (@serial * Power(2, @cksBits)) + @checksum;
    declare @plain varchar(max) = 
        dbo.fnEncodeBase(@licenseAndFlags, 3, @base) + 
        dbo.fnEncodeBase((@year - 2012) * 367 + @doy, 3, @base) + 
        dbo.fnEncodeBase(@iSerial, 6, @base);

    set @result = 
        SubString(@baseChars, @type + 1, 1) +
        SubString(@baseChars, @encodedSeed + 1, 1) +
        dbo.fnEncryptOld(@plain, @seed);
  end; 

  return @result; 
END
