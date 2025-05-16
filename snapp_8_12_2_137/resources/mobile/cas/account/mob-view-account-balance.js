/**
 * params = {
 *   Account: DOAccount
 * }
 */
UIMob.init("account-balance", function($view, params) {
  var account = params.Account || {};

  $view.find(".tab-header-title-top").text(account.DisplayName);

  UIMob.showWaitGlass();
  snpAPI("Portfolio", "GetPortfolioBalance", {
    "AccountId": account.AccountId
  }).finally(function() {
    UIMob.hideWaitGlass();
  }).then(function(ansDO) {
    var list = ansDO.SlotList || [];
    var $list = $view.find(".tab-body").empty();
    for (var i=0; i<list.length; i++) {
      var slot = list[i];
      var $slot = $view.find(".templates .slot-item").clone().appendTo($list);
      var wallet = (slot.MembershipPointCode == "#WALLET");
      $slot.find(".mob-widget-header").text(slot.MembershipPointName);
      $slot.find(".pref-item-balance .pref-item-value").text(wallet ? formatCurr(slot.SlotBalance) : slot.SlotBalance);
      $slot.find(".pref-item-credit .pref-item-value").text(wallet ? formatCurr(slot.SlotCreditLimit) : slot.SlotCreditLimit);
      $slot.find(".pref-item-expire .pref-item-value").text((slot.ExpireDate) ? formatShortDateFromXML(slot.ExpireDate) : itl("@Common.Never"));
      
      $slot.find(".pref-item-trn").click(function() {
        UIMob.showMessage("TBI");
      });
    }
  });
});