FUNCTION [dbo].[fnTaxProfileItemJSON]
/*
 * Returns tax profile info mapped to DOTaxProfile.DOTaxProfileItem
 */
(
  @TaxProfileId uniqueidentifier    -- Tax profile ID
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select Cast ((
      select
      T.TaxId,
      T.TaxCode,
      T.TaxName,
      TP2T.TaxablePerc
    from
      tbTaxProfile2Tax TP2T inner join
      tbTax T on T.TaxId=TP2T.TaxId
    where
      TP2T.TaxProfileId=@TaxProfileId
      
      FOR JSON PATH
    ) as nvarchar(max))
  ) 
END
