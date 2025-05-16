FUNCTION [dbo].[fnProductFlags]
/*
 * Return the product's flags (LkSNProductFlag) as comma separated string
 */
(
  @ProductId   uniqueidentifier -- Product ID
)
RETURNS varchar(max)
AS
BEGIN
	DECLARE @result varchar(max);
	
  select @result = Stuff((
    select ',' + Cast(PF.ProductFlag as varchar(max))
    from tbProductFlag PF
    where PF.ProductId=@ProductId
    FOR XML PATH('')
  ), 1, 1, '');
   
  RETURN @result;
END
