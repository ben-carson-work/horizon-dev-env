UIMob.init("medialookup", function($view, params) {
  var media = params.MediaRef || {};
  var account = null;
  var actions = [];
  $view.find(".btn-toolbar-menu").click(onMenuClick);
  
  var $spinner = UIMob.createSpinnerClone().prependTo($view.find(".tab-body"));
  snpAPI("Account", "LoadShopCartAccount", {
    "MediaId": params.MediaId || params.MediaRef.MediaId,
    "ShopCartId": shopCart.ShopCartId
  }).finally(function() {
    $spinner.remove();
    $view.find(".lookup-content").removeClass("hidden");
  }).then(function(ansDO) {
    media = ansDO.MediaRef;
    account = ansDO.Account.AccountId;
    actions = ansDO.ActionList || [];
    
    for (var i=0; i<actions.length; i++)
      actions[i].execute = doActionTBI;
    
    getAction("ticket-void").execute = doTicketVoid;
    
    renderMedia(media);
  });
  
  function getAction(actionName) {
    for (var i=0; i<actions.length; i++)
      if (actions[i].Name == actionName)
        return actions[i];
    throw "Unable to find action: '" + actionName + "'";
  }

  function renderMedia(media) {
    var mediaStatusClass = (media.MediaStatus == LkSN.TicketStatus.Active.code) ? "good-status" : (media.MediaStatus < goodTicketLimit ? "warn-status" : "bad-status");
    var ticketStatusClass = (media.MainTicketStatus == LkSN.TicketStatus.Active.code) ? "good-status" : (media.MainTicketStatus < goodTicketLimit ? "warn-status" : "bad-status");

    if (media.AccountProfilePictureId)
      $view.find(".account-pic").css("background-image", "url(" + calcRepositoryURL(media.AccountProfilePictureId, "small") + ")");
    $view.find(".account-name").text(media.AccountName);
    $view.find(".wallet-balance").html(formatCurr(media.WalletBalance));
    $view.find(".wallet-credit").html(formatCurr(media.WalletCreditLimit));
    $view.find(".wallet-expiration").text((media.WalletExpireDate) ? formatDate(media.WalletExpireDate, BLMob.Rights.ShortDateFormat) : "-"); 
    
    var $media = $view.find("#pref-item-media");
    $media.find(".pref-item-value").text(media.MediaCalcCode).addClass(mediaStatusClass);
    $media.attr("data-viewname", "medialookup-media").click(_onPrefClick);
    
    var $medias = $view.find("#pref-item-medias"); 
    $medias.find(".pref-item-value").html("<span class='badge'>" + media.PortfolioMediaCount + "</span>");
    $medias.attr("data-viewname", "medialookup-medias").click(_onPrefClick);
    
    var $usages = $view.find("#pref-item-usages");
    if ((media.PortfolioUsageCount || 0) > 0) {
      $usages.find(".pref-item-value").html("<span class='badge'>" + media.PortfolioUsageCount + "</span>");
      $usages.attr("data-viewname", "medialookup-usages").click(_onPrefClick);
    }
    else {
      $usages.find(".pref-item-value").text(itl("@Ticket.NotUsed"));
      $usages.removeClass("pref-item-arrow");
    }
    
    var $tickets = $view.find("#pref-item-tickets");
    if (media.TicketCount > 0) {
      var $value = $tickets.find(".pref-item-value").addClass(ticketStatusClass);
      $value.text(media.MainProductName);
      if (media.TicketCount > 1)
        $value.append("&nbsp;&nbsp;<span class='badge'>" + media.TicketCount + "</span>");
      $tickets.attr("data-viewname", "medialookup-tickets").click(_onPrefClick);
    }
    else
      $tickets.remove();
    
    
    function _onPrefClick() {
      UIMob.tabSlideView({
        container: $view.closest(".tab-content"),
        packageName: PKG_ADM,
        viewName: $(this).attr("data-viewname"),
        dir: "R2L",
        params: {
          MediaRef: media
        }
      });
    }
  }
  
  function onMenuClick() {
    UIMob.popupMenu({
      "Target": this,
      "Items": actions
    });
  }
  
  function doAddTicketToCart(ticketId, transactionType) {
    UIMob.showWaitGlass();
    BLCart.shopCartAPI("AddTicketToCart", {
      "TicketId": ticketId,
      "TransactionType": transactionType
    }).finally(function() {
      UIMob.hideWaitGlass();
    }).then(function() {
      UIMob.tabNavBack($view.closest(".tab-content"));
      UIMob.setActiveTabMain(PKG_CAS + ".shopcart");
    });
  }
  
  function doActionTBI(action) {
    UIMob.showMessage("TBI: " + action.Name);
  }
  
  function doTicketVoid(action) {
    if (media.TicketCount == 1) 
      doAddTicketToCart(media.MainTicketId, LkSN.TransactionType.TicketVoid.code);
    else if (media.TicketCount > 1) {
      UIMob.tabSlideView({
        container: $view.closest(".tab-content"),
        packageName: PKG_CAS,
        viewName: "ticketpickup",
        params: {
          PortfolioId: media.PortfolioId,
          callback: function(ticket) {
            doAddTicketToCart(ticket.TicketId, LkSN.TransactionType.TicketVoid.code);
          }
        }
      });
    }
  }
});
