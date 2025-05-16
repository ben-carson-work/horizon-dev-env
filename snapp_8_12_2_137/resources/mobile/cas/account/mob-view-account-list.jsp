<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-account-list">

  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-new"><i class="fa fa-plus"></i></div>
    <div class="input-container"><input type="text" class="txt-fulltext"/></div>
    <div class="toolbar-button btn-toolbar-media"><i class="fa fa-barcode-scan"></i></div>
  </div>
  <div class="tab-body">
    <div class="scroll-content">
      <div class="search-list"/>
    </div>
  </div>
  
  <div class="templates">
    <div class="list-item show-icon">
      <div class="list-item-icon">
      </div>
      <div class="list-item-body">
        <div class="account-name mobile-ellipsis list-item-title"><span class="list-item-text"></span></div>
        <div class="account-category mobile-ellipsis"><i class="list-item-texticon fa fa-list-ul"></i><span class="list-item-text"></span></div>
        <div class="account-address mobile-ellipsis"><i class="list-item-texticon fa fa-map-marker-alt"></i><span class="list-item-text"></span></div>
        <div class="account-phone mobile-ellipsis"><i class="list-item-texticon fa fa-phone"></i><span class="list-item-text"></span></div>
        <div class="account-email mobile-ellipsis"><i class="list-item-texticon fa fa-at"></i><span class="list-item-text"></span></div>
      </div>
    </div>
  </div>

</div>


<style>

#view-account-list .tab-header {
  display: flex;
  justify-content: space-between;
}

#view-account-list .toolbar-button {
  flex-shrink: 0;
}

#view-account-list .input-container {
  flex-grow: 1;
}

#view-account-list .txt-fulltext {
  width: 100%;
  height: calc(100% - 6rem);
  border: none;
  font-size: 6rem;
  margin: 3rem 0;
  padding: 0 3rem;
  border-radius: 2rem;
  
}

</style>


<script>
//# sourceURL=mob-view-account-list.jsp

UIMob.init("account-list", function($view, params) {
  $(document).von($view, "tabchange", onTabChange);
  $(document).von($view, EVENT_InputRead, onInputRead);

  var $txt = $view.find(".txt-fulltext");
  $txt.attr("placeholder", itl("@Common.FullSearch"));
  
  $txt.keydown(onInputKeyDown);
  $view.find(".btn-toolbar-media").click(onMediaClick);

  function onTabChange(event, data) {
    if (data.NewTabCode == $view.closest(".tab-content").attr("data-tabcode")) {
      // TODO: if OldTabCode==NewTabCode, go to tab root
      
      // Needs a little delay otherwise it won't focus
      setTimeout(function() {
        $txt.focus();
      }, 0);
    }
  }
  
  function onInputRead(event, data) {
    if (UIMob.isActiveContent($view)) {
      showAccountDetail({
        "MediaCode": data.MediaCode
      });
    }
  }

  function onInputKeyDown(e) {
    if (e.keyCode == KEY_ENTER) {
      var $scroll = $view.find(".tab-body");
      var text = $txt.val();
      if (text == "") 
        $scroll.scrollTop(0).find(".search-list").empty();
      else {
        $txt.blur();
        
        UIMob.initSearch({
          "Body": $scroll,
          "Cmd": "Account",
          "Command": "Search",
          "ListNodeName": "AccountList",
          "renderItem": renderAccount,
          "CommandDO": {
            "EntityTypes": [LkSN.EntityType.Organization.code, LkSN.EntityType.Person.code],
            "FullText": text
          }
        });
      }
    }
  }
  
  function onMediaClick() {
    BLMob.showMediaPickupDialog({
      "AllowExisting": true,
      "AllowVoided": true
    }, function(mediaRead, media) {
      if (media) 
        showAccountDetail({
          "MediaId": media.MediaId
        });
    });
  }

  function showAccountDetail(params) {
    UIMob.tabSlideView({
      container: $view.closest(".tab-content"),
      packageName: PKG_CAS,
      viewName: "account",
      params: params
    });
  }

  function renderAccount(account) {
    var $account = $view.find(".templates .list-item").clone().appendTo($view.find(".search-list"));
    $account.attr("data-accountid", account.AccountId);
    $account.addClass(COMMON_STATUS[account.CommonStatus]);
    $account.find(".account-name").find(".list-item-text").text(account.DisplayName || ("- " + itl("@Common.Empty").toLowerCase() + " -"));
    renderItemValue($account.find(".account-category"), account.CategoryRecursiveName);
    renderItemValue($account.find(".account-address"), account.CalcAddress);
    renderItemValue($account.find(".account-phone"), account.CalcPhones);
    renderItemValue($account.find(".account-email"), account.EmailAddress);
    
    if (account.ProfilePictureId)
      $account.find(".list-item-icon").addClass("profilepic").css("background-image", "url(" + calcRepositoryURL(account.ProfilePictureId) + ")");
    else
      $account.find(".list-item-icon").addClass("icon-alias").html("<i class='fa fa-" + account.IconAlias + "'></i>");
    
    $account.click(function() {
      showAccountDetail({
        "AccountId": $(this).attr("data-accountid")
      });
    });
  }
  
  function renderItemValue($item, value) {
    if ((value) && (value != ""))
      $item.find(".list-item-text").text(value);
    else
      $item.remove();
  }
});

</script>