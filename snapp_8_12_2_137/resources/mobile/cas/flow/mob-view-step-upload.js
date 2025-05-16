UIMob.init("step-upload", function($view, params) {
  
  $view.find(".btn-toolbar-confirm").click(onConfirmBtnClick);
  
  var $spinner = UIMob.createSpinnerClone().appendTo($view.find(".tab-body"));
  snpAPI("Transaction", "PostTransaction", {
    ShopCartId: shopCart.ShopCartId,
    ReturnFullTransaction: true
  })
  .finally(function() {
    $spinner.remove();
    $view.find(".tab-header-title").text(itl("@Sale.TransactionPosted") + "!");
  })
  .then(function(ansDO) {
    renderRecap(ansDO.PostTransactionRecap, ansDO.FullTransaction);
  })/*
  .catch(function(error) {
    
  })*/;


  
  function renderRecap(recap, full) {
    $view.find(".trn-recap-pnr .trn-recap-value").text(full.SaleCode);
    $view.find(".trn-recap-datetime .trn-recap-value").text(formatShortDateTimeFromXML(full.TransactionDateTime));
    $view.find(".trn-recap-trntype .trn-recap-value").text(getLookupDesc(LkSN.TransactionType, full.TransactionType));

    $view.find(".trn-recap-total .trn-recap-value").text(formatCurr(full.TotalAmount));
    $view.find(".trn-recap-due .trn-recap-value").text(formatCurr(shopCart.Payments.Due));
    $view.find(".trn-recap-tendered .trn-recap-value").text(formatCurr(shopCart.Payments.Tendered));
    $view.find(".trn-recap-balance .trn-recap-value").text(formatCurr(shopCart.Payments.Balance));
    $view.find(".trn-recap").removeClass("hidden");
  }

  function onConfirmBtnClick() {
    StepUpload.stepConfirm();
  }
  

  
});