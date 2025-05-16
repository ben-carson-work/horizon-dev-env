FUNCTION [dbo].[fnAccountFlag]
/*
 * Return true if the account's flag requested is on
 */
(
  @AccountId uniqueidentifier, -- Account ID
  @flag      int               -- Flag number
)
RETURNS bit
AS
BEGIN
	DECLARE @result bit;
  SET @result=0;
	
  if (exists(
       select * 
     from 
       tbAccountFlag 
     where 
       AccountId = @AccountId and AccountFlag=@flag))
    set @result=1;

  RETURN(@result);
END
