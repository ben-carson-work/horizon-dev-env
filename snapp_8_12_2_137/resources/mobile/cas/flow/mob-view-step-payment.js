UIMob.init("step-payment", function($view, params) {

  var $template = $view.find(".templates .paymethod");
  var editAmount = "";
  renderRecap();
  renderPayMethods();
  renderPayCuts();
  initCalculator();
  refreshToolbar();
  
  $(document).von($view, "PaymentDataChange", onPaymentDataChange);
  $(document).von($view, "keydown", onDocumentKeyDown);
  
  $view.find(".btn-toolbar-confirm").click(onBtnConfirmClick);
  $view.find(".btn-toolbar-cancel").click(onBtnCancelClick);
  
  function renderPayMethods() {
    var list = StepPayment.getPaymentMethods();
    for (var i=0; i<list.length; i++) {
      var plugin = list[i];
      var paymentType = plugin.PaymentMethodDetails.PaymentType;
      var $item = $template.clone().appendTo($view.find(".paymethod-list"));
      
      $item.data("plugin", plugin);
      $item.attr("data-pluginid", plugin.PluginId);
      $item.attr("data-paymentype", paymentType);
      $item.find(".paymethod-name").text(plugin.PluginName);
      
      var icon = plugin.PaymentMethodDetails.IconName || plugin.IconName;
      if (icon)
        $item.find(".paymethod-icon").css("background-image", "url(" + calcIconName(icon, 64) + ")");
      
      $item.click(onPayMethodClick);
    }
  }
  
  function renderRecap() {
    var pd = shopCart.Payments;
    $view.find(".pr-due .payment-recap-value").text(formatCurr(pd.Due));
    $view.find(".pr-tendered .payment-recap-value").text(formatCurr(pd.Tendered));
    $view.find(".pr-balance .payment-recap-value").text(formatCurr(pd.Balance));
    
    var good = StepPayment.isTenderedEnough();
    $view.find(".pr-balance").setClass("tendered-enough", good).setClass("tendered-short", !good);
    
    var splits = pd.SplitList || [];
    var $splits = $view.find(".tendered-list").empty();
    for (var i=0; i<splits.length; i++) {
      var split = splits[i];
      var $split = $view.find(".templates .split").clone().appendTo($splits);
      $split.find(".split-name").text(split.PayMethodName); 
      $split.find(".split-amount").text(formatCurr(split.Amount)); 
    }
    
    editAmount = "";
    $view.find(".split-input").setClass("hidden", good);
    $view.find(".split-input-amount-value").empty();
  }
  
  function renderPayCuts() {
    var $template = $view.find(".templates .paycut");
    var $list = $view.find(".paycut-list").empty();
    var list = BLMob.MainCurrency.CurrencyDetailList || [];
    
    for (var i=0; i<list.length; i++) {
      var curr = list[i]; 
      var $curr = $template.clone().appendTo($list);
      $curr.attr("data-amount", curr.Amount);
      $curr.find(".paycut-amount").text(formatCurr(curr.Amount, mainCurrencyFormat, ""));
      $curr.find(".paycut-icon").css("background-image", "url(" + calcIconName(curr.FundCategoryIconName, 64) + ")");
      
      $curr.click(function() {
        var cutAmount = strToFloatDef($(this).attr("data-amount"), 0);
        editAmount = (strToFloatDef(editAmount, 0) + cutAmount).toString().replace(".", decimalSeparator);
        $view.find(".split-input-amount-value").text(editAmount);
      });
    }
  }
  
  function initCalculator() {
    var $calc = $view.find(".calculator"); 
    $calc.find(".decimal-separator").text(decimalSeparator);
    
    $calc.find("td").on(MOUSE_DOWN_EVENT, function() {
      var $td = $(this);
      var keyCode = parseInt($td.attr("data-keyCode"));
      if (keyCode) 
        handleKeyPress(keyCode, $td.attr("data-key"));
    });
  }
  
  function refreshToolbar() {
    var good = StepPayment.isTenderedEnough();
    $view.find(".btn-toolbar-confirm").setClass("disabled", !good);
    $view.find(".btn-toolbar-cancel").setClass("disabled", !good);
    
    var $btns = $view.find(".paymethod"); 
    $btns.setClass("tendered-enough", good);
    $btns.addClass("disabled");
    $btns.not(".tendered-enough").removeClass("disabled");
  }
  
  function calcNewSplitAmount() {
    if (editAmount == "")
      return Math.abs(shopCart.Payments.Balance);
    else {
      var amount = parseFloat(editAmount.replace(decimalSeparator, "."));
      if (isNaN(amount)) {
        UIMob.showMessage(itl("@Common.InvalidAmount"), editAmount);
        return false;
      }
      return amount;
    }
  }
  
  function handleKeyPress(code, char) {
    if (code == KEY_ENTER) {
      var amount = calcNewSplitAmount();
      if (amount)
        StepPayment.addSplit(BLMob.ChangePlugin, amount);
    }
    else {
      if (code == KEY_BACKSPACE) {
        if (editAmount.length > 0)
          editAmount = editAmount.substr(0, editAmount.length - 1);
      }
      else if (code == KEY_DELETE) 
        editAmount = "";
      else if (code == KEY_NUM_DEC) 
        editAmount += decimalSeparator;
      else if (((code >= KEY_0) && (code <= KEY_9)) || ((code >= KEY_NUM_0) && (code <= KEY_NUM_9)) || (char === ".")) 
        editAmount += char;
      
      $view.find(".split-input-amount-value").text(editAmount);
    }
  }
  
  function onDocumentKeyDown(e, x) {
    if ((StepPayment.Active === true) && !$(":focus").is("input")) 
      handleKeyPress(e.keyCode, e.key);
  }

  function onPayMethodClick() {
    var $btn = $(this);
    if (!$btn.is(".disabled")) {
      var amount = calcNewSplitAmount();
      if (amount)
        StepPayment.addSplit($btn.data("plugin"), amount);
    }
  }

  function onPaymentDataChange(event, paymentData) {
    renderRecap();
    refreshToolbar();
  }
  
  function onBtnConfirmClick() {
    if (!$(this).is(".disabled"))
      StepPayment.stepConfirm();
  }
  
  function onBtnCancelClick() {
    if (!$(this).is(".disabled")) 
      StepPayment.stepCancel();
  }

});