FUNCTION [dbo].[fnProductPriceVariableJSON]
/*
 * Returns product's variable preset amounts JSON mapped to DOProduct.DOProductPriceVariable
 */
(
  @ProductId uniqueidentifier    -- Product ID
)
RETURNS nvarchar(max)
AS
BEGIN
  return (
    select
      PPV.PriceValueType,
      PPV.PriceValue
    from
      tbProductPriceVariable PPV
    where
      PPV.ProductId=@ProductId
    order by
      PPV.PriorityOrder
      
    FOR JSON PATH
  ) 
END
