FUNCTION [dbo].[fnMetaDataRawJSON]
/*
 * Returns a json containing all metadata of an entity
 * Maps to com.vgs.snapp.dataobject.DOMetaDataItem but requires java manipulation before beaing used
 */
(
  @entityId uniqueidentifier    -- Entity identifier
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @result nvarchar(max) = NULL;
	
	IF (@entityId IS NOT NULL)
	BEGIN
	  select @result = (
	    select
	      X.MetaFieldId,
	      X.ShortValue,
	      X.LongValue,
	      X.CryptoKeyId
	    from
	      (
	        select
	          MD.MetaFieldId,
	          MD.ShortValue,
	          MD.LongValue,
	          MD.CryptoKeyId
	        from
	          tbMetaData MD
	        where MD.EntityId=@entityId
	
	        union
	
	        select
	          MF.MetaFieldId,
	          RGT.RightValue,
	          null,
	          null
	        from
	          tbRight RGT inner join
	          tbMetaField MF on MF.FieldType=61/*language*/
	        where
	          RGT.EntityId=@entityId and
	          RGT.RightType=5/*langISO*/
	
	        union
	
	        select
	          MF.MetaFieldId,
	          LA.UserName as ShortValue,
	          null,
	          null
	        from
	          tbLoginAlias LA inner join
	          tbMetaField MF on MF.FieldType=(
	            case LA.LoginAliasType
	              when 0/*default*/ then 59/*UserName*/
	              when 1/*email*/   then 60/*LoginEmail*/
	              else 0
	            end)
	        where LA.AccountId=@entityId
	      ) X
	
	    FOR JSON PATH
	  ) 
  END
  
  RETURN @result;
END
