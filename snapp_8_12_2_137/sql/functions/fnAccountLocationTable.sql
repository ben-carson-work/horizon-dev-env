FUNCTION [dbo].[fnAccountLocationTable]
/*
 * Returns a talbe with all the parent locations of an account
 */
(
  @accountId uniqueidentifier    -- Account identifier
)
RETURNS @result TABLE ([AccountId] [uniqueidentifier], [AccountCode] [varchar] (20), DisplayName nvarchar (100))
AS
BEGIN

  WITH cte_acc AS (
  select
    ACC.AccountId,
    ACC.ParentAccountId,
    ACC.EntityType,
    ACC.AccountCode,
    ACC.DisplayName
  from
    tbAccount ACC
  where
    ACC.AccountId=@accountId
  union all
  select
    A.AccountId,
    A.ParentAccountId,
    A.EntityType,
    A.AccountCode,
    A.DisplayName
  from
    tbAccount A inner join
    cte_acc P ON P.ParentAccountId=A.AccountId
  )

  insert into @result  (AccountId, AccountCode, DisplayName)
    select 
      AccountId,
      AccountCode,
      DisplayName
    from 
      cte_acc 
    where 
      EntityType=6 /*Location*/
    union
    select 
      LOC.AccountId,
      LOC.AccountCode,
      LOC.DisplayName
    from
      tbCategory2Entity C2E inner join
      tbCategory2Location C2L on C2L.CategoryId=C2E.CategoryId inner join
      tbAccount LOC on LOC.AccountId=C2L.LocationAccountId
    where 
      C2E.EntityId=@accountId and C2E.EntityType in (1/*Organization*/,15/*Person*/,130/*Association*/) 
  
  return
END
