FUNCTION [dbo].[fnDriverFrameworkJSON]
/*
 * Returns a JSON containing all driver's required framewrk
 * Maps to com.vgs.cl.document.DOPlugin.DOFrameworkFile
 */
(
  @DriverId uniqueidentifier    -- Driver internal ID
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
	  select
	    FileName,
	    Platform,
	    SourceFolder,
	    ToRunningFolder
	  from
	    tbDriverFramework
	  where
	    DriverId=@DriverId
	      
    FOR JSON PATH
  ) 
END
