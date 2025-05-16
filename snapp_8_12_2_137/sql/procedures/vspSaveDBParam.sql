PROCEDURE vspSaveDBParam
/*
 * Save a parameter value into the tbDBInfo table
 * 
 */
  @paramName varchar(50),	-- Parameter name
  @paramValue nvarchar(max)	-- Parameter value
AS

if (@paramValue is null)
begin
	delete from tbDbInfo 
	where
		ParamName = @paramName
end 
else 
begin
	declare @currentValue nvarchar(max); 
  select @currentValue = dbo.[fnReadDBParam](@paramName);
  
  if (@currentValue is null)
  begin
		insert into tbDbInfo (
	    ParamName,
		  ParamValue,
		  LastUpdate
	  )
	  values (
	    @paramName,
	    @paramValue,
	    GETDATE()
	  );	  
  end
  else
  begin
	  if (@currentValue <> @paramValue)
	  begin
			update tbDbInfo set 
				ParamValue = @paramValue,
				LastUpdate = GETDATE()
			where
				ParamName = @paramName	  
	  end 
	end 
end 
