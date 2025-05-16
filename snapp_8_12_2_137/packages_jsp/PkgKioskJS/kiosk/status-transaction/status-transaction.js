class StatusTransactionController extends KioskStatusController {
  constructor() {
    super();
    this.$steps = $(".transaction-step");
    this.paymentInfo = {};
    this.upsellOptions = null;
    
    setTimeout(() => {
      this.displayController = $("#shopcart-display").data("controller");
      this.displayController.$back.click(() => this._getActiveStepController().backClick());
      this.displayController.$next.click(() => this._getActiveStepController().nextClick());
    }, 0); 
  }
  
  activate() {
    this.$steps.removeClass("active");
    this.stepNext();
  }
  
  setActiveStep(stepCode) {
    let $oldStep = $(".transaction-step.active");
    if ($oldStep.length > 0) {
      let oldStepController = this._getStepController($oldStep);
      $oldStep.removeClass("active");    
      oldStepController.deactivate();
    }
    
    let $newStep = $(".transaction-step[data-step-code='" + stepCode + "']");
    let newStepController = this._getStepController($newStep);
    let newStepParams = newStepController.params;
    newStepController.activate();
    $("#status-transaction").setClass("show-shopcart-display", newStepParams.showShopcartDisplay !== false);
    $newStep.addClass("active");    
  }
  
  startCheckout() {
    KIOSK_CONTROLLER.startCheckout(this.paymentInfo)
        .catch((err) => {
          console.error(err);
          let errorParams = {
            title: "Failed to process order",
            error: err
          }          
          KIOSK_UI_CONTROLLER.showError(errorParams);
          this.stepBack();
        });
  }
  
  _getStepController($step) {
    let result = $step.data("controller");
    if (result == null)
      throw new Error("Step '" + $step.attr("data-step-code") + "' does not have controller class");
    return result;
  }
  
  _findActiveStepIndex() {
    for (let i=0; i<this.$steps.length; i++) {
      let $step = $(this.$steps[i]);
      if ($step.is(".active"))
        return i;
    }
    return -1; 
  }
  
  _getActiveStepController() {
    let index = this._findActiveStepIndex();
    if (index < 0)
      throw "There is not active transaction step";
    return $(this.$steps[index]).data("controller");
  }
  
  _activateFollowingStep(fromIndex, direction) {
    let delta = (direction == "BACKWARD") ? -1 : +1;
    fromIndex += delta;
    
    while ((fromIndex >= 0) && (fromIndex < this.$steps.length)) {
      let $step = $(this.$steps[fromIndex]);
      let step = $step.data("controller");
      if (!step.isStepNeeded(direction)) 
        fromIndex += delta;
      else {
        this.setActiveStep($step.attr("data-step-code"));
        break;
      }
    }
  }
  
  _getStepIndexByCode(stepCode) {
    for (let i=0; i<this.$steps.length; i++) {
      let $step = $(this.$steps[i]);
      if ($step.attr("data-step-code") == stepCode)
        return i;
    } 
    throw `There is no transaction step with code ${stepCode}`;
  }
  
  jumpToPayment() {
    let payselIndex = this._getStepIndexByCode("RECAP");
    this._activateFollowingStep(payselIndex, "FORWARD");
  }
  
  jumpToStep(stepCode) {
    let orderinfoIndex = this._getStepIndexByCode(stepCode);
    let $step = $(this.$steps[orderinfoIndex]);
    this.setActiveStep($step.attr("data-step-code"));
  }

  stepBack() {
    this._activateFollowingStep(this._findActiveStepIndex(), "BACKWARD");
  } 
  
  stepNext() {
    this._activateFollowingStep(this._findActiveStepIndex(), "FORWARD");
  } 
   
  mediaRead() {
    return $("#dlg-media-read").data("controller").execute();
  }
}

class StepController {
  /*
  params = {
    backText: string // shopcart-display's back button text
    nextText: string // shopcart-display's next button text
    showShopcartDisplay: boolean // ShopcartDisplay is hidden when this property is '=== false'
  }
   */
  constructor(params) {
    this.params = params || {};
    this.active = false;

    setTimeout(() => {
      this.transactionController = $(".status-screen[data-kiosk-status='TRANSACTION']").data("controller");
      this.displayController = $("#shopcart-display").data("controller");
    }, 0); 
 }
  
  activate() {
    this.active = true;
    this.updateDisplayButtons();
  }
  
  deactivate() {
    this.active = false;
  }
  
  updateDisplayButtons() {
    this.displayController.$back.removeClass("disabled");
    this.displayController.$next.removeClass("disabled");
  }
  
  backClick() {
    this.transactionController.stepBack();
  }
  
  nextClick() {
    this.transactionController.stepNext();
  }
  
  isStepNeeded(direction) {
    return true;
  }
}