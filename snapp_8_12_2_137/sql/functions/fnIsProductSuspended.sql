FUNCTION [dbo].[fnIsProductSuspended]
/*
 * Return true if the product type (therefore its tickets) is suspended
 */
(
  @ProductId uniqueidentifier,	-- Unique identifier of the product type
  @CheckDate date				-- Date of when the check is performed
)
RETURNS bit
AS
BEGIN
  declare @result bit=0;  

  select top(1) @result= (case 
							when ProductSuspendSerial is null then 0
							else 1
						  end)
  from
    tbProductSuspend
  where
    ProductId=@ProductId and
	SuspendDateFrom<=@CheckDate and
	(SuspendDateTo is null or SuspendDateTo>=@CheckDate)

  RETURN(@result);
END