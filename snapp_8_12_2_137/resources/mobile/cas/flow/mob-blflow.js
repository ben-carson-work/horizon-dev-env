//# sourceURL=mob-blflow.js

$(document).ready(function() {
  
  window.BLFlow = {
    // Methods
    "startCheckOut": startCheckOut
  };
  
  var steps = [
    {
      "Name": "step-portfolio",
      "Handler": StepPortfolio
    },
    {
      "Name": "step-payment",
      "Handler": StepPayment,
      "Params": {
        "Refund": false
      }
    },
    {
      "Name": "step-ticket",
      "Handler": StepTicket
    },
    {
      "Name": "step-refund",
      "Handler": StepPayment,
      "Params": {
        "Refund": true
      }
    },
    {
      "Name": "step-upload",
      "Handler": StepUpload
    }
  ];
  
  var activeIndex = null;

  
  function startCheckOut() {
    setActiveStep(0, true);
  }
  
  function checkOutFinished(success) {
    activeIndex = null;
    UIMob.setActiveTabMain(PKG_CAS + ".catalog");
    if (success === true)
      BLCart.startNewSale();
  }
  
  function setActiveStep(newIndex, forward) {
    if ((newIndex < 0) || (newIndex >= steps.length))
      checkOutFinished(forward);
    else if (newIndex != activeIndex) {
      if (activeIndex != null)
        steps[activeIndex].Handler.Active = false;
      
      activeIndex = newIndex;
      
      var step = steps[newIndex];
      step.Handler.Active = true;
      
      var fnc = (forward === true) ? step.Handler.execute : step.Handler.revert;
      
      fnc(step.Params)
        .then(function() {
          var delta = forward ? +1 : -1;
          setActiveStep(activeIndex + delta, forward);
        })
        .catch(function(error) {
          if (error) {
            console.error(error);
            UIMob.showMessage(itl("@Common.Warning"), error.message, [itl("@Common.Ok")]);
          }
          else
            setActiveStep(activeIndex - 1, false);
        });
    }
  }

});