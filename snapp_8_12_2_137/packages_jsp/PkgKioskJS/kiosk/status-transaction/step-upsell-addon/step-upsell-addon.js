class StepUpsellAddonController extends StepUpsellController {
  constructor() {
    super();

    $("#step-upsell-cart .kiosk-header-title").attr("data-itl", "@StepUpsellAddon.Title").prepend("<i class='fa fa-beat fa-plus'></i>");
    $("#step-upsell-cart .kiosk-header-subtitle").attr("data-itl", "@StepUpsellAddon.Subtitle");
  }
  
  _upsellActivate() {
    super._upsellActivate();
    
    let skipStep = true;
    for (const portfolio of this.portfolioList) {
      if ((portfolio.AddOnList || []).length > 0) {
        skipStep = false;
        this.$list.append(this._createItemUI(portfolio));
      }
    }
    
    if (skipStep)
      this.nextClick();
  }

  _createItemUI(portfolio) {
    let $item = $("#swap-templates .upsell-swap-item").clone();
    $item.data("upsell-portfolio", portfolio);
    $item.find(".upsell-swap-item-title").text(portfolio.Product.ProductName);

    for (const target of portfolio.AddOnList) {
      let $target = $("#swap-templates .upsell-swap-target").clone().appendTo($item.find(".upsell-swap-target-list"));
      $target.data("swap-target", target);
      $target.find(".upsell-swap-target-product-name").text(target.TargetProduct.ProductName);
      $target.find(".upsell-swap-target-price").text("+" + formatCurr(target.Price));
      $target.click(() => $target.toggleClass("checked"));
    }
    
    return $item;
  }
  
  nextClick() {
    let products = {};
    
    this.$ui.find(".upsell-swap-target.checked").each((index, elem) => {
      let $target = $(elem);
      let target = $target.data("swap-target"); 
      let $item = $target.closest(".upsell-swap-item");
      let productId = target.TargetProduct.ProductId;
      
      let product = products[productId];
      if (product == null) {
        product = {"quantityDelta":0};
        products[productId] = product;
      } 
      product.quantityDelta += 1;
    });

    let reqItemList = [];
    for (const productId of Object.keys(products)) {
      reqItemList.push({
        "Product": {
          "ProductId": productId  
        },
        "QuantityDelta": products[productId].quantityDelta
      });       
    }
    
    if (reqItemList.length <= 0)
      super.nextClick();
    else 
      KIOSK_CONTROLLER.apiShopCart("AddToCart", {"ItemList":reqItemList}).then(() => super.nextClick());
  }
}
