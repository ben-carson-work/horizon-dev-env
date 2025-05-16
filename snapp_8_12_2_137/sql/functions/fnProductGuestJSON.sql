FUNCTION [dbo].[fnProductGuestJSON]
/*
 * Returns product's variable preset amounts JSON mapped to List<DOProduct.DOProductGuest>
 */
(
  @ProductId uniqueidentifier    -- Product ID
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
  
    select 
      PRD.ProductId, 
      PRD.ProductCode,
      PRD.ProductName, 
      PG.Quantity, 
      PG.AddToHostPortfolio, 
      PG.AutoAddToCart,
      PG.BindPerformance
    from
      tbProductGuest PG inner join 
      tbProduct PRD on PRD.ProductId=PG.GuestProductId 
    where
      PG.ProductId=@ProductId
      
    FOR JSON PATH
  ) 
END
