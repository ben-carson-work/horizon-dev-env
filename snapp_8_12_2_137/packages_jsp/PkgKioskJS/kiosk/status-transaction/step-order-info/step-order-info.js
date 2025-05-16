class StepOrderInfoController extends StepController {
  constructor() {
    super();
    
    $("#step-order-info .kiosk-header-title").attr("data-itl", "@StepOrderInfo.Title");
    $("#step-order-info .kiosk-header-subtitle").attr("data-itl", "@StepOrderInfo.Subtitle");
  }
  
  isStepNeeded() {
    return KIOSK_CONTROLLER.currentOrder != null;
  }

  activate() {
    super.activate();
    this._renderOrder(KIOSK_CONTROLLER.currentOrder);
  }
    
  updateDisplayButtons() {
    super.updateDisplayButtons();
    this.displayController.$back.text(KIOSK_UI_CONTROLLER.itl("@StepOrderInfo.BackButtonCaption"));
		if (KIOSK_CONTROLLER.currentOrder.Completed)
    	this.displayController.$next.text(KIOSK_UI_CONTROLLER.itl("@StepOrderInfo.ReissueTickets"));
    else
    	this.displayController.$next.text(KIOSK_UI_CONTROLLER.itl("@StepOrderInfo.CompleteOrder"));
  }

  _renderOrder(order) {
    let $container = this.$ui.find("#order-items").empty();
    
    for (const item of order.ItemList || []) {
      this._addItemUI($container, {
        "saleItem": item,
        "title": item.ProductName,
        "subtitle": this._getPerformanceDesc(item),
        "unitAmount": item.UnitAmount,
        "totalAmount": item.TotalAmount,
        "quantity": item.Quantity
      });
    }
  }
  
  _getPerformanceDesc(item) { 
		let result = '';
		if (item.EventName)
			result = item.EventName + " - " + formatDate(item.PerformanceDateTime);
			 
    return result;
  }
  
  _addItemUI($container, model) {
    let $item = $("#order-templates .order-item").clone();
    $item.data("model", model);
    $item.find(".order-item-title").text(model.title);
    $item.find(".order-item-subtitle").text(model.subtitle);
    $item.find(".order-item-quantity-value").text(model.quantity);
    $item.find(".order-item-unitamount-value").text(formatCurr(model.unitAmount));
    $item.find(".order-item-totalamount-value").text(formatCurr(model.totalAmount));
    
    $container.append($item);
  }
  
  backClick() {
    this.transactionController.activate();
	}
	
	nextClick() {
    this.transactionController.paymentInfo = {};
		if (!KIOSK_CONTROLLER.currentOrder.Completed) {
			KIOSK_CONTROLLER.apiShopCart("LoadShopCart", { "SaleCode": KIOSK_CONTROLLER.currentOrder.SaleCode })
				.then(() => this.transactionController.jumpToPayment());
		}
		else {
			this.transactionController.jumpToStep("CHECKOUT");
		}		    
  }
}
