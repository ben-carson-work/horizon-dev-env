class StepUpsellSwapController extends StepUpsellController {
  constructor() {
    super();
    
    $("#step-upsell-swap .kiosk-header-title").attr("data-itl", "@StepUpsellSwap.Title").prepend("<i class='fa fa-bounce fa-up-from-line'></i>");
    $("#step-upsell-swap .kiosk-header-subtitle").attr("data-itl", "@StepUpsellSwap.Subtitle");
  }
  
  _upsellActivate() {
    super._upsellActivate();
    
    let skipStep = true;
    for (const portfolio of this.portfolioList) {
      if ((portfolio.SwapList || []).length > 0) {
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

    for (const target of portfolio.SwapList) {
      let $target = $("#swap-templates .upsell-swap-target").clone().appendTo($item.find(".upsell-swap-target-list"));
      $target.data("swap-target", target);
      $target.find(".upsell-swap-target-product-name").text(target.TargetProduct.ProductName);
      $target.find(".upsell-swap-target-price").text("+" + formatCurr(target.Price));
      $target.click(() => {
        if (!$target.is(".checked")) 
          $target.closest(".upsell-swap-item").find(".upsell-swap-target.checked").removeClass("checked");
        $target.toggleClass("checked");
      });
    }
    
    return $item;
  }
  
  nextClick() {
    let reqItemList = [];
    
    this.$ui.find(".upsell-swap-target.checked").each((index, elem) => {
      let $target = $(elem);
      let target = $target.data("swap-target"); 
      let $item = $target.closest(".upsell-swap-item");
      let portfolio = $item.data("upsell-portfolio");
      reqItemList.push({
        "ShopCartDetailId": portfolio.ShopCartDetailId,
        "TargetProduct": {
          "ProductId": target.TargetProduct.ProductId  
        }
      });       
    });
    
    if (reqItemList.length <= 0)
      super.nextClick();
    else 
      KIOSK_CONTROLLER.apiShopCart("SwapItem", {"ItemList":reqItemList}).then(() => super.nextClick());
  }
}
