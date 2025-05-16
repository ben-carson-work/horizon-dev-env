FUNCTION [dbo].[fnTicketRenewProductTable]
/*
 * Given a ticket, returns list of products which are eligible for renewal 
 */
(
  @ticketId uniqueidentifier,    -- Ticket identifier (MANDATORY)
  @fiscalDate date               -- current fiscalDate
)
RETURNS @result TABLE (
  ProductId uniqueidentifier,
  ProductCode varchar(max),
  ProductName nvarchar(max)
)
AS

BEGIN
  declare @error varchar(max);
  declare @sourceProductId uniqueidentifier;
  declare @ticketValidDateTo date;
  declare @renewToAny bit;
  
  select
    @sourceProductId=TCK.ProductId,
    @ticketValidDateTo=TCK.ValidDateTo,
    @renewToAny=(case when PF.ProductId is null then 0 else 1 end)
  from 
    tbTicket TCK left join
    tbProductFlag PF on PF.ProductId=TCK.ProductId and PF.ProductFlag=33/*renew TO any*/
  where 
    TCK.TicketId=@ticketId;
  
  if (@sourceProductId is null)
    select @error=dbo.fnRaiseError('Unable to find TicketId=' + Cast(@ticketId as varchar(max)));
    
  declare @productIDs TABLE (ProductId uniqueidentifier);
  if (@renewToAny = 1) 
  begin
    insert into @productIDs (ProductId)
    select ProductId
    from tbProductFlag
    where ProductFlag=32/*renew FROM any*/
	end
  else 
  begin
    insert into @productIDs (ProductId)
    select ProductId 
    from tbProductRenewFromProduct 
    where SourceProductId=@sourceProductId
	end
	
	
	

	insert into @result (
	  ProductId,
	  ProductCode,
	  ProductName
	)
	select
	  PRD.ProductId,
	  PRD.ProductCode,
	  PRD.ProductName
	from
	  @productIDs X inner join
	  tbProduct PRD on
	    PRD.ProductId=X.ProductId and
      (
        @ticketValidDateTo is null or
        (
          (
            PRD.RenewWindowStartDays is null or
            DateAdd(day, PRD.RenewWindowStartDays, @ticketValidDateTo) <= @fiscalDate
          ) and
          (
            PRD.RenewWindowEndDays is null or
            DateAdd(day, PRD.RenewWindowEndDays, @ticketValidDateTo) >= @fiscalDate
          )
        )
      )

   RETURN;
END;