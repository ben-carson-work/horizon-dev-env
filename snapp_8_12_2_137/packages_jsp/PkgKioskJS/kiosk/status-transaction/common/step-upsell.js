class StepUpsellController extends StepController {
  
  isStepNeeded(direction) {
    return (direction == "FORWARD") && (this.transactionController.upsellOptions !== false);
  }
  
  activate() {
    super.activate();
    
    let $spinner = $("#kiosk-templates .kiosk-spinner").clone().removeClass("show-loading");
    this.$list = this.$ui.find(".upsell-item-list").empty().append($spinner);
    
    KIOSK_CONTROLLER.apiShopCart("GetUpsellOptions").then(ansDO => {
      $spinner.remove();
      
      this.options = ansDO.UpsellOptions || {};
      this.portfolioList = this.options.PortfolioList || [];
      this.cartAddOnList = this.options.CartAddOnList || [];
      
      if (this.portfolioList.length + this.cartAddOnList.length <= 0)
        this.transactionController.stepNext();
      else
        this._upsellActivate();
    });
  }
    
  updateDisplayButtons() {
    this.displayController.$back.text("BACK");
    this.displayController.$next.text("CONFIRM");
  }
  
  _upsellActivate() {
  }
}
