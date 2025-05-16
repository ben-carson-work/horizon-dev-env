FUNCTION [dbo].[fnFindTicketIdsInTransaction]
/*
 * Extract a ticket list for transaction specified
 */
(
  @TransactionId uniqueidentifier, -- Transaction id
  @EntityType_ticket int --Entity type Ticket
)
RETURNS TABLE AS
	return (
    select
			TCK.TicketId
    from
			tbTicket TCK
		where
			TCK.TransactionId=@TransactionId
			
		union
			
		select
			TCK.TicketId
		from	
			tbEntityLink EL inner join
			tbTicket TCK on TCK.TicketId=EL.DstEntityId
    where
			EL.SrcEntityId = @TransactionId and
			EL.DstEntityType = @EntityType_ticket
			
    union
    
    select
			TCK.TicketId
    from
			tbTransaction TRN inner join
			tbTransactionTicketPerformance TTP on TTP.TransactionId=TRN.TransactionId inner join
			tbTicket TCK on TCK.TicketId=TTP.TicketId
    where
			TRN.TransactionId = @TransactionId 
			
		union
		
		select 
			TCK.TicketId
		from
			tbTicket TCK inner join
		  tbTicketMediaMatch TMM on TMM.TicketMediaMatchId = TCK.TicketMediaMatchId inner join
			tbTransactionAccountMerge TAM on FinalAccountId = TMM.AccountId
		where
			TAM.TransactionId  = @TransactionId 
	); 