FUNCTION [dbo].[fnBarcode]
/*
 * Encode a barcode leveraging on the "sequence" logic (entities have an overall counter, not tied to date/station/serial as of DSSN)
 */
(
  @type tinyint,    -- Type of barcode. Ordinal value of the java enum EncType
  @format tinyint,  -- Number from 0 to 3 which tells what kind of format/encoding should be used. Only 0 is supported for now
  @base tinyint,    -- Number of bits usable for output chars. 10 means numeric only; 16 means hexdecimal; etc...
  @seed smallint,   -- Seed/Password to be used for encryption
  @sequence bigint  -- Sequence (see overall comment)
)
RETURNS varchar(max)
WITH ENCRYPTION
AS
BEGIN
  declare @result varchar(max);

  if ((@format < 0) or (@format > 3))
    set @result = Cast('Invalid @format: ' + Cast(@format as varchar(max)) as int);

  declare @BaseChars varchar(max) = dbo.fnGetBaseChars(@base);
  declare @EncodedSeed smallint = (@format * 2500) + (@seed % 2500); -- TODO: We should encode by @base
  declare @EncodedSequence varchar(max) = dbo.fnLeadZero(@sequence, 7);
  
  set @result =
    SubString(@BaseChars, @type + 1, 1) +
    dbo.fnLeadZero(@EncodedSeed, 4) +
    dbo.fnEncrypt(@EncodedSequence, @seed, @base);
  
  return @result; 
END
