PROCEDURE vspConsTransaction_ConsAccountSale
/*
 * Populate tbConsSale 
 */
  @minSequence bigint, -- consolidate all tbTransaction where TransactionSequence>@minSequence
  @maxSequence bigint  -- consolidate all tbTransaction where TransactionSequence>@maxSequence
AS


declare @SaleAccountType_Owner int = 1;
declare @EmptyUUID uniqueidentifier = '00000000-0000-0000-0000-000000000000';

DECLARE @Table TABLE
(
  FiscalDate    date,
  AccountId     uniqueidentifier,
  ProductId     uniqueidentifier,
  OptionSetId   uniqueidentifier,
  TotalAmount   money,
  TotalQuantity int
)


insert into @Table (
  FiscalDate,
  AccountId,
  ProductId,
  OptionSetId,
  TotalAmount,
  TotalQuantity
)
select
  FiscalDate,
  AccountId,
  ProductId,
  OptionSetId,
  Sum(TotalAmount),
  Sum(TotalQuantity)
from (
  select
    TRN.TransactionFiscalDate                          as [FiscalDate],
    S2A.AccountId                                      as [AccountId],
    SI.ProductId                                       as [ProductId],
    Coalesce(SI.OptionSetId, @EmptyUUID)               as [OptionSetId],
    Sum((SI.UnitAmount - SI.UnitTax) * TI.QtyPaid)     as [TotalAmount],
    Sum(TI.QtyPaid)                                    as [TotalQuantity]
  from
    tbTransaction TRN inner join
    tbSale2Account S2A on
      S2A.SaleId=TRN.SaleId and
      S2A.SaleAccountType=@SaleAccountType_Owner inner join
    tbTransactionItem TI on
      TI.TransactionId=TRN.TransactionId inner join
    tbSaleItem SI on
      SI.SaleItemId=TI.SaleItemId
  where
    TRN.TransactionSequence>=@minSequence and
    TRN.TransactionSequence<=@maxSequence
  group by
    TRN.TransactionFiscalDate,
    S2A.AccountId,
    SI.ProductId,
    SI.OptionSetId
  
  union all
  
  select
    TRN.TransactionFiscalDate,
    S2A.AccountId,
    ORGSI.ProductId,
    Coalesce(ORGSI.OptionSetId, @EmptyUUID),
    Sum((SI.UnitAmount - SI.UnitTax) * -TCK.GroupQuantity),
    Sum(-TCK.GroupQuantity)
  from
    tbTransaction TRN inner join
    tbTransactionItem TI on
      TI.TransactionId=TRN.TransactionId and
      TI.QtyPaid<0 inner join
    tbSaleItem SI on
      SI.SaleItemId=TI.SaleItemId inner join
    tbEntityLink ELSI on
      ELSI.SrcEntityId=SI.SaleItemId inner join
    tbEntityLink ELTRN on
      ELTRN.SrcEntityId=TRN.TransactionId and
      ELTRN.DstEntityId=ELSI.DstEntityId inner join
    tbTicket TCK on
      TCK.TicketId=ELSI.DstEntityId inner join
    tbSaleItemDetail ORGSID on
      ORGSID.SaleItemDetailId=TCK.SaleItemDetailId inner join
    tbSaleItem ORGSI on
      ORGSI.SaleItemId=ORGSID.SaleItemId inner join
    tbSale2Account S2A on
      S2A.SaleId=ORGSI.SaleId and
      S2A.SaleAccountType=@SaleAccountType_Owner
  where
    TRN.TransactionSequence>=@minSequence and
    TRN.TransactionSequence<=@maxSequence and
    not exists(select * from tbSale2Account S2A where S2A.SaleId=TRN.SaleId and S2A.SaleAccountType=@SaleAccountType_Owner)
  group by
    TRN.TransactionFiscalDate,
    S2A.AccountId,
    ORGSI.ProductId,
    ORGSI.OptionSetId 
) X
group by
  FiscalDate,
  AccountId,
  ProductId,
  OptionSetId

  

/**** MERGE ****/
merge into tbConsAccountSale as CAS using @Table as CTE on (
  CAS.FiscalDate  = CTE.FiscalDate  and
  CAS.AccountId   = CTE.AccountId   and
  CAS.ProductId   = CTE.ProductId   and
  CAS.OptionSetId = CTE.OptionSetId
)
when matched then
  update set 
    CAS.TotalAmount   = CAS.TotalAmount   + CTE.TotalAmount,
    CAS.TotalQuantity = CAS.TotalQuantity + CTE.TotalQuantity
when not matched then
  insert (
	  FiscalDate,
	  AccountId,
	  ProductId,
	  OptionSetId,
	  TotalAmount,
	  TotalQuantity
  )
  values (
    CTE.FiscalDate,
    CTE.AccountId,
    CTE.ProductId,
    CTE.OptionSetId,
    CTE.TotalAmount,
    CTE.TotalQuantity
  );
