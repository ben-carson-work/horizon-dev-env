FUNCTION [dbo].[fnSaleLinkRawJSON]
/*
 * Returns a json containing all sale linked to another sale
 * Maps to com.vgs.snapp.dataobject.DOLinkedSaleRef but requires java manipulation before beaing used (only filling [LinkType] and [SaleRef.SaleId]/[SaleRef.SaleCode] here)
 */
(
  @saleId uniqueidentifier    -- Sale identifier
)
RETURNS nvarchar(max)
AS
BEGIN
  declare @EntityType_Sale                      smallint = 21;
  declare @SaleLinkType_SplitSource             smallint = 1;
  declare @SaleLinkType_SplitTarget             smallint = 2;
  declare @SaleLinkType_RevalidatedBy           smallint = 3;
  declare @SaleLinkType_RevalidateTarget        smallint = 4;
  declare @SaleLinkType_MergeSource             smallint = 5;
  declare @SaleLinkType_MergeTarget             smallint = 6;
  declare @SaleLinkType_OrderItemTransferSource smallint = 7;
  declare @SaleLinkType_OrderItemTransferTarget smallint = 8;
  declare @EntityLinkType_SaleSplit             smallint = 6;
  declare @EntityLinkType_SaleMerge             smallint = 44;
  declare @EntityLinkType_OrderItemTransfer     smallint = 47;

  return (
    select
      S.SaleId       as [SaleRef.SaleId],
      S.SaleCode     as [SaleRef.SaleCode],
      X.SaleLinkType as [LinkType]
    from
      (
        -- Split Source
        select distinct
          SrcEntityId as SaleId,
          case
            when EntityLinkType = @EntityLinkType_SaleSplit then @SaleLinkType_SplitSource
            when EntityLinkType = @EntityLinkType_SaleMerge then @SaleLinkType_MergeSource
            when EntityLinkType = @EntityLinkType_OrderItemTransfer then @SaleLinkType_OrderItemTransferSource
          end as SaleLinkType
        from tbEntityLink
        where DstEntityId=@SaleId
        
        -- Split Dest
        union
        select distinct
          DstEntityId,
          case
            when EntityLinkType = @EntityLinkType_SaleSplit then @SaleLinkType_SplitTarget
            when EntityLinkType = @EntityLinkType_SaleMerge then @SaleLinkType_MergeTarget
            when EntityLinkType = @EntityLinkType_OrderItemTransfer then @SaleLinkType_OrderItemTransferTarget
          end as SaleLinkType
        from tbEntityLink
        where
          SrcEntityId=@SaleId and
          DstEntityType=@EntityType_Sale

        -- Revalidated by
        union
        select
          dbo.fnGetRevalidateTargetSaleId(@saleId) as SaleId,
          @SaleLinkType_RevalidatedBy as SaleLinkType
          
        -- Revalidate
        union
        select 
          dbo.fnGetRevalidateSourceSaleId(@saleId) as SaleId,
          @SaleLinkType_RevalidateTarget as SaleLinkType
      ) X inner join
      tbSale S on S.SaleId=X.SaleId
    order by
      S.SaleDateTime desc
	    
    FOR JSON PATH
  ) 
END
