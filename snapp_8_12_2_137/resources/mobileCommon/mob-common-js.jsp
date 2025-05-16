<%@page import="com.vgs.entity.dataobject.DOEnt_Workstation"%>
<%@page import="com.vgs.snapp.jwt.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="wks" class="com.vgs.entity.dataobject.DOEnt_Workstation" scope="request"/>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>
<%
DOEnt_Workstation.DOWorkstation.DOAccessPoint apt = (DOEnt_Workstation.DOWorkstation.DOAccessPoint)request.getAttribute("apt");
%>

<script type="text/javascript" id="mob-common-js.jsp" >
//# sourceURL=mob-common-js.jsp

<jsp:include page="../common/script/common-js.jsp" />

var wks = <%=wks.getJSONString()%>;
var apt = <%=(apt == null) ? "{}" : apt.getJSONString()%>;
var rights = <%=rights.getJSONString()%>;
var currentUser = null;

vgsSession = <%=JvString.jsString(pageBase.getSession().getSessionId())%>;
loggedWorkstationId = <%=JvString.jsString(pageBase.getId())%>; 
loggedUserAccountId = <%=JvString.jsString(pageBase.getSession().getUserAccountId())%>; 
vgsContext = <%=JvString.jsString(pageBase.getVgsContext())%>; 
vgsContextURL = <%=JvString.jsString(pageBase.getContextURL())%>; 
<% JvCurrency curr = pageBase.getCurrFormatter(); %>
mainCurrencyFormat = <%=curr.getCurrencyFormat().getCode()%>;
mainCurrencySymbol = "<%=JvString.escapeHtml(curr.getSymbol())%>";
mainCurrencyISO = "<%=JvString.escapeHtml(curr.getIsoCode())%>";
thousandSeparator = "<%=pageBase.getRights().ThousandSeparator.getString()%>";
decimalSeparator = "<%=pageBase.getRights().DecimalSeparator.getString()%>";


function sendCommand(cmd) {
  NativeBridge.call(cmd, [], null);
}

var NativeBridge = {
  callbacksCount : 1,
  callbacks : {},

  // Automatically called by native layer when a result is available
  resultForCallback : function resultForCallback(callbackId, resultArray) {
    try {
      var callback = NativeBridge.callbacks[callbackId];
      if (!callback)
        return;

      callback.apply(null, resultArray);
    } catch (e) {
      alert(e)
    }
  },

  // Use this in javascript to request native objective-c code
  // functionName : string (I think the name is explicit :p)
  // args : array of arguments
  // callback : function with n-arguments that is going to be called when the native code returned
  call : function call(functionName, args, callback) {

    var hasCallback = callback && typeof callback == "function";
    var callbackId = hasCallback ? NativeBridge.callbacksCount++ : 0;

    if (hasCallback)
      NativeBridge.callbacks[callbackId] = callback;

    var iframe = document.createElement("IFRAME");
    iframe.setAttribute("src", "js-frame:" + functionName + ":" + callbackId + ":" + encodeURIComponent(JSON.stringify(args)));
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
  }
};

$(document).ready(function() {
  $(".v-fa-icon:not(.v-fa-icon-initialized)").each(function(index, elem) {
    var $elem = $(elem);
    var alias = $elem.attr("data-iconalias");
    $elem.html("<i class='fa fa-" + alias + "'></i>");
  });
});

function vgsService(cmd, reqDO, silent, callback) {
  var forwardToServerId = null;
  if ((reqDO) && (reqDO.ForwardToServerId)) {
    forwardToServerId = reqDO.ForwardToServerId;
    delete reqDO.ForwardToServerId;
  }
  var dontKeepSessionAlive = null;
  if ((reqDO) && (reqDO.DontKeepSessionAlive)) {
    dontKeepSessionAlive = reqDO.DontKeepSessionAlive;
    delete reqDO.DontKeepSessionAlive;
  }

  var req = {
    Header: {
      /*Session: vgsSession,*/
      WorkstationId: (reqDO) ? (reqDO.ForceWorkstationId || loggedWorkstationId) : loggedWorkstationId
    },
    Request: reqDO
  };
  
  if (dontKeepSessionAlive)
  	req.Header.DontKeepSessionAlive = dontKeepSessionAlive;
  
  if (forwardToServerId)
    req.Header.ForwardToServerId = forwardToServerId;
  
  $.ajax({
    url: BASE_URL + "/service?cmd=" + cmd + "&format=json&ts=" + (new Date()).getTime(),
    type: "POST",
    data: "message=" + encodeURIComponent(JSON.stringify(req)),
    dataType: "json"
  }).always(function(ans) {
    if (silent) {
      if (callback)
        callback(ans);
    }
    else {
      var unauth = (ans) && (ans.Header) && ([401, 1203].indexOf(ans.Header.StatusCode) >= 0);
      if (unauth) {
        loginPopup(function() {
          vgsService(cmd, reqDO, silent, callback);
        });         
      }
      else {
        var errorMsg = getVgsServiceError(ans);
        if (errorMsg != null) 
          showIconMessage("warning", errorMsg);
        else if (callback)
          callback(ans);
      }
      
    }
  });
}

function GenerateIconUrl(iconName,size) {
	var path1 = "<v:config key="site_url"/>/imagecache?name=";
	var path2 = "&size=";
	return path1 + iconName + path2 + size;
}

function loginPopup() {
  alert("function loginPopup() -> TO BE IMPLEMENTED");
}

function showIconMessage(type, msg, callback) {
  showMobileQueryDialog(null, msg, ['Ok'], callback);
}

function showMobileQueryDialog(title, content, buttons, callback) {
  var divLayOver = $("<div class='mobile-dialog-layover'/>").appendTo("body");
  var divDialog = $("<div class='mobile-dialog'/>").appendTo(divLayOver);
  var divTitle = $("<div class='mobile-dialog-title'/>").appendTo(divDialog).text(title);
  var divBody = $("<div class='mobile-dialog-body'/>").appendTo(divDialog);
  var divFooter = $("<div class='mobile-dialog-footer'/>").appendTo(divDialog);
  
  if ((typeof content) == "string")
    divBody.text(content);
  else
    divBody.append(content);
  
  for (var i=0; i<buttons.length; i++) {
    var btn = $("<div class='mobile-dialog-button'/>").appendTo(divFooter);
    btn.attr("data-index", i);
    btn.text(buttons[i]);
    if (buttons.length == 2) {
      btn.css("float", "left");
      btn.css("width", "50%");
    }
    btn.click(function() {
      var idx = parseInt($(this).attr("data-index"));
      divLayOver.remove();
      if (callback)
        callback(idx);
    });
  }
  
  var top = ($(document).height() - divDialog.height()) / 2;
  divDialog.css("top", top+"px");
}

function showMobileQueryDialog2(title, content, buttons, callback) {
  var divLayOver = $("<div class='mobile-dialog-layover'/>").appendTo("body");
  var divDialog = $("<div class='mobile-dialog'/>").appendTo(divLayOver);
  var divTitle = $("<div class='mobile-dialog-title'/>").appendTo(divDialog).text(title);
  var divBody = $("<div class='mobile-dialog-body'/>").appendTo(divDialog);
  var divFooter = $("<div class='mobile-dialog-footer'/>").appendTo(divDialog);
  
  if ((typeof content) == "string")
    divBody.html(content);
  else
    divBody.append(content);
  
  for (var i=0; i<buttons.length; i++) {
    var btn = $("<div class='mobile-dialog-button'/>").appendTo(divFooter);
    btn.attr("data-index", i);
    btn.text(buttons[i]);
//     if (buttons.length == 2) {
//       btn.css("float", "left");
//       btn.css("width", "50%");
//     }
    btn.click(function() {
      var idx = parseInt($(this).attr("data-index"));
      
      if (callback) {
       var result = callback(idx);
      }
      if(result) {
        divLayOver.remove();
      }
    });
  }
  
  var top = ($(document).height() - divDialog.height()) / 2;
  divDialog.css("top", top+"px");
}

function showMobileInputDialog(title, defaultValue, buttons, callback) {
  var $content = $("<input type='text' class='form-control'/>");
  $content.val(defaultValue);
  
  showMobileQueryDialog(title, $content, buttons, function(index) {
    if (callback) {
      try {
        callback(index, $content.val());
      }
      catch (error) {
        showMobileQueryDialog(null, error, [itl("@Common.Ok")], function() {
          showMobileInputDialog(title, defaultValue, buttons, callback);
        });
      }
    }
  });
}

$(document).ready(function() {
  setActiveTabMain($("#page-main").attr("data-activetab"));
  $(".tab-button").on("<%=pageBase.getEventMouseDown()%>", function() {
    setActiveTabMain($(this).attr("data-tabcode"));
  });  

  sendCommand("StartRFID");
});

function onClosingApplication() {
  doLogout();
}

function doLogout() {
  var reqDO = {
    Command: "Logout",
    Logout: {
      WorkstationId: <%=JvString.jsString(pageBase.getId())%>
    }
  };
  
  vgsService("LOGIN", reqDO, false, function() {
    window.location.reload();
  });
}

var keybuffer = "";
var tsLast = (new Date()).getTime();

$(document).on( "keypress", function(e) {
  if (!$(':focus').is("input")) {
    var tsNow = (new Date()).getTime();
    if (tsNow - tsLast > 10000) 
      keybuffer = "";

    if (e.keyCode == KEY_ENTER) {
      if (keybuffer.length >= 6)
        doMediaRead(keybuffer);
      keybuffer = "";
    }
    else if ((e.keyCode >= 33) && (e.keyCode <= 126))
      keybuffer += e.key;
    
    tsLast = tsNow;
  }
});

$(document).bind("VGS_CodeRead", function(event, code, inputType) {
  if ( typeof mainactivityStep !== 'undefined' && mainactivityStep ) {
    switch (mainactivityStep) {
      case mainactivity_step.home:
        break;
      case mainactivity_step.catalog:
        break;
      case mainactivity_step.cart:
        mainactivity(mainactivity_step.catalog);
        break;
      case mainactivity_step.event:
        mainactivity(mainactivity_step.catalog);
        break;
      case mainactivity_step.eventProducts:
        break;
      case mainactivity_step.checkout:
        break;
      case mainactivity_step.mediaAssoc:
        doMediaRead(code, inputType);
        break;
      case mainactivity_step.transactionResult:
        break;
      case mainactivity_step.walletPayment:
        doHoldWalletPayment(code);
        break;
      case mainactivity_step.lookup:
        doMediaLookup(code);
        break;
      case mainactivity_step.lookupMedia:
        doMediaLookup(code);
        break;
      }  
  } else {
    doMediaRead(code, inputType);
  }
});

function mobileSlide(oldDiv, newDiv, direction, callback) {
  if (callback) callback("init", newDiv);
  var oldDiv = $(oldDiv);
  var newDiv = $(newDiv);
  var oldOffset = oldDiv.offset();
  var stepPerc = 20;
  
  function _mobileSlide(perc) {
    var pxStep = oldDiv.width() * (perc / 100);
    
    if (direction == "R2L") {
      newDiv.css("left", oldOffset.left + oldDiv.width() - pxStep);
      oldDiv.css("left", oldOffset.left - pxStep);
    }
    else if (direction == "L2R") {
      newDiv.css("left", oldOffset.left - oldDiv.width() + pxStep);
      oldDiv.css("left", oldOffset.left + pxStep);
    }
    else {
      console.log("direction not handled: " + direction);
      return;
    }

    if (perc < 100) {
      setTimeout(function() {
        _mobileSlide(Math.min(100, perc + stepPerc));
      }, 10);
    }
    else {
      newDiv.css({
        "position": "",
        "top": "",
        "left": "",
        "width": "",
        "height": ""
      });
      if (callback)
        callback("load", newDiv);
    }
  }
  
  function _getOppositeDirection() {
    switch(direction) {
      case "R2L": return "L2R";
      case "L2R": return "R2L";
      case "T2B": return "B2T";
      case "B2T": return "T2B";
      default: return direction;
    }
  }
  
  newDiv.css({
    "position": "absolute",
    "top": oldOffset.top,
    "left": oldOffset.left,
    "width": oldDiv.width(),
    "height": oldDiv.height()
  });
  
  _mobileSlide(0);

  newDiv.find(".btn-toolbar-back").on("click", function() {
    if (callback) callback("back", newDiv);
    mobileSlide(newDiv, oldDiv, _getOppositeDirection(), function() {
      newDiv.remove();
      if (callback) callback("destroy", newDiv);
    });
  });
}

function setActivePage(pageCode) {
  $("body").attr("data-activepage", pageCode);
  $(".page-container").removeClass("active-page");
  $(".page-container[data-pagecode='" + pageCode + "']").addClass("active-page");
}

function setActiveTabMain(tabCode) {
  var oldTabCode = $("#page-main .tab-content-container.active-tab").attr("data-tabcode");
  $(".tab-button").removeClass("active-tab");
  $(".tab-content-container").removeClass("active-tab");
  $("#page-main [data-tabcode='" + tabCode + "']").addClass("active-tab");
  $("#page-main").attr("data-activetab", tabCode).trigger("tabchange", {"newTabCode":tabCode, "oldTabCode":oldTabCode});
}

function showPrefSingleList(prefItemSrc, options, itemClickFunction) {
  prefItemSrc = $(prefItemSrc);
  var divActiveContent = prefItemSrc.closest(".tab-content");
  
  var divNewContent = $("<div class='tab-content'/>").appendTo(divActiveContent.parent());
  var divHeader = $("<div class='tab-header'/>").appendTo(divNewContent);
  var divBtnBack = $("<div class='toolbar-button btn-toolbar-back'/>").appendTo(divHeader);
  var divHeaderTitle = $("<div class='tab-header-title' style='margin-right:20vw'/>").appendTo(divHeader);
  var divBody = $("<div class='tab-body'><div class='pref-section-spacer'/><div class='pref-section'/></div>").appendTo(divNewContent);
  var divList = $("<div class='pref-item-list'/>").appendTo(divBody.find(".pref-section"));
  
  divHeaderTitle.text(prefItemSrc.find(".pref-item-caption").text());
  
  function _clickCallback(item) {
    item.closest(".pref-item-list").find(".pref-item").removeClass("selected");
    item.addClass("selected");
    prefItemSrc.attr("data-ItemId", item.attr("data-ItemId"));
    prefItemSrc.find(".pref-item-value").text(item.find(".pref-item-caption").text());
  }
  
  if (options) {
    for (var i=0; i<options.length; i++) {
      var divItem = $("<div class='pref-item pref-item-check'/>").appendTo(divList);
      var divCaption = $("<div class='pref-item-caption'/>").appendTo(divItem);
      divCaption.text(options[i].ItemCaption);
      divItem.attr("data-ItemId", options[i].ItemId);
      divItem.attr("data-ItemCaption", options[i].ItemCaption);
      if (prefItemSrc.attr("data-ItemId") == options[i].ItemId)
        divItem.addClass("selected");
      
      divItem.on("click", function() {
        var $this = $(this);
        if (itemClickFunction) 
          itemClickFunction($this, _clickCallback);
        else
          _clickCallback($this);
      });
    }
  }
  
  mobileSlide(divActiveContent, divNewContent, "R2L");
}

function showWaitGlass() {
  $("<div id='wait-glass' class='mobile-dialog-layover'><div class='mobile-dialog'/></div>").appendTo("body");
}

function hideWaitGlass() {
  $("#wait-glass").remove();
}

</script>