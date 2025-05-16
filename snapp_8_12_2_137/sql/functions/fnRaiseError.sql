FUNCTION [dbo].[fnRaiseError] 
/*
 * Utility function which will produce a sql-exception containing the required @message.
 * Apparently is not possible to throw exception in scalar and table functions, and this is a workaround.
 * 
 * This function add constant "SNP-FNC-ERROR" in the raised error, in order to be properly handled in java,
 * since it will receive a generic SQL error code (a cast error in particular)
 */
(
  @message varchar(max)  -- Text of the error
)
RETURNS int
AS
BEGIN
  return Cast('SNP-FNC-ERROR -> ' + @message as int);
END
