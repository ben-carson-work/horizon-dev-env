FUNCTION [dbo].[fnCodeAliasRawJSON]
/*
 * Returns a json containing all codealias of an entity
 */
(
  @entityId uniqueidentifier    -- Entity identifier
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
	select
		CLT.CodeAliasTypeName,
		CLT.CodeAliasTypeCode,
		CL.CodeAlias
	from
		tbCodeAlias CL left join
		tbCodeAliasType CLT on CLT.CodeAliasTypeId=CL.CodeAliasTypeId
	where
		CL.EntityId=@entityId
    FOR JSON PATH
  ) 
END

