//# sourceURL=mob-step-upload.js

$(document).ready(function() {
  
  window.StepUpload = {
    // Methods
    "execute": execute,
    "revert": revert,
    "stepConfirm": stepConfirm
  };
  
  var promises = [];

  
  function execute(params) {
    return new Promise(function (resolve, reject) {
      promises.push({"resolve":resolve, "reject":reject});
      UIMob.tabSlideView({
        "container": "#mobile-main",
        "packageName": PKG_CAS,
        "viewName": "step-upload"
      });
    });
  }
  
  function revert() {
    return new Promise(function (resolve, reject) {
      resolve();
    });
  }
  
  function stepConfirm() {
    UIMob.tabNavBack("#mobile-main");
    promises.pop().resolve();
  }
});