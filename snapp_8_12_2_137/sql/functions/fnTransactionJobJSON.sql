FUNCTION [dbo].[fnTransactionJobJSON]
/*
 * Returns a json containing jobs linked to a transaction
 * Map to com.vgs.snapp.dataobject.transaction.DOTransactionJob
 */
(
  @TransactionId uniqueidentifier    -- Transaction ID
)
RETURNS nvarchar(max)
AS
BEGIN
	RETURN (
    select
      JOB.TaskId,
      TSK.TaskName,
      JOB.JobId,
      JOB.StartDateTime as JobDateTime
    from
      tbTransactionJob TJ  inner join
      tbJob            JOB on JOB.JobId=TJ.JobId left join
      tbTask           TSK on TSK.TaskId=JOB.TaskId 
    where
      TJ.TransactionId=@TransactionId
  
    FOR JSON PATH
  )

END