FUNCTION [dbo].[fnAccountRoleJSON]
/*
 * Returns a json containing all roles assigned to a user
 * Maps to com.vgs.snapp.dataobject.DORole
 */
(
  @accountId uniqueidentifier    -- User account identifier
)
RETURNS nvarchar(max)
AS

BEGIN
  return (
  
    select 
      ROL.RoleId,
      ROL.RoleCode,
      ROL.RoleName,
      ROL.RoleType
    from 
      (
        select A2R.RoleId from tbAccount2Role A2R where A2R.AccountId=@accountId
        
        union
        
        select LOG.B2B_RoleId from tbLogin LOG where LOG.AccountId=@accountId
        
      ) X inner join
      tbRole ROL on ROL.RoleId=X.RoleId
	  order by
	    ROL.RoleName
	    
    FOR JSON PATH
  ) 
END
