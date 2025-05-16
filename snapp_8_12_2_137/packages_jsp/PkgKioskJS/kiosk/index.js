class KioskUIController {
  
  /*
  params = {
    apiUrl: string //url of the SnApp API
    workstation: DOWorkstation // if null the WorkstationId is mandatory
    workstationId: string // id of the workstation (Mandatory if the "workstation" parameter is null)
    userAccountId: string // id of the user (optional),
    kiosk: DOKioskUI
  }
  */
  constructor(params) {
    this.initialized = false;
    this.kiosk = params.kiosk || {"TextList":[]};
    this.mainenanceActivationCounter = 0;
    window.addEventListener("unhandledrejection", event => this._onUnhandledRejection(event));

    this._initUIControllers();
    $(".modal").appendTo("body");
		$(document).on("click", ".kiosk-header-licensee", () => {
			clearTimeout(this.mainenanceTimeout);
			this.mainenanceActivationCounter += 1;

			if (this.mainenanceActivationCounter < 5)
				this.mainenanceTimeout = setTimeout(() => this.mainenanceActivationCounter = 0, 1000);

			else {
				this.mainenanceActivationCounter = 0;
				if (KIOSK_CONTROLLER.status === KIOSK_STATUS.MAINTENANCE)
					KIOSK_CONTROLLER.exitMaintenanceMode();
				else {
					let loginParams = {};
					loginParams.pin = this.kiosk.PIN;					
					this.showPinLogin(loginParams);
				}
			}
		});

    KIOSK_CONTROLLER.init({
      "apiUrl": params.apiUrl,
      "workstation": params.workstation,
      "workstationId": params.workstationId,
      "userAccountId": params.userAccountId,
      "printOptionSelection": true,
      "onStatusChanged": data => this._onStatusChanged(data),
      "inactivityTimeOutMSec": 30000,
	  "retryFailedPayment": true,
	  "onShopCartChanged": shopCart => console.log("ShopCart changed!", shopCart)
    });
    
    this.setLangISO((this.kiosk.TextList.length == 0) ? "en" : this.kiosk.TextList[0].LangISO); 
  }
  
  _initUIControllers() {
    $("[data-controller]").each(function(index, elem) {
      let $screen = $(elem);
      let controllerClassName = $screen.attr("data-controller");
      if (controllerClassName) {
        let controllerClass = eval(controllerClassName);
        let controller = new controllerClass();
        $screen.data("controller", controller);
        controller.$ui = $screen;
      }
    });
  }
  
  _onUnhandledRejection(event) {
    if (event.reason) 
      this.showError({"error":event.reason});
  }

  _onStatusChanged(data) {
    SNP_LOGGER.info(null, null, "KIOSK STATUS: " + data.status);
    
    let $oldContainer = $(".status-screen.active");
    let oldController = $oldContainer.data("controller");
    
    $oldContainer.removeClass("active");
    if (oldController)
      oldController.deactivate();
      
    let $newContainer = $(".status-screen[data-kiosk-status='" + data.status + "']");
    let newController = $newContainer.data("controller");

    $newContainer.addClass("active");
    if (newController)
      newController.activate();

    if ((data.status == "IDLE") && (this.initialized === false)) {
      $(document).trigger("kiosk-init");
      this.initialized = true;
    } 
  }
  
  showConfirm(params) {
    return $("#dlg-confirm").data("controller").execute(params);
  }
  
  showInfo(params) {
    return $("#dlg-info").data("controller").execute(params);
  }
  
  showError(params) {
    return $("#dlg-error").data("controller").execute(params);
  }
  
  showInput(params) {
    return $("#dlg-input").data("controller").execute(params);
  }
  
  showPinLogin(params) {
    return $("#dlg-pin-login").data("controller").execute(params);
  }
  
  showSpinner($container) {
    return $("#kiosk-templates .kiosk-spinner").clone().removeClass("show-loading").appendTo($container);
  }
  
  setLangISO(langISO) {
    this._kioskText = {};
    for (const kt of this.kiosk.TextList) {
      if (kt.LangISO == langISO) {
        this._kioskText = kt;
        break;
      }
    }
    
    this._updateITL();
  }
  
  getConfigLangTranslation(list, defaultText) {
    let langISO = this._kioskText.LangISO;
    if (langISO) {
      for (const item of (list || [])) {
        if (item.LangISO == langISO)
          return item.Translation;
      }
    }
    
    return defaultText;
  }
  
  getRichDescTranslation(list) {
    let langISO = this._kioskText.LangISO;
    list = list || [];
    
    if (langISO) {
      for (const item of (list || [])) {
        if (item.LangISO == langISO)
          return item.Description;
      }
    }
    
    if (list.length > 0)
      return list[0].Description;
    
    return null;
  }
  
  _updateITL() {
    let kioskUI = this;
    $("[data-itl]").each(function() {
      let $elem = $(this);
      let key = $elem.attr("data-itl");
      $elem.text(kioskUI.itl(key));
    });
  }
  
  itl(key) {
    key = key || "";
    if (key.charAt(0) == "@")
      key = key.substr(1, key.length - 1);
    
    let current = this._kioskText;
    let splits = key.split(".");
    for (const split of splits) {
      if (current == null)
        break; 
      
      current = current[split];
    } 
    
    return current;
  }

}

function snappAPI() {
  return KIOSK_CONTROLLER.snappAPI;
}