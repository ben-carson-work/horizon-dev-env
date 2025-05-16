class StepHomeController extends StepController {
  
  constructor() {
    super({"showShopcartDisplay":false});
    
    $("#step-home .kiosk-header-title").attr("data-itl", "@StepHome.Title");
    $("#step-home .kiosk-header-subtitle").attr("data-itl", "@StepHome.Subtitle");
    
    this._mapServiceFunction = {
      "1": this._onPurchase,
      "2": this._onOrderPickup,
      "4": this._onChangePerformance,
    };
  }
    
  isStepNeeded() {
    let services = KIOSK_UI_CONTROLLER.kiosk.ServiceList || [];
    return (services.length > 1) || ((services.length == 1) && (services[0].KioskService != 1/*purchase*/));    
  }
  
  activate() {
    super.activate();

    let $container = this.$ui.find("#service-list").empty();
    let $template = this.$ui.find("#home-templates .btn-service");
    let services = KIOSK_UI_CONTROLLER.kiosk.ServiceList || [];
    
    for (const service of services) {
      let $item = $template.clone().appendTo($container);
      let fnc = this._mapServiceFunction[service.KioskService];
      $item.find(".kiosk-pane-item-title").text(KIOSK_UI_CONTROLLER.itl(service.ServiceName));
      $item.find(".kiosk-pane-item-icon .fa").addClass("fa-" + service.FA);
      if (fnc == null)
        $item.addClass("disabled");
      else
        $item.click(() => fnc.call(this));
    }
  }

  _onPurchase() {
    this.nextClick();
  }

  _onOrderPickup() {
    let params = {
      "title": KIOSK_UI_CONTROLLER.itl("@OrderPickup.OrderLookupTitle"),
      "message": KIOSK_UI_CONTROLLER.itl("@OrderPickup.OrderLookupCaption")      
    };
    
    KIOSK_UI_CONTROLLER.showInput(params).then(value => this._loadOrder(value, () => this._orderInfo()));
  }

  _onChangePerformance() {
    let params = {
      "title": KIOSK_UI_CONTROLLER.itl("@OrderPickup.OrderLookupTitle"),
      "message": KIOSK_UI_CONTROLLER.itl("@OrderPickup.OrderLookupCaption")      
    };
    
    KIOSK_UI_CONTROLLER.showInput(params).then(value => this._loadOrder(value, () => this._changePerformance()));
  }
  
  _loadOrder(saleCode, callback) {
    let params = {
      "saleCode": saleCode      
    };
    const $content = this.$ui.find(".kiosk-pane-content");
    $content.addClass("hidden");
    const $spinner = KIOSK_UI_CONTROLLER.showSpinner(this.$ui.find(".kiosk-center-pane"));
		KIOSK_CONTROLLER.loadOrder(params)
      .then(callback)
      .finally(() => {
        $spinner.remove();
        $content.removeClass("hidden");
      }
      );
  }
  
  _orderInfo() {
    this.transactionController.jumpToStep("ORDER-INFO");
  }
  
  _changePerformance() {
    this.transactionController.jumpToStep("CHANGE-PERFORMANCE");
  }
}