FUNCTION [dbo].[fnMetaDataValue]
/*
 * Returns a MetaDataValue given an EntityId and a MetaFieldCode
 */
(
  @EntityId uniqueidentifier,   -- EntityId of the object where the meta-data is saved
  @MetaFieldCode varchar(100)   -- MetaFieldCode of the requested meta-data
)
RETURNS nvarchar(max)
AS
BEGIN
  DECLARE @Result nvarchar(max);

  select @Result=Coalesce(MD.ShortValue, MD.LongValue)
  from
    tbMetaField MF inner join
    tbMetaData MD on Md.EntityId=@EntityId and MD.MetaFieldId=MF.MetaFieldId 
  where MF.MetaFieldCode=@MetaFieldCode

  RETURN @Result
END

