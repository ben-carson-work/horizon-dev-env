FUNCTION [dbo].[fnReadDBParam]
/*
 * Return the value of the DB Param saved on the tbDBInfo table
 */
(
  @paramName varchar(50)	-- Parameter name
)
RETURNS varchar(max)
AS
BEGIN
  declare @result nvarchar(max);  
  
  select @result = ParamValue from tbDbInfo where ParamName=@paramName;
    
  RETURN(@result);
END