FUNCTION [dbo].[fnProfilePictureId]
/*
 * Returns profile picture repository id of an entity
 */
(
  @entityId uniqueidentifier  -- Entity identifier (MANDATORY)
)
RETURNS uniqueidentifier
AS
BEGIN
  return (
	  select 
	    RepositoryId
	  from 
	    tbRepositoryIndex
	  where
	   EntityId=@entityId and
	   RepositoryIndexType=1
	 )
END