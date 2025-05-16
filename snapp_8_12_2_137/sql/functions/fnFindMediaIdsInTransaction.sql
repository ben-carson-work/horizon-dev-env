FUNCTION [dbo].[fnFindMediaIdsInTransaction]
/*
 * Extract a ticket list for transaction specified
 */
(
  @TransactionId uniqueidentifier, -- Transaction id
  @EntityType_Media int, --Entity type Media
  @EntityType_Transaction int	--Entity type Transaction
)
RETURNS TABLE AS
	return (
		select
			TBE.DstEntityId as MediaId
		from
			tbEntityLink as TBE
		where
			TBE.DstEntityType= @EntityType_Media and
	  	TBE.SrcEntityId = @TransactionId and
	  	TBE.SrcEntityType = @EntityType_Transaction
	  	
		union
			
		select 
			MediaId
		from 
			tbMedia as TM
		where 
			TM.TransactionId = @TransactionId
			
		union
		
		select 
			TMT.MediaId
		from
			tbTransactionMediaTransfer TMT
		where 
			TMT.TransactionId = @TransactionId
		); 