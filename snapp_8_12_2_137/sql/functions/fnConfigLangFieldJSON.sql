FUNCTION [dbo].[fnConfigLangFieldJSON]
/*
 * Returns a json containing translations for an entity's field
 * Maps to com.vgs.snapp.dataobject.DOConfigLang.DOTranslationItem
 */
(
  @entityId     uniqueidentifier,    -- Entity identifier identifier (ie: ProductId, EventId, etc...)
  @historyField smallint             -- LkSNHistoryField
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select 
      CL.LangISO,
      CL.Translation
    from 
      tbConfigLang CL
    where
      CL.EntityId=@entityId and
      CL.LangField=@historyField
	  order by
	    CL.LangISO
    FOR JSON PATH
  ) 
END
