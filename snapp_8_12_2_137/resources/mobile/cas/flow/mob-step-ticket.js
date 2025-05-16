//# sourceURL=mob-step-ticket.js

$(document).ready(function() {
  
  window.StepTicket = {
    // Methods
    "execute": execute,
    "revert": revert
  };

  
  function execute(params) {
    return new Promise(function (resolve, reject) {
        resolve();
    });
  }
  
  function revert() {
    return new Promise(function (resolve, reject) {
        resolve();
    });
  }
  
});