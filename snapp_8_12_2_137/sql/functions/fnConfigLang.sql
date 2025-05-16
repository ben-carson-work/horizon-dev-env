FUNCTION [dbo].[fnConfigLang]
/*
 * Returns the Trnaslation from tbConfigLang
 */
(
  @EntityId uniqueidentifier,   -- EntityId of the object for which the translation is saved
  @LangField int,               -- LkSNHistoryField
  @LangISO varchar(3),          -- Language ISO code
  @AltLangISO varchar(3)        -- Alternative language ISO code (can be null)
)
RETURNS nvarchar(max)
AS
BEGIN
  DECLARE @result nvarchar(max);

  select top 1 
    @result=Translation
  from
    tbConfigLang
  where
    EntityId=@EntityId and
    LangField=@LangField and
    LangISO in (@LangISO, @AltLangISO)
  order by
    (case LangISO when @LangISO then 1 else 2 end)

  RETURN @result
END

