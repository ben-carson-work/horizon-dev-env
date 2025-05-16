UIMob.init("account-edit", function($view, params) {
  var account = params.Account;
  var cats = null;
  var $maskedit = $view.find(".maskedit-container");
  var $prefCat = $view.find("#pref-item-category"); 
  var $prefSec =$view.find("#pref-item-security");
  var $btnSave = $view.find(".btn-toolbar-save");

  $(document).von($view, "AccountChange", onAccountChange);
  $view.find(".tab-header-title-top").text(account.DisplayName);
  $view.find(".btn-toolbar-back").click(onBackClick);
  $btnSave.click(onSaveClick);
  
  var $prefEditContainer = $view.find(".pref-edit-container");
  $prefEditContainer.on(EVENT_PrefChange, onPrefChange);

  $prefCat.find(".pref-item-value").text(account.CategoryRecursiveName);
  $prefCat.attr("data-itemid", account.CategoryId);
  $prefCat.click(onPrefCategoryClick);
  
  $prefSec.click(onPrefSecurityClick);
  
  UIMaskEdit.init({
    "Container": $maskedit,
    "CategoryId": account.CategoryId,
    "MetaDataList": account.MetaDataList
  });

  function onAccountChange(event, newAccount) {
    account = newAccount;
  }
  
  function onPrefChange() {
    $view.find(".btn-toolbar-save").removeClass("disabled");
  }

  function onPrefCategoryClick() {
    if (cats != null) 
      showCategoryList();
    else {
      UIMob.showWaitGlass();
      snpAPI("Category", "LoadEntCategory", {
        "CategoryId": rootCategoryId_Person
      }).finally(function() {
        UIMob.hideWaitGlass();
      }).then(function(ansDO) {
        cats = recursiveFillCategoryList(ansDO.Category, null);
        showCategoryList();
      });
    }
  }
  
  function onPrefSecurityClick() {
    UIMob.tabSlideView({
      container: $view.closest(".tab-content"),
      packageName: PKG_CAS,
      viewName: "account-security",
      params: {
        "Account": account
      }
    });
  }

  function onSaveClick() {
    if (!$btnSave.is(".disabled")) {
      var list = UIMaskEdit.getMetaData($maskedit);
      if (list) {
        account.CategoryId = $prefCat.attr("data-itemid");
        account.MetaDataList = list;
        
        UIMob.showWaitGlass();
        snpAPI("Account", "SaveAccount", account)
        .finally(function() {
          UIMob.hideWaitGlass();
        })
        .then(function(ansDO) {
          $(document).trigger("AccountChange", ansDO);
          UIMob.tabNavBack($view.closest(".mob-view").parent());
        });
      }
    }
  }

  function onBackClick() {
    if (!UIMob.isPrefChanged($prefEditContainer)) 
      UIMob.tabNavBack($view.closest(".tab-content"));
    else {
      UIMob.showMessage("SnApp", itl("@Common.SaveChangeConfirm"), [itl("@Common.Yes"), itl("@Common.No")], function(index) {
        if (index == 0)
          onSaveClick();
        else
          UIMob.tabNavBack($view.closest(".tab-content"));
      });
    }
  }

  function showCategoryList() {
    UIMob.showPrefList({
      "PrefItem": $prefCat,
      "OptionList": cats,
      "onClose": function() {
        UIMaskEdit.setCategoryId($maskedit, $prefCat.attr("data-itemid"));
      }
    });
  }
  
  function recursiveFillCategoryList(node, path) {
    if (path == null)
      path = "";
    else {
      if (path.length != "")
        path += " " + CHAR_RAQUO + " ";
      path += node.CategoryName;
    }
    
    var list = [];
    list.push({
      "ItemId": node.CategoryId,
      "ItemName": path
    });
    
    if (node.CategoryList) {
      for (var i=0; i<node.CategoryList.length; i++) {
        var child = node.CategoryList[i];
        Array.prototype.push.apply(list, recursiveFillCategoryList(child, path));
      }
    }
    
    return list;
  }
});