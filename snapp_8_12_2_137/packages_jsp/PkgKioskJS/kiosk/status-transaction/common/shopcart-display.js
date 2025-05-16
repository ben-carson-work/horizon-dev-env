class ShopcartDisplayController {
  constructor() {
    this.$back = $("#btn-back");
    this.$next = $("#btn-next");
    
    $(document).on("kiosk-shopcart-change", (event, data) => this._updateValues(data.shopCart));
    $(document).on("kiosk-order-change", (event, data) => this._updateValues(data.order));
    
    this._updateValues({});
  }
  
  _updateValues(entity) {
    let empty = KIOSK_CONTROLLER.isShopCartEmpty() && KIOSK_CONTROLLER.isOrderEmpty();
    $("#shopcart-display").setClass("emptycart", empty);
    if (!KIOSK_CONTROLLER.isShopCartEmpty()) {
	    $(".shopcart-display-totalquantity").text(entity.TotalQuantity);
	    $(".shopcart-display-total").text(formatCurr(entity.TotalAmount));
	    $(".shopcart-display-tax").text(formatCurr(entity.TotalTax));
		}
		else if (!KIOSK_CONTROLLER.isOrderEmpty()) {
			let totalQuantity = entity.ItemList.reduce((sum, li) => sum + li.Quantity, 0);
			$(".shopcart-display-totalquantity").text(totalQuantity);
	    $(".shopcart-display-total").text(formatCurr(entity.TotalAmount));
	    $(".shopcart-display-tax").text(formatCurr(entity.TotalTax));
		}
  }
}