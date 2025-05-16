FUNCTION [dbo].[fnDecodeBarcodeDSSN] (
  @barcode varchar(max)
)
/*
 * Decode a barcode leveraging on the "DSSN" logic (license/station/date/serial)
 */
RETURNS @result TABLE (
  [Type] tinyint null,             -- Type of barcode. Ordinal value of the java enum EncType
  [Format] tinyint null,           -- Number from 0 to 3 which tells what kind of format/encoding should be used. 
  [Seed] smallint null,            -- Number of bits usable for output chars. 10 means numeric only; 16 means hexdecimal; etc...
  [SeedModule] smallint null,      -- Seed/Password to be used for encryption
  [LicenseId] int null,            -- LicenseId of the DSSN
  [StationSerial] int null,        -- StationSerial of the DSSN
  [FiscalDate] date null,          -- FiscalDate of the DSSN
  [EntitySerial] int null,         -- Serial of the DSSN
  [TestMode] bit null,             -- Indicates if the barcode was produced by a non-production system
  [OfflineMode] bit null,          -- Indicates if the barcode was encoded offline
  [EntityType] smallint null,      -- EntityType. There is a 1=1 mapping with [Type] field
  [EntityId] uniqueidentifier null -- If found on DB, it is the real ID of the object (TicketId, MediaId, etc...)
)
WITH ENCRYPTION
AS
BEGIN
  declare @error int;

  if (Len(@barcode) < 14)
    set @error = dbo.fnRaiseError('Input @barcode cannot be shorter than 14');

  declare @base tinyint = 32;
  declare @baseChars varchar(max) = dbo.fnGetBaseChars(@base);

  declare @cksBits int = 3;
  declare @licenseBits int = 13;
  declare @seedBits int = 3;
  declare @seedModule int = Power(2, @seedBits);
  declare @format tinyint = 0;
  
  declare @type int = dbo.fnDecodeBase(SubString(@barcode, 1, 1), @base);
  
  declare @encodedSeed int = dbo.fnDecodeBase(SubString(@barcode, 2, 1), @base);
  declare @seed int = @encodedSeed / 4;
  declare @wks2bit int = @encodedSeed % 4;
  
	declare @wksBits int;
	declare @serialBits int;
	
	select @wksBits=wksBits, @serialBits=serialBits 
	from dbo.fnGetSerialRange() 
	where wks2bit=@wks2bit; 
  
  declare @plain varchar(max) = dbo.fnDecryptOld(SubString(@barcode, 3, Len(@barcode) - 2), @seed);
  
  declare @encodedLicense int = dbo.fnDecodeBase(SubString(@plain, 1, 3), @base);
  declare @license int = @encodedLicense % Power(2, @licenseBits);
  declare @offlineMode int = (@encodedLicense / Power(2, @licenseBits + 0)) % 1;
  declare @testMode int = (@encodedLicense / Power(2, @licenseBits + 1)) % 1;

  declare @encodedDate int = dbo.fnDecodeBase(SubString(@plain, 4, 3), @base);
  declare @year int = @encodedDate / 367;
  declare @doy int = @encodedDate - (@year * 367);
  declare @date date = DateAdd(day, @doy-1, DATEFROMPARTS(2012 + @year, 1, 1));
  
  declare @encodedSerial int = dbo.fnDecodeBase(SubString(@plain, 7, 6), @base);
  declare @checksum int = @encodedSerial % Power(2, @cksBits);
  declare @serial int = (@encodedSerial / Power(2, @cksBits)) % Power(2, @serialBits);
  declare @station int = (@encodedSerial / Power(2, @cksBits + @serialBits)) % Power(2, @wksBits);

  declare @entityId uniqueidentifier;
  declare @entityType smallint = dbo.fnEntityTypeByEncType(@type);
  
  if (@entityType = 22) -- Ticket
  begin
	  select @entityId = TicketId 
	  from tbTicket with(index(UQ_Ticket_TDSSN))
	  where 
	    LicenseId=@license and
	    StationSerial=@station and
	    EncodeFiscalDate=@date and
	    TicketSerial=@serial and
	    (TicketSeed % @seedModule)=@seed
  end 
  else if (@entityType = 23) -- Media
  begin
    select @entityId = MediaId 
    from tbMedia with(index(UQ_Media_TDSSN))
    where 
      LicenseId=@license and
      StationSerial=@station and
      EncodeFiscalDate=@date and
      MediaSerial=@serial /*and
      (MediaSeed % @seedModule)=@seed*/
  end 
  
  insert into @result
    select
      @type as [Type],
      @format as [Format],
      @seed as [Seed],
      @seedModule as [SeedModule],
      @license as [LicenseId],
      @station as [StationSerial],
      @date as [FiscalDate],
      @serial as [EntitySerial],
      Cast(@testMode as bit) as [TestMode],
      Cast(@offlineMode as bit) as [OfflineMode],
      @entityType as [EntityType],
      @entityId as [EntityId]   

  RETURN;
END
