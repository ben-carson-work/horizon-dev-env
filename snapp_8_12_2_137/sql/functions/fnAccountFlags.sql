FUNCTION [dbo].[fnAccountFlags]
/*
 * Return the account's flags (LkSNAccountFlag) as comma separated string
 */
(
  @AccountId   uniqueidentifier -- Account ID
)
RETURNS varchar(max)
AS
BEGIN
	DECLARE @result varchar(max);
	
  select @result = Stuff((
    select ',' + Cast(AF.AccountFlag as varchar(max))
    from tbAccountFlag AF
    where AF.AccountId=@AccountId
    FOR XML PATH('')
  ), 1, 1, '');
   
  RETURN @result;
END
