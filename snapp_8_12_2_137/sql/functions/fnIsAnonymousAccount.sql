FUNCTION [dbo].[fnIsAnonymousAccount]
/*
 * Return 1 if account is anonimous, else 0
 */
(
  @AccountId uniqueidentifier	-- Account internal ID
)
RETURNS bit
AS
BEGIN
  declare @result bit;  
  
  if ((@AccountId is null) or not exists(select * from tbMetaData where EntityId=@AccountId))
    set @result = 1;
  else 
    set @result = 0;
    
  RETURN(@result);
END