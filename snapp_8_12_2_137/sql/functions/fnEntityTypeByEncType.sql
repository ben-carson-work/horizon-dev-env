FUNCTION [dbo].[fnEntityTypeByEncType]
/*
 * Return the EntityType associated to the @type passed
 */
(
  @type tinyint -- Type of barcode. Ordinal value of the java enum EncType
)
RETURNS varchar(max)
WITH ENCRYPTION
AS
BEGIN
  return
      (case
        when @type=0 then   21 -- sale
        when @type=1 then   23 -- media
        when @type=2 then 1015 -- account
        when @type=3 then   20 -- transaction
        when @type=4 then   29 -- voucher
        when @type=5 then   85 -- individual coupon
        when @type=6 then   22 -- ticket
        else dbo.fnRaiseError('Unable to determine EntityType for EncType=' + Cast(@type as varchar(max)))
      end);
END
