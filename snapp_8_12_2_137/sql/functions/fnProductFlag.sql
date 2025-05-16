FUNCTION [dbo].[fnProductFlags]
/*
 * * Return true if the product's flag requested is on
 */
(
  @ProductId uniqueidentifier, -- Product ID
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
       tbProductFlag 
     where 
       ProductId = @ProductId and ProductFlag=@flag))
    set @result=1;

  RETURN(@result);
END
