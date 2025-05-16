UIMob.init("info", function($view, params) {
  var $user = $view.find("#pref-item-user");
  $user.find(".pref-item-value").text(BLMob.User.AccountName);
  $user.click(doLogout);

  $view.find("#pref-item-changeapp").click(doChangeApp);
  
  $view.find("#pref-item-location").find(".pref-item-value").text(BLMob.Workstation.LocationName);
  $view.find("#pref-item-oparea").find(".pref-item-value").text(BLMob.Workstation.OpAreaName);
  
  var $wks = $view.find("#pref-item-wks");
  $wks.find(".pref-item-value").text(BLMob.Workstation.WorkstationName);
  $wks.click(doChangeWorkstation);
  
  $view.find("#pref-item-deviceinfo").click(function() {
    UIMob.tabSlideView({
      container: $view.closest(".tab-content"),
      packageName: PKG_COMMON,
      viewName: "info-device",
      dir: "R2L"
    });
  });

  if (BLMob.AccessPoint) {
    $view.find("#pref-item-gate").attr("data-itemid", BLMob.AccessPoint.AptOperAreaAccountId).find(".pref-item-value").text(BLMob.AccessPoint.AptOperAreaDisplayName);
    $view.find("#pref-item-apt").find(".pref-item-value").text(BLMob.AccessPoint.AptName);
  }
  else 
    $view.find(".pref-item.controlled-apt").remove();
    

  function doLogout() {
    UIMob.showMessage(itl("@Common.User"), BLMob.User.AccountName, [itl("@Common.Logout"), itl("@Common.Cancel")], function(index) {
      if (index == 0) 
        BLMob.logout();
    });
  }
  
  function doChangeApp() {
    UIMob.showMessage(itl("Change APP"), itl("@Common.AreYouSure"), [itl("@Common.Yes"), itl("@Common.Cancel")], function(index) {
      if (index == 0) 
        BLMob.changeApp();
    });
  }
  
  function doChangeWorkstation() {
    UIMob.showMessage(itl("Change workstation"), itl("@Common.AreYouSure"), [itl("@Common.Yes"), itl("@Common.Cancel")], function(index) {
      if (index == 0) 
        BLMob.changeWorkstation();
    });
  }
  
  $view.find("#pref-item-gate").click(function() {
    snpAPI("CommonList", null, {
      "EntityType":LkSN.EntityType.OperatingArea.code,
      "OpArea": {
        "LocationId": BLMob.Workstation.LocationId
      }
    })
    .then(function(ansDO) {
      var options = ((ansDO.Answer || {}).ItemList || []);
      UIMob.showPrefList({
        "PrefItem": "#pref-item-gate",
        "OptionList": options,
        "onItemClick": function(item, callback) {
          UIMob.showWaitGlass();

          snpAPI("Workstation", "ChangeOperatingArea", {
            WorkstationId: BLMob.AccessPoint.AccessPointId,
            OperatingAreaId: item.attr("data-itemid")
          })
          .finally(function() {
            UIMob.hideWaitGlass();
          })
          .then(function(ansDO) {
            callback(item);
          });
        }
      });
    });
    
  });  
});
