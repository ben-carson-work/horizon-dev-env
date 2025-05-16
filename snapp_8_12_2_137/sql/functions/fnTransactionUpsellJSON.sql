FUNCTION [dbo].[fnTransactionUpsellJSON]
/*
 * Returns a json containing upsells applied by a transaction
 * Map to com.vgs.snapp.dataobject.transaction.DOTransactionUpsellStatItem
 */
(
  @TransactionId uniqueidentifier    -- Transaction ID
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @UpsellType_Swap int = 10;

	RETURN (
    select
      TUPS.SourceProductId    as [SourceProductId],
      PRDSRC.ProductCode      as [SourceProductCode],
      PRDSRC.ProductName      as [SourceProductName],
      TUPS.SourceProductId    as [TargetProductId],
      PRDDST.ProductCode      as [TargetProductCode],
      PRDDST.ProductName      as [TargetProductName],
      TUPS.UpsellType         as [UpsellType],
      TUPS.Quantity           as [Quantity],
      (CASE
        WHEN TUPS.UpsellType=@UpsellType_Swap THEN 'right-left'
        ELSE 'circle-plus'
      END)                    as [IconAlias]
    from
      tbTransactionUpsell TUPS left join
      tbProduct           PRDSRC on PRDSRC.ProductId=TUPS.SourceProductId left join
      tbProduct           PRDDST on PRDDST.ProductId=TUPS.TargetProductId 
    where
      TUPS.TransactionId=@TransactionId
  
    FOR JSON PATH
  )

END