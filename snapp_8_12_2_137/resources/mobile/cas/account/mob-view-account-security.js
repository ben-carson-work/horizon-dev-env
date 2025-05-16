/**
 * params = {
 *   Account: DOAccount
 * }
 */
UIMob.init("account-security", function($view, params) {
  var account = params.Account || {};
  var accountLogin = account.AccountLogin || {};
  var snpRoles = [];
  var b2bRoles = [];
  
  $view.find(".tab-header-title-top").text(account.DisplayName);
  $view.find(".btn-toolbar-back").click(onBackClick);
  $view.find(".btn-toolbar-save").click(onSaveClick);
  
  var $prefEditContainer = $view.find(".pref-edit-container");
  $prefEditContainer.on(EVENT_PrefChange, onPrefChange);

  var $prefUserName = $view.find("#pref-item-username");
  var $prefEmail = $view.find("#pref-item-email");
  var $prefRoles = $view.find("#pref-item-roles").click(onRolesClick);
  var $prefStatus = $view.find("#pref-item-status").click(onStatusClick);
  var $prefChangePwd = $view.find("#pref-item-changepwd").click(onChangePwdClick);

  var $txtUserName = $("<input type='text' class='pref-value-text'/>").appendTo($prefUserName.find(".pref-item-value"));
  var $txtEmail = $("<input type='text' class='pref-value-text'/>").appendTo($prefEmail.find(".pref-item-value"));

  $txtUserName.val(accountLogin.UserName);
  $txtEmail.val(accountLogin.LoginEmail);
  
  $view.find("#pref-item-last-login .pref-item-value").text(accountLogin.LastLoginDateTime ? formatShortDateTimeFromXML(accountLogin.LastLoginDateTime) : itl("@Account.NeverLoggedIn"));
  $view.find("#pref-item-pwd-change .pref-item-value").text(formatShortDateFromXML(accountLogin.PasswordChangeDate));
  
  var $prefSNP = $view.find("#pref-item-platform-snp").setClass("selected", accountLogin.LoginSNP === true).click(onPlatformSNP_Click);
  var $prefB2B = $view.find("#pref-item-platform-b2b").setClass("selected", accountLogin.LoginB2B === true).click(onPlatformB2B_Click);
  var $prefB2C = $view.find("#pref-item-platform-b2c").setClass("selected", accountLogin.LoginB2C === true).click(onPlatformB2C_Click);
  
  renderStatus();
  initRoles();
  
  
  function initRoles() {
    loadRoles(LkSN.RoleType.Operator.code).then(function(list) {
      snpRoles = list;
      loadRoles(LkSN.RoleType.B2BAgent.code).then(function(list) {
        b2bRoles = list;
        
        var ids = (accountLogin.RoleIDs || "").split(",");
        var captions = [];
        for (var i=0; i<ids.length; i++)
          captions.push(getRoleName(ids[i]));

        $prefRoles.attr("data-itemid", accountLogin.RoleIDs);
        $prefRoles.find(".pref-item-value").text(captions.join(", "));
      });
    });
  }
  
  function renderStatus() {
    var statusColor = (accountLogin.LoginStatus == LkSN.LoginStatus.Active.code) ? "green" : "orange";
    $prefStatus.find(".pref-item-value").css("color", "var(--base-" + statusColor + "-color)").text(getLookupDesc(LkSN.LoginStatus, accountLogin.LoginStatus));
  }
  
  function resetRoles() {
    $prefRoles.removeAttr("data-itemid");
    $prefRoles.find(".pref-item-value").empty();
  }
  
  function getRoleName(id) {
    for (var i=0; i<snpRoles.length; i++)
      if (snpRoles[i].ItemId == id)
        return snpRoles[i].ItemName;
    
    for (var i=0; i<b2bRoles.length; i++)
      if (b2bRoles[i].ItemId == id)
        return b2bRoles[i].ItemName;
    
    return null;
  }
  
  function onPlatformSNP_Click() {
    $prefSNP.toggleClass("selected");
    if ($prefSNP.is(".selected") && $prefB2B.is(".selected")) {
      $prefB2B.removeClass("selected");
      resetRoles();
    }
    UIMob.prefItemChanged($prefSNP);
  }
  
  function onPlatformB2B_Click() {
    $prefB2B.toggleClass("selected");
    if ($prefB2B.is(".selected") && $prefSNP.is(".selected")) {
      $prefSNP.removeClass("selected");
      resetRoles();
    }
    UIMob.prefItemChanged($prefB2B);
  }
  
  function onPlatformB2C_Click() {
    $prefB2C.toggleClass("selected");
    UIMob.prefItemChanged($prefB2C);
  }
  
  function onRolesClick() {
    var list = snpRoles;
    var roleType = LkSN.RoleType.Operator.code;
    if ($prefB2B.is(".selected")) {
      roleType = LkSN.RoleType.B2BAgent.code;
      list = b2bRoles;
    }
    
    UIMob.showPrefList({
      "PrefItem": $prefRoles,
      "OptionList": list,
      "MultipleChoice": (roleType != LkSN.RoleType.B2BAgent.code)
    });
  }
  
  function onStatusClick() {
    var active = (accountLogin.LoginStatus == LkSN.LoginStatus.Active.code);
    UIMob.showMessage(itl("@Common.Status"), null, [itl(active ? "@Common.Block" : "@Common.Unblock"), itl("@Common.Remove"), itl("@Common.Cancel")], function(index) {
      if (index == 0) 
        doChangeStatus(active ? LkSN.LoginStatus.Blocked.code : LkSN.LoginStatus.Active.code);
      else if (index == 1) {
        UIMob.showMessage(itl("@Common.ConfirmDelete"), null, [itl("@Common.Yes"), itl("@Common.No")], function(index) {
          if (index == 0)
            doRemove();
        })
      } 
    });
  }
  
  function onChangePwdClick() {
    alert("change pwd");
  }
  
  function loadRoles(roleType) {
    return new Promise(function(resolve, reject) {
      UIMob.showWaitGlass();
      snpAPI("CommonList", null, {
        "EntityType": LkSN.EntityType.Role.code,
        "Role": {
          "RoleType": roleType
        }
      }).finally(function() {
        UIMob.hideWaitGlass();
      }).then(function(ansDO) {
        resolve(ansDO.Answer.ItemList || []);
      });    
    });
  }
  
  function onPrefChange() {
    $view.find(".btn-toolbar-save").removeClass("disabled");
  }
  
  function doNavBack() {
    UIMob.tabNavBack($view.closest(".tab-content"));
  }

  function onBackClick() {
    if (!UIMob.isPrefChanged($prefEditContainer)) 
      doNavBack();
    else {
      UIMob.showMessage("SnApp", itl("@Common.SaveChangeConfirm"), [itl("@Common.Yes"), itl("@Common.No")], function(index) {
        if (index == 0)
          onSaveClick();
        else
          doNavBack();
      });
    }
  }
  
  function onSaveClick() {
    if (!$(this).is(".disabled")) {
      UIMob.showWaitGlass();
      snpAPI("Account", "SaveAccount", {
        "AccountId": account.AccountId,
        "AccountLogin": {
          "AccountId": account.AccountId,
          "UserName": $txtUserName.val(),
          "LoginEmail": $txtEmail.val(),
          "LoginSNP": $prefSNP.is(".selected"),
          "LoginB2B": $prefB2B.is(".selected"),
          "LoginB2C": $prefB2C.is(".selected"),
          "RoleIDs": $prefB2B.is(".selected") ? null : $prefRoles.attr("data-itemid"),
          "B2B_RoleId": $prefSNP.is(".selected") ? null : $prefRoles.attr("data-itemid")
        }
      }).finally(function() {
        UIMob.hideWaitGlass();
      }).then(function(ansDO) {
        $(document).trigger("AccountChange", ansDO);
        doNavBack();
      });
    }
  }
  
  function doChangeStatus(newStatus) {
    UIMob.showWaitGlass();
    snpAPI("Account", "ChangeLoginStatus", {
	  "LocateAccount": {
        "AccountId": account.AccountId
	  },
      "LoginStatus": newStatus
    }).finally(function() {
      UIMob.hideWaitGlass();
    }).then(function(ansDO) {
      accountLogin.LoginStatus = newStatus;
      renderStatus();
    });
  }
  
  function doRemove() {
    UIMob.showWaitGlass();
    snpAPI("Account", "DeleteLogin", {
      "AccountId": account.AccountId
    }).finally(function() {
      UIMob.hideWaitGlass();
    }).then(function(ansDO) {
      // TODO: strip accountLogin info from account and trigger AccountChange
      doNavBack();
    });
  }
});
