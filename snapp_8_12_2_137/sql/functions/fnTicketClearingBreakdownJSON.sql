FUNCTION [dbo].[fnTicketClearingBreakdownJSON]
/*
 * Returns a json containing the "clearing breakdown" for a given ticket
 * Maps to com.vgs.snapp.dataobject.DOTicketClearingBreakdown
 */
(
  @TicketId uniqueidentifier    -- Ticket identifier
)
RETURNS nvarchar(max)
AS
BEGIN
  DECLARE @Result nvarchar(max) = NULL;

  WITH CTE AS (                                                           
    select                                                              
      LACCOUNT.LedgerAccountType as LedgerAccountType,                  
      LACCOUNT.LedgerAccountId as LedgerAccountId,                      
      LACCOUNT.LedgerAccountCode as LedgerAccountCode,                  
      LACCOUNT.LedgerAccountName as LedgerAccountName,                  
      dbo.fnLedgerDebit(Sum(LREF.LedgerRefAmount)) as LedgerDebitAmount,  
      dbo.fnLedgerCredit(Sum(LREF.LedgerRefAmount)) as LedgerCreditAmount,  
      L.AccountId as AccountId,                                         
      ACC.AccountCode as AccountCode,                                   
      ACC.DisplayName as AccountName                                    
    from                                                                
      tbTicket TCK inner join                                           
      tbLedgerRef LREF on                                               
        LREF.EntityId in (TCK.TicketId, TCK.SaleItemDetailId) inner join
      tbLedger L on                                                     
        L.GroupEntityId=LREF.GroupEntityId and                          
        L.LedgerSerial=LREF.LedgerSerial inner join                     
      tbLedgerAccount LACCOUNT on                                       
        LACCOUNT.LedgerAccountId=L.LedgerAccountId and                  
        LACCOUNT.LedgerAccountType in (2/*liability*/, 5/*revenue*/) and        
        LACCOUNT.AffectClearing=1 inner join                            
      tbAccount ACC on ACC.AccountId=L.AccountId                        
    where                                                               
      TCK.TicketId=@TicketId                                           
    group by                                                            
      LACCOUNT.LedgerAccountType,                                       
      LACCOUNT.LedgerAccountCode,                                       
      LACCOUNT.LedgerAccountName,                                       
      LACCOUNT.LedgerAccountId,                                         
      L.AccountId,                                                      
      ACC.AccountCode,                                                  
      ACC.DisplayName  
    having
      Sum(LREF.LedgerRefAmount) <> 0
  ) 
  
  select @Result = (
    
    select
      Coalesce(Sum(LedgerDebitAmount), 0) as TotalDebitAmount,
      Coalesce(Sum(LedgerCreditAmount), 0) as TotalCreditAmount,
      (
        select                                                                
          LedgerAccountType,                                                  
          LedgerAccountId,                                                    
          LedgerAccountCode,                                                  
          LedgerAccountName,                                                  
          AccountId,                                                          
          AccountCode,                                                        
          AccountName,                                                        
          LedgerDebitAmount as DebitAmount,               
          LedgerCreditAmount as CreditAmount              
        from                                                                  
          CTE                                                                 
        order by                                                              
          LedgerAccountType ASC,                                              
          LedgerAccountCode ASC
        
        FOR JSON PATH
      ) as BreakdownList
   from                                                                  
     CTE                                                                 
      
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
  )
  
  RETURN @Result;
END