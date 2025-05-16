FUNCTION [dbo].[fnAccountChildCountByRole]
/*
 * Return the number of "child" account of an organization, filtered by RoleId and AccountFlag
 */
(
  @AccountId   uniqueidentifier, -- Organization ID
  @RoleId      uniqueidentifier, -- Role ID
  @AccountFlag smallint          -- AccountFlag
)
RETURNS int
AS
BEGIN
	DECLARE @result int;
	
 select 
   @result = COUNT(*)
 from
   tbAccount AC inner join
   tbLogin LO on LO.AccountId=AC.AccountId and LO.B2B_RoleId=@RoleId inner join
   tbAccountFlag AF on AF.AccountId = AC.AccountId and AF.AccountFlag=@AccountFlag
 where
   AC.ParentAccountId=@AccountId
   
  RETURN @result;
END
