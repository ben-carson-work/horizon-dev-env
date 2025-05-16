FUNCTION [dbo].[fnDecodeBarcode] (
  @barcode varchar(max)
)
/*
 * Decode a barcode leveraging on the "sequence" logic (entities have an overall counter, not tied to date/station/serial as of DSSN)
 */
RETURNS @result TABLE (
  [Type] tinyint null,               -- Type of barcode. Ordinal value of the java enum EncType
  [Format] tinyint null,             -- Number from 0 to 3 which tells what kind of format/encoding should be used. Only 0 is supported for now
  [Seed] smallint null,              -- Seed/Password to be used for encryption
  [SeedModule] smallint null,        -- Depending on the BASE (10, 16, 32, etc) used for encoding, tells what is the max number encoded as seed 
  [Sequence] bigint null,            -- Sequence (see overall comment)
  [EntityType] smallint null,        -- EntityType. There is a 1=1 mapping with [Type] field
  [EntityId] uniqueidentifier null   -- If found on DB, it is the real ID of the object (TicketId, MediaId, etc...)
)
WITH ENCRYPTION
AS
BEGIN
  declare @error int;

  if (Len(@barcode) < 12)
    set @error = dbo.fnRaiseError('Input @barcode cannot be shorter than 12');

  if (Len(@barcode) > 14) -- Only format supported today
    set @error = dbo.fnRaiseError('Input @barcode cannot be longer than 14');

  declare @base tinyint = 10;
  declare @baseChars varchar(max) = dbo.fnGetBaseChars(@base);

  declare @i int = 1;
  while (@i <= Len(@barcode)) 
  begin
    declare @char varchar(1) = SubString(@barcode, @i, 1);
    declare @chidx int = CharIndex(@char, @BaseChars) - 1;
    if ((@chidx < 0) or (@chidx >= @base))
      set @error = dbo.fnRaiseError('Invalid @barcode character ''' + @char + ''' for base ' + CAST(@base as varchar(max)));
    set @i = @i + 1;
  end;

  declare @type int = CharIndex(SubString(@barcode, 1, 1), @BaseChars) - 1;
  declare @encodedSeed smallint = Cast(SubString(@barcode, 2, 4) as smallint);  -- TODO: We should decode by @base
  declare @seedModule smallint = 2500;
  declare @seed smallint = @encodedSeed % @seedModule;
  declare @format tinyint = @encodedSeed / @seedModule;
  declare @sequence bigint = dbo.fnDecrypt(SubString(@barcode, 6, Len(@barcode) - 5), @seed, @base);
  declare @entityType smallint = dbo.fnEntityTypeByEncType(@type);
  declare @entityId uniqueidentifier;
  
  if (@entityType = 22) -- Ticket
  begin
	  select @entityId = TicketId 
	  from tbTicket with(index(UQ_Ticket_TicketSequence))
	  where 
	    TicketSequence=@sequence and
	    (TicketSeed % @seedModule)=@seed
  end 
  
  insert into @result
    select
      @type as [Type],
      @format as [Format],
      @seed as [Seed],
      @seedModule as [SeedModule],
      @sequence as [Sequence],
      @entityType as [EntityType],
      @entityId as [EntityId]
   

  RETURN;
END
