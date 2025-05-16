//# sourceURL=mob-adm-tab-specialprod-js.jsp

$(document).ready(function() {
  const LkSNUsageType_Entry = 1;
  const LkSNOperatorCmd_UseTicket = 1;
  const LkSNTicketUsageUserType_SpecialProduct = 10;

  var list = (apt.SpecialProductList || []);
  $(".tab-button[data-tabcode='specialprod']").setClass("hidden", list.length <= 0);
  
  for (const item of list) {
    var $item = $("#specialprod-templates .specialprod").clone().appendTo("#specialprod-main-tab-content .tab-body");
    var $pic = $item.find(".specialprod-pic");
    var bgURL = null;
    var bgSize = "cover";
    
    $item.click(_itemClick);
    $item.attr("data-productid", item.ProductId);
    $item.attr("data-productName", item.ProductName);
    $item.find(".specialprod-name").text(item.ProductName);
    $item.find(".specialprod-code").text(item.ProductCode);
    
    if (item.ProfilePictureId)
      bgURL = BASE_URL + "/repository?type=small&id=" + item.ProfilePictureId;
    else if (item.IconAlias)
      $pic.find(".fa").addClass("fa-" + item.IconAlias);
    else if (item.IconName) {
      bgURL = getIconURL(item.IconName, 48);
      bgSize = "60%";
    }
    
    $pic.css({
      "color": "#" + item.ForegroundColor,
      "background-color": "#" + item.BackgroundColor,
      "background-image": "url(" + bgURL + ")",
      "background-size": bgSize
    });
  }
  
  function _itemClick() {
    var productId = $(this).attr("data-productid");
    var productName = $(this).attr("data-productName");
    showMobileQueryDialog(itl("@Common.Confirm"), itl("@AccessPoint.ComfirmSpecialProductUsage", productName), [itl("@Common.Ok"), itl("@Common.Cancel")], function(idx) {
      if (idx == 0)
        _redeemSpecialProduct(productId);
    });
  }
  
  function _redeemSpecialProduct(productId) {
    var reqDO = {
      RedemptionPoint : {
        AccessPointId : apt.AccessPointId,
        UsageType : LkSNUsageType_Entry,
        OperatorCmd : LkSNOperatorCmd_UseTicket,
        TicketUsageUserType: LkSNTicketUsageUserType_SpecialProduct,
        UserAccountId: loggedUserAccountId
      },
      SpecialProductCode: productId,
      SkipBiometricCheck: true
    };
    
    showWaitGlass();
    vgsService("VALIDATE", reqDO, true, function(ansDO) {
      hideWaitGlass();
      var errorMsg = getVgsServiceError(ansDO);
      if (isUnauthorizedAnswer(ansDO))
        doLogout();
      else if (errorMsg != null)
        showIconMessage("warning", errorMsg);
      else {
        var ansBody = ansDO.Answer || {};
        showIconMessage((ansBody.ResultCode < 100) ? "success" : "warning", ansBody.OperatorMsg);
      }
    });
  }
});
