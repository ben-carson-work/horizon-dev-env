UIMob.init("shopcart", function($view, params) {
  var $groupTemplate = $view.find(".templates .sc-group");
  var $itemTemplate = $view.find(".templates .sc-item");
  var netPrices = (BLMob.Rights.ShowNetPrices === true);

  BLCart.initCartDisplay($view.find(".cartdisplay-container"));
  $(document).von($view, "ShopCartChange", onShopCartChange);
  $view.find(".btn-toolbar-back").click(onBackClick);
  $view.find(".btn-toolbar-emptycart").click(onCartEmptyClick);
  $view.find(".btn-toolbar-checkout").click(onCheckOutClick);
  onShopCartChange();
  
  function onShopCartChange() {
    renderShopCart();
    refreshButtons();
  }
  
  function onBackClick() {
    if (!$(this).is(".disabled"))
      UIMob.setActiveTabMain(PKG_CAS + ".catalog");
  }

  function onCartEmptyClick() {
    if (!$(this).is(".disabled")) {
      UIMob.showMessage(itl("@Common.Confirm"), itl("@Common.EmptyShopCartConfirm"), [itl("@Common.Confirm"), itl("@Common.Cancel")], function(index) {
        if (index == 0)
          BLCart.emptyShopCart({"HoldReleaseIfNeeded":true});
      });
    }
  }
  
  function onCheckOutClick() {
    if (!$(this).is(".disabled"))
      BLFlow.startCheckOut();
  }
  
  function refreshButtons() {
    var empty = BLCart.isShopCartEmpty();
    $view.find(".btn-toolbar-emptycart").setClass("disabled", empty);
    $view.find(".btn-toolbar-checkout").setClass("disabled", empty);
  }
  
  function renderShopCart() {
    var transactionType = (shopCart.Transaction) ? (shopCart.Transaction.TransactionType || LkSN.TransactionType.Normal.code) : LkSN.TransactionType.Normal.code;
    $view.find("#view-shopcart").attr("data-transactiontype", transactionType);
    $view.find(".transaction-type").text(getLookupDesc(LkSN.TransactionType, transactionType));
    
    renderReservation();
    renderPrivilegeCard();
    
    var $groupList = $view.find(".sc-group-list").empty();
    if (shopCart.Items) {
      $(shopCart.Items).each(function(index, item) {
        var $group = getGroup($groupList, item.GroupingDesc);
        var $item = $itemTemplate.clone().appendTo($group.find(".sc-group-body"));   
        $item.find(".data-value-l1").text(item.ProductName);
        $item.find(".data-value-l2").text(item.ProductCode);
        $item.find(".data-value-r1").text(formatCurr(netPrices ? item.TotalNetFull : item.TotalGrossFull));
        $item.find(".data-value-r2").text(item.Quantity + " x " + formatCurr(netPrices ? item.UnitNetFull : item.UnitGrossFull));
      });
    }
  }
  
  function renderReservation() {
    var inres = shopCart.AccountId != null;
    $view.find("#view-shopcart").attr("data-reservation", inres);
    
    if (inres) {
      var res = shopCart.Reservation || {};
      var $dsp = $view.find(".resdisplay-container");
      var $res = $view.find(".reservation-section");

      $dsp.find(".order-pnr").text(res.SaleCode);
      $dsp.find(".owner-account").text(shopCart.AccountName);

      $res.find(".order-status").text(getLookupDesc(LkSN.SaleStatus, res.SaleStatus));
      $res.find(".sale-channel").text(shopCart.SaleChannelName);
    }
  }
  
  function renderPrivilegeCard() {
    var privcard = shopCart.MembershipTicket || {};
    var $privcard = $view.find(".privilege-card");

    $privcard.setClass("hidden", privcard.TicketId == null);
    
    if (privcard.TicketId != null) {
      var validity = itl("@Common.Unlimited");
      if (privcard.ValidDateFrom && privcard.ValidDateTo)
        validity = formatShortDateFromXML(privcard.ValidDateFrom) + " " + itl("@Common.To").toLowerCase() + " " + formatShortDateFromXML(privcard.ValidDateTo);
      else if (privcard.ValidDateFrom != null)
        validity = itl("@Common.From") + " " + formatShortDateFromXML(privcard.ValidDateFrom);
      else if (privcard.ValidDateTo != null)
        validity = itl("@Common.To") + " " + formatShortDateFromXML(privcard.ValidDateTo);

      $privcard.find(".product-name").text(privcard.ProductName);
      $privcard.find(".account-name").text(privcard.AccountName);
      $privcard.find(".ticket-code").text(privcard.TicketCode);
      $privcard.find(".ticket-validity").text(validity);
    }
  }
  
  function getGroup($groupList, text) {
    var $group = null;
    var $captions = $view.find(".sc-group-title-caption");
    for (var i=0; i<$captions.length; i++) {
      var $caption = $($captions[i]);
      if ($caption.text() == text) {
        $group = $caption.closest(".sc-group");
        break;
      }
    }
    
    if ($group == null) {
      $group = $groupTemplate.clone().appendTo($groupList);
      $group.find(".sc-group-title-caption").text(text)
    }
    
    return $group;
  }
});
