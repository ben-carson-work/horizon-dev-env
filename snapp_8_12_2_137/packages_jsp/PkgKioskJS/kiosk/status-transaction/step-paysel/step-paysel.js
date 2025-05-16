class StepPaySelController extends StepController {
  constructor() {
    super();
    
    $("#step-paysel .kiosk-header-title").attr("data-itl", "@StepPaysel.Title");
    $("#step-paysel .kiosk-header-subtitle").attr("data-itl", "@StepPaysel.Subtitle");
    $("#step-paysel .kiosk-pane-item").click(event => this._onPayClick(event));
  }
      
  updateDisplayButtons() {
    super.updateDisplayButtons();
    this.displayController.$back.text(KIOSK_UI_CONTROLLER.itl("@StepPaysel.BackButtonCaption"));
    this.displayController.$next.addClass("disabled");
    
    $("#step-paysel .kiosk-pane-item").each(() => {
				let paymentMethodId = $(this).attr("data-paymentmethodid");
    		if (KIOSK_CONTROLLER.enabledPaymentMethodIDs.includes(paymentMethodId))
    			$(this).removeClass("disabled");
    		else
    			$(this).addClass("disabled");
			});

  }
  
  isStepNeeded() {
    return KIOSK_CONTROLLER.shopCart.TotalDue != 0;
  }
  
  activate() {
    super.activate();

    let $container = this.$ui.find("#payment-list").empty();
    let $template = this.$ui.find("#paysel-templates .btn-pay");
    let payments = KIOSK_UI_CONTROLLER.kiosk.PaymentList || [];
    
    for (const payment of payments) {
      let $item = $template.clone().appendTo($container);
      $item.attr("data-paymentmethodid", payment.PaymentMethodId);
      $item.find(".kiosk-pane-item-title").text(KIOSK_UI_CONTROLLER.itl(payment.PaymentName));
      $item.find(".kiosk-pane-item-icon .fa").addClass("fa-" + payment.FA);
      $item.click(() => this._onPayClick(payment.PaymentMethodId, payment.PaymentType));
    }
  }

  _onPayClick(paymentMethodId, paymentType) {
    let params = {
      "paymentMethodId": paymentMethodId
    }
    
    if (paymentType == 15)
		  this._processWalletPayment(params);
    else 
      this._startCheckout(params);
  }
  
  _startCheckout(params) {
    this.transactionController.paymentInfo = params;
    this.transactionController.stepNext();
  }
  
  _processWalletPayment(params) {
    this.transactionController.mediaRead().then((mediaRead) => {
      params.mediaRead = mediaRead;
      this._startCheckout(params);
    });
  }

}
