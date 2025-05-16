FUNCTION [dbo].[fnAccountCategoryJSON]
/*
 * Returns a json containing all categories assigned to an account
 * Maps to com.vgs.snapp.dataobject.DOCategoryRef
 */
(
  @AccountId uniqueidentifier    -- Account identifier
)
RETURNS nvarchar(max)
AS

BEGIN
	DECLARE @Result nvarchar(max) = NULL;
	
	IF (@AccountId IS NOT NULL)
	BEGIN
	  SET @Result = (
	  
	    select
	      CAT.CategoryId,
	      CAT.CategoryCode,
	      CAT.CategoryName,
	      
			  Stuff((
          select ',' + Cast(AC.AccountContext as varchar(max))
          from tbAccountContext AC
          where AC.CategoryId=CAT.CategoryId
          FOR XML PATH('')
        ), 1, 1, '') as AccountContexts,
			  
	      (
	        select 
					  C2L.LocationAccountId as LocationId
					from 
					  tbCategory2Location C2L
					where 
					  C2L.CategoryId=CAT.CategoryId
					FOR JSON PATH
	      ) as LocationList
	      
	    from
	      tbCategory2Entity C2E inner join
	      tbCategory CAT on CAT.CategoryId=C2E.CategoryId
	    where
	      C2E.EntityId=@AccountId
	      
	    FOR JSON PATH
	  ) 
	END
	
	RETURN @Result;
END
