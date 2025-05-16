FUNCTION [dbo].[fnPromoPeriodResetDate]
/*
 * Calculate the period reset date
 * Caller method should consider all orders made from the returned date (included)
 */
(
  @fiscalDate date,       -- current FiscalDate
  @periodType tinyint,    -- Type of period
  @numberOfDays smallint  -- Offset days from the start of the period
)
RETURNS date
AS
BEGIN
  declare @result date = @fiscalDate;
  
  if (@periodType = 10) -- LastNDays
  begin
    set @result = DATEADD(DAY, -@numberOfDays+1, @result)
  end
  else
  begin
    -- set the start of the period
    set @result = case
      when @periodType = 20 then DATEADD(WEEK, DATEDIFF(WEEK, 0, @result), 0)
      when @periodType = 30 then DATEADD(MONTH, DATEDIFF(MONTH, 0, @result), 0)
      when @periodType = 40 then DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @result), 0)
      when @periodType = 50 then DATEADD(YEAR, DATEDIFF(YEAR, 0, @result), 0)
      else @result
    end
    
    -- add the offset days
    set @result = DATEADD(DAY, @numberOfDays, @result)
    
    -- if result is in the future move the result back one period
    if (@result > @fiscalDate) 
    begin
      set @result = case
        when @periodType = 20 then DATEADD(WEEK, -1, @result)
        when @periodType = 30 then DATEADD(MONTH, -1, @result)
        when @periodType = 40 then DATEADD(QUARTER, -1, @result)
        when @periodType = 50 then DATEADD(YEAR, -1, @result)
        else @result
      end
    end
  end
    
  
  return @result; 
END
