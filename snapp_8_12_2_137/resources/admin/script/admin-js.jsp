<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.DOCustomFieldsBean.*"%>
<%@page import="com.vgs.snapp.web.plugin.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
boolean externalLogin = false;
boolean snappLogin = pageBase.getRights().SnAppLoginEnabled.getBoolean();

BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession();
DOCustomFieldsBean customFields = new DOCustomFieldsBean();

if (!BLBO_DBInfo.isDatabaseEmpty() && !BLBO_DBInfo.isDatabaseUpdateNeeded()) {
  DORightRoot licRights = pageBase.getBL(BLBO_Right.class).loadRights(LkSNEntityType.Licensee, BLBO_DBInfo.getMasterAccountId());
  if (!licRights.ExternalLoginWeb_PluginId.isNull()) {
    if (licRights.ExternalLoginWeb_PluginId.getArray().length == 1) {
      PlgExternalLoginWebBase externalLoginWebPlugin = SrvBO_Cache_SystemPlugin.instance().findPluginInstance(PlgExternalLoginWebBase.class, licRights.ExternalLoginWeb_PluginId.getArray()[0]);
      if (!Objects.isNull(externalLoginWebPlugin)) {
        externalLogin = true;
        customFields = externalLoginWebPlugin.getCustomFields();
      }
    }
  }
}
%>
<jsp:include page="../../common/script/common-js.jsp" />

<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
<script>
<% } %>

const ENGSTATS_REFRESH_DELAY = 5000;
var vgsSession = null;
var loggedWorkstationId = null;
var vgsContext = null;
var vgsContextURL = null;
var posTimestamp = null; // Used by pos_email.jsp
var extPluginId = null;

var browserTabId = (sessionStorage.browserTabId && sessionStorage.closedLastTab !== "2") ? sessionStorage.browserTabId : sessionStorage.browserTabId = Math.random();
sessionStorage.closedLastTab = "2";
$(window).on("unload beforeunload", function() {
  sessionStorage.closedLastTab = "1";
});


//Mobile Safari in standalone mode
if (("standalone" in window.navigator) && window.navigator.standalone) {
  var noddy, remotes = false; // If you want to prevent remote links in standalone web apps opening Mobile Safari, change 'remotes' to true
  
  document.addEventListener('click', function(event) {
    noddy = event.target;
    
    // Bubble up until we hit link or top HTML element. Warning: BODY element is not compulsory so better to stop on HTML
    while (noddy.nodeName !== "A" && noddy.nodeName !== "HTML") 
      noddy = noddy.parentNode;
    
    if ('href' in noddy && noddy.href.indexOf('http') !== -1 && (noddy.href.indexOf(document.location.host) !== -1 || remotes)) {
      event.preventDefault();
      document.location.href = noddy.href;
    }
  
  }, false);
}

// modifying String prototype
if (!String.prototype.format) {
  String.prototype.format = function() {
    var args = arguments;
    return this.replace(/{(\d+)}/g, function(match, number) { 
      return typeof args[number] != 'undefined'
        ? args[number]
        : match
      ;
    });
  };
}

<%@ include file="observer.js" %>

function removeArrayElem(array, elem) {
  if (array != null) {
    var idx = array.indexOf(elem);
    if (idx >= 0) 
      array.splice(idx, 1);
  }
}

$(document).on("click", ".cblist", function(e) {
  var cb = $(this);
  var grid = cb.closest(".listcontainer");
  var all_cbs = grid.find(".cblist").not(".header");
  if (cb.hasClass("header")) {
    all_cbs.setChecked(cb.isChecked());
    grid.removeClass("multipage-selected");
    if (cb.isChecked() && cb.hasClass("multipage") && (grid.attr("data-pagetot") != "1")) {
      var totrec = grid.attr("data-rectot");
      var msg = itl("@Common.MultiPageSelectConfirm", totrec);
      var dlg = $("<div title='Multi page selection'/>").appendTo("body");
      dlg.html(msg);
      dlg.dialog({
        resizable: false,
        modal: true,
        buttons: [
          {
            text: itl("@Common.ThisPage"),
            click: function() {
              dlg.remove();
            }
          },
          {
            text: itl("@Common.All") + " (" + totrec + ")",
            click: function() {
              dlg.remove();
              grid.addClass("multipage-selected");
            }
          }
        ]
      });
    }
  }

  var checked_cbs = grid.find(".cblist:checked").not(".header");
  grid.find(".cblist.header").setChecked(all_cbs.length == checked_cbs.length);
  grid.find(".grid-row").removeClass("selected");
  //checked_cbs.parentsUntil("tr").parent().addClass("selected");
  
   e.stopPropagation();
  $(document).trigger("cbListClicked");
});

$(document).on("cbListClicked", refreshGridBindings);
function refreshGridBindings() {
  $(".grid-widget-container").each(function(index, elem) {
    var $gridCont = $(elem);
    var gridId = $gridCont.attr("id");
    if (gridId) {
      var selCount = $gridCont.find(".cblist:checked").length;
      var $btns = $(".btn[data-bindgrid='" + gridId + "']");
      $btns.removeAttr("disabled");
      if (selCount == 0)
        $btns.attr("disabled", "disabled");
      
      var $btnsReverse = $btns.filter("[data-bindgridempty='true']");
      $btnsReverse.removeAttr("disabled");
      if (selCount > 0)
        $btnsReverse.attr("disabled", "disabled");
    }
  });
}

$.fn.removeCheckedRows = function() {
  var $grid = $(this).closest(".listcontainer");
  var $cbHeader = $grid.find(".cblist.header");
  $grid.find(".cblist:checked").not($cbHeader).closest("tr").remove();
  $cbHeader.setChecked(false);
}

  
function triggerEntityChange(entityType, entityId) {
  $(document).trigger("OnEntityChange", {
    EntityType: entityType,
    EntityId: entityId
  });
}

$(document).on("OnEntityChange", function(e, obj) {
  obj = (obj) ? obj : {};
  var id = $(".listcontainer[data-entitytype='" + obj.EntityType + "']").closest(".grid-widget-container").attr("id");
  if ((id) && (id != ""))
    changeGridPage("#" + id, "first");
});

function sendPost(src, action) {
  var form = $(src).filter("form");
  if (form.length == 0)
    form = $(src).closest("form");
  form.children("[name=action]").val(action);
  form.submit();
}

function checkRequired(src, callback) {
  var form = $(src);
  
  if (form.length == 0)
    var dialog = $(src);
  
  var err = false;
  var fields;
  if (form.length == 0)
    fields = dialog.find("[data-required='true']");
  else
    fields = form.find("[data-required='true']");
  
  var first_err_item = null;
  var err_field_names = [];
  for (var i=0; i<fields.length; i++) {
    var value = $(fields[i]).children('.form-field-value');
    var $metaField =  value.find("input");
    var sValue = $metaField.val();
    
    if (value.find(".selectize-control").length > 0) {
      var arr = value.find("select").val() || [];
      sValue = (arr.length == 0) ? "" : arr[0];
    }
    
    if ($metaField.is("input[type='radio']")) {
    	sValue = $metaField.filter(":checked").val();
      }
    
    if (!(sValue) && (sValue != ""))
      sValue = value.find("textarea").val();
    
    if (!(sValue) && (sValue != ""))
      sValue = value.find("select").val();

    if (!(sValue) && (sValue != "")) {
      var vCombo = value.find(".v-combo");
      if (vCombo.length > 0) 
        sValue = vCombo.vcombo_getSelItemId();
    }

    if (!(sValue) && (sValue != "")) {
      var $dyncombo = value.find(".v-dyncombo");
      if ($dyncombo.length > 0) 
        sValue = $dyncombo.val();
    }
    
    if (!(sValue) || (sValue.trim() == "")) {
      err = true;
      if (first_err_item == null)
        first_err_item = value;
      
        var label = $(fields[i]).children('.form-field-caption');
        err_field_names.push(label.html());
    }
  }
  if (err) {
    showMessage(itl("@Common.CheckRequiredFields") + ":\n- " + err_field_names.join("\n- "), function() {
      first_err_item.focus();
    });
  }
  else
    callback();
}

function formFieldCheckBoxClick(cb) {
  $(cb).closest(".form-field-caption").closest(".form-field").find(".form-field-value").setClass("hidden", !$(cb).isChecked());
}

function confirmDialog(title, callback_YES, callback_NO) {
  var dlg = $("<div title='SnApp'/>").appendTo("body");
  title = title || itl("@Common.Confirm")+"?";
  dlg.text(title);
  dlg.html(dlg.html().split("\n").join("<br/>"));
  dlg.dialog({
    resizable: false,
    modal: true,
    close: function() {
      dlg.remove();
      if (callback_NO)
        callback_NO();
    },
    buttons: [
      {
        "text": itl("@Common.Yes"),
        "click": function() {
          dlg.remove();
          if (callback_YES)
            callback_YES();
        }
      },
      {
        "text": itl("@Common.No"),
        "click": function() {
          dlg.remove();
          if (callback_NO)
            callback_NO();
        }
      }
    ]
  });
  return dlg;
}

function inputDialog(title, message, placeHolder, defaultText, readOnly, callback_OK, callback_CANCEL, maxLength) {
  inputDialog2({
    "title": title,
    "message": message,
    "placeHolder": placeHolder,
    "defaultText": defaultText,
    "readOnly": readOnly,
    "maxLength": maxLength,
    "onConfirm": callback_OK, 
    "onCancel": callback_CANCEL 
  });
}

/* 
 * params: {
 *   title:       string   - input dialog's title
 *   message:     string   - text displayed above the input text
 *   placeHolder: string   - input text's placeholder
 *   defaultText: string   - input text's default value
 *   readOnly:    boolean  - when TRUE, the input text is disabled
 *   maxLength:   integer  - max text length (optional, default is null=unlimited)
 *   onConfirm:   function - called when pressing OK (function receive 1 string param which is the inputed text) 
 *   onCancel:    function - called when pressing CANCEL or closing dialog 
 * }
 */
function inputDialog2(params) {
  params = params || {};
  params.title = params.title || "SnApp";
  params.readOnly = (params.readOnly === true) ? true : false;
  
  var $dlg = $("<div/>");
  if (params.message) 
    $("<div/>").appendTo($dlg).text(params.message);
  
  var $txt = $("<input type='text' class='form-control'/>").appendTo($dlg);
  if (params.placeHolder)
    $txt.attr("placeholder", params.placeHolder);
  if (params.defaultText)
    $txt.val(params.defaultText);
  if (params.readOnly)
    $txt.prop("disabled", true);
  if (params.maxLength)
    $txt.prop("maxLength", params.maxLength);
  
  var $divErr = $("<div class='hidden' style='margin:10px;color:#f00;font-weight:bold'/>").appendTo($dlg);
  
  function _doInputOk() {
     try {
       if (params.onConfirm)
         params.onConfirm($txt.val());
      $dlg.remove();
     }
    catch (e) {
      $divErr.removeClass("hidden").text(e);
      $txt.focus();
    }
  }
  
  $txt.keydown(function() {
    $divErr.addClass("hidden");
    if (event.keyCode == KEY_ENTER)
      _doInputOk();
  });
  
  $dlg.dialog({
    title: params.title,
    resizable: false,
    modal: true,
    close: function() {
      $dlg.remove();
      if (params.onCancel)
        params.onCancel();
    },
    buttons: [
      dialogButton("@Common.Ok", _doInputOk),
      dialogButton("@Common.Cancel", doCloseDialog)
    ]
  });
}

function post(src, action, askConfirm, confirmMsg) {
  if (askConfirm) {
    doPost = false;
    confirmDialog(confirmMsg, function() {
      sendPost(src, action);
    });
  }
  else
    sendPost(src, action);
}

function clearInputField(id) {
  var elem = document.getElementById(id);
  elem.parentNode.innerHTML = elem.parentNode.innerHTML;
}

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds)
      break;
  }
}

function coalesce(array) {
  if (array != null)
    for (var i=0; i<array.length; i++)
      if (array[i] != null)
        return array[i];
  return null;
}

$(document).ready(function() {
  if (getCookie("snapp-filterbar") == "false") 
    $("#main-container").addClass("hide-filters");

  $(".default-focus").focus();
});

function asyncLoad(selector, urlo, callback) {
  $(selector).html("<div style='line-height:32px'><i class='fa fa-circle-notch fa-spin fa-2x fa-fw' style='vertical-align:sub'></i> Loading...</div>");
  
  $.ajax({
    url: urlo,
    dataType:'html',
    cache: false,
    complete: function(jqXHR, textStatus) {
      if (jqXHR.status == 200) { 
        $(selector).html(jqXHR.responseText);
        if (callback)
          callback();
      }
      else if (jqXHR.status == 401) {
        loginPopup(function() {
          asyncLoad(selector, urlo, callback);
        });         
      }
      else {
        $(selector).text(itl("@Common.GenericError"));
      }
    }
  });
}

function asyncWidget(selector, jsp, params, callback) {
  var urlo = "<%=pageBase.getContextURL()%>?page=widget&jsp=" + jsp;
  if (params)
    urlo += "&" + params;
  asyncLoad(selector, urlo, callback);
}


function textMessageToHtml(msg, container) {
  if (msg) {
    if (msg instanceof Error)
      msg = msg.message;
    
    var lines = msg = msg.replace("\r\n", "\n").replace("\r", "\n").split("\n");
    for (var i=0; i<lines.length; i++) {
      var p = $("<p style='margin:0'/>").appendTo(container);
      if (lines[i] == "")
        p.html("&nbsp;");
      else
        p.text(lines[i]);
    }
  }
}

function showIconMessage(type, msg, callback) {
  var dlg = $("<div/>");
  dlg.append("<span class='ui-helper-hidden-accessible'><input type='text'/></span>");
  
  var title = "SnApp";
  var iconAlias = "exclamation-circle";
  if (type == "warning") 
    title = itl("@Common.Warning");
    
    var divBody = $("<div class='msg-dialog-body'/>").appendTo(dlg);
    var divIcon = $("<div class='msg-dialog-icon'><i class='fa fa-" + iconAlias + "'></i></div>").appendTo(divBody);
    var divText = $("<div class='msg-dialog-text'/>").appendTo(divBody);
  
  textMessageToHtml(msg, divText);
  
  dlg.dialog({
    modal: true,
    title: title,
    dialogClass: "icon-dialog",
    close: function() {
      dlg.remove();
      if (callback) {
        if ((typeof callback) == "string")
          eval(callback);
        else
          callback();
      }
    },
    buttons: {
      Ok: doCloseDialog
    }
  });
}

function showMessage(msg, ok_callback) {
  var dlg = $("<div title='SnApp'/>");
  dlg.append("<div class=\"v-hidden\"><span class='ui-helper-hidden-accessible'><input type='text'/></span></div>");
  
  textMessageToHtml(msg, dlg);
  
  dlg.dialog({
    modal: true,
    close: function() {
      dlg.remove();
      if (ok_callback) {
        if ((typeof ok_callback) == "string")
          eval(ok_callback);
        else
          ok_callback();
      }
    },
    buttons: {
      Ok: doCloseDialog
    }
  });
}

function doCloseDialog() {
  $(this).closest(".ui-dialog-content").dialog("close");
}

function doRemoveDialog() {
  $(this).remove();
}

//--- UPLOAD DIALOG ---//

 function showUploadDialog(entityType, entityId, reloadPageOnFinish) {
   asyncDialogEasy('../admin/repository/file_upload_dialog', 'EntityType=' + entityType + '&EntityId=' + entityId + '&Reload=' + reloadPageOnFinish);
 }

function showRepositoryPickup(entityType, entityId, uploadEntityType, uploadEntityId) {
  uploadEntityType = (uploadEntityType) ? uploadEntityType : entityType;
  uploadEntityId = (uploadEntityId) ? uploadEntityId : entityId;
  var urlo = "<%= pageBase.getContextURL()%>?page=repository_pickup_widget&id=" + entityId + "&EntityType=" + entityType + "&UploadEntityType=" + uploadEntityType + "&UploadEntityId=" + uploadEntityId;
  var dlg = $("<div class='v-hidden' title='<v:itl key="@Common.Repository"/>'></div>").appendTo("body");
  dlg.dialog({
    close: function() {
      dlg.remove();
    },
    modal: true,
    height: 500,
    width: 550,
    resizable: false,
    buttons: [
      {
        "text": itl("@Common.Cancel"),
        "click": function() {
          $(this).dialog("close");
        }
      },
      {
        "text": itl("@Common.Remove"),
        "click": function() {
          repositoryPickupCallback("");
          $(this).dialog("close");
        }
      }
    ]
  });
  asyncLoad(dlg, urlo);
}

function setVisible(selector, value) {
  if (value)
    $(selector).removeClass("hidden v-hidden");
  else
    $(selector).addClass("hidden");
}

jQuery.fn.valObject = function(value) {
  return jQuery.fn.val.call(this, value);
};

jQuery.fn.isChecked = function() {
  var cb = $(this);
  return (cb.length > 0) && (cb.length == cb.filter(":checked").length);
};

jQuery.fn.setChecked = function(value) {
  var $this = $(this);
  $this.prop("checked", value ? true : false);
  $this.trigger("checked-changed");
  formFieldCheckBoxClick(this);
  return $this;
};

function isChecked(selector) {
  return $(selector).isChecked();
}

function setChecked(selector, value) {
  return $(selector).setChecked(value);
}

function setRadioChecked(selector, value) {
  var $this = $(selector); 
  $this.attr("checked", false);
  $this.filter("[value='" + value + "']").prop("checked", true);
  return $this;
}

jQuery.fn.isEnabled = function() {
  return !($(this).attr("disabled") == "disabled");
};

jQuery.fn.setEnabled = function(enabled) {
  var $this = $(this);
  if (enabled) 
    $this.removeAttr("disabled");
  else 
    $this.attr("disabled", "disabled");

  var id = $this.attr("id");
  if (id) 
    $("label[for='" + id + "']").setClass("disabled", !enabled);
  
  return $this;
};

jQuery.fn.getComboIndex = function() {
  return $(this).prop("selectedIndex");
};

// Used for jquery sortable
var fixHelper = function(e, ui) {
  ui.children().each(function() {
    $(this).width($(this).width());
  });
  return ui;
};

function focusNextEdit(src) {
  var nextIndex = $('input:text').index(src) + 1;
  var n = $("input:text").length;
  if(nextIndex < n)
    $('input:text')[nextIndex].focus();
  else 
    $('input:text')[0].focus();
}

function getDialog(insideElement) {
  return $(insideElement).closest('.ui-dialog-content');
}

function closeDialog(insideElement) {
  getDialog(insideElement).dialog('close'); 
}

function popupMenu(menuSelector, targetSelector, event) {
  var oldParent = $(menuSelector).parent();
  $(menuSelector).appendTo("body");
  
  if (targetSelector == null) {
    $(menuSelector).removeClass("v-hidden").offset({
      left: event.x,
      top: event.y
    });
  }
  else {
    $(menuSelector).removeClass("v-hidden").position({
      my: "left top",
      at: "left bottom",
      of: targetSelector
    });
  }

  if (event) {
    event.stopPropagation();
    event.preventDefault();
  }
  
  var hideFunction = function(e) {
    if ((e.type != "keydown") || !(e.ctrlKey || e.shiftKey || e.altKey)) {
      $(menuSelector).addClass("v-hidden").appendTo(oldParent);
      $(document).off("click", hideFunction);
      $(document).off("keydown", hideFunction);
    }
  };
  
  $(document).on("click", hideFunction);
  $(document).on("keydown", hideFunction);
}

function documentAction(entityType, entityId, actionName, actionCaption) {
  var dlg = $("<div/>").appendTo("body");
  dlg.css("background-image", "url('<v:config key="site_url" />/resources/admin/images/spinner.gif')");
  dlg.css("background-repeat", "no-repeat");
  dlg.css("background-position", "center center");
  dlg.css("font-weight", "bold");
  dlg.dialog({
    modal: true,
    title: actionCaption,
    buttons: [
      {
        "text": itl("@Common.Ok"),
        "click": function() {
          dlg.dialog("close");
          dlg.remove();
          if (actionName == "paste")
            location.reload(true);
        }
      }
    ]
  });
  
  var urlo = "<%=pageBase.getContextURL()%>?page=utils&action=" + actionName;
  if (entityType != null)
    urlo += "&EntityType=" + entityType;
  if (entityId != null)
    urlo += "&EntityId=" + entityId;
  
  $.ajax({
    url: urlo,
    dataType:'html',
    cache: false
  }).done(function(html) {
    dlg.css("background-image", "none");
    dlg.html(html);
  }).fail(function() {
    dlg.css("background-image", "none");
    dlg.text(itl("@Common.GenericError"));
  });
}

function documentCopy(entityType, entityId) {
  documentAction(entityType, entityId, "copy", itl("@Common.Copy"));
}

function documentCut(entityType, entityId) {
  documentAction(entityType, entityId, "cut", itl("@Common.Cut"));
}

function documentPaste(entityType, entityId) {
  documentAction(entityType, entityId, "paste", itl("@Common.Paste"));
}


function CMD_Validate(mediaCode, accessPointId, usageType, entryControl, useTicket, callback) {
  if (usageType == null)
    usageType = <%=LkSNTicketUsageType.Entry.getCode()%>;
  
  if (entryControl == null)
    entryControl = <%=LkSNAccessPointControl.Controlled.getCode()%>;
/*    
  if (useTicket == null)
    useTicket = true;
*/  
  $.ajax({
    type: "post",
    url: "<v:config key="site_url"/>/service?CMD=Validate" +
        "&MediaCode=" + mediaCode + 
        "&AccessPointId=" + accessPointId + 
        "&UsageType=" + usageType + 
        "&EntryControl=" + entryControl + 
        "&format=json&ts=" + new Date().getTime(),
    success: function(data) {
      window[callback].apply(null, [data]);
    }
  });
}

function loginPopup(callback) {
  var dlg = $("<div class='login-dialog'/>");
  var divUID = $("<div class='login-item'><span/></div>").appendTo(dlg);
  var divPWD = $("<div class='login-item'><span/></div>").appendTo(dlg);
  var divSSOLink = $("<div class='hidden'><span/></div>").appendTo(dlg);
  var divSSOWaitForMessage = $("<div class='hidden'></div>").appendTo(dlg);
  dlg.dialog({
    title: itl("@Common.Login"),
    modal: true,
    resizable: false,
    width: 300,
    buttons: []
  });  
  
  var dialogButtons = [dialogButton("@Common.Login", doLogin)];
  var divWait = $("<div class='login-wait hidden'><i class='fa fa-circle-notch fa-spin fa-3x fa-fw'></i></div>").appendTo(dlg);
  var divANS = $("<div class='login-error hidden'/>").appendTo(dlg);
  
  <% if (snappLogin) { %>
  dlg.dialog({buttons: dialogButtons});

  divUID.find("span").text(itl("@Common.UserName"));
  divPWD.find("span").text(itl("@Common.Password"));
  <% if (customFields != null){%>
    <% for (DOCustomFieldBean customField : customFields.customFields) { %>
      var div_<%=customField.code%> = $("<div class='login-item'><span><%=customField.placeholder%></span></div>").appendTo(dlg);
      $("<input class='form-control custom-field' type='<%=customField.type%>' id='<%=customField.code%>'/>").appendTo(div_<%=customField.code%>);
    <% } %>
  <%}%>

  var uid = $("<input type='text' class='form-control' disabled/>").appendTo(divUID);
  var pwd = $("<input type='password' id='user_pass' class='form-control' name='pwd'/>").appendTo(divPWD);
  
  uid.val($("#login-user-name-masked").val());
  
  pwd.keydown(function(e) {
    if (e.keyCode == KEY_ENTER)
      doLogin();
  });  
  <% }  else if (externalLogin){ %>
  _openSSOLoginDialog();
  <% } %>

  <% if (externalLogin && snappLogin) { %>
  let ssoLink = $('<a href="#" id="ssoLoginLink">Login with SSO</a>');
  ssoLink.on("click", function(event) {
    event.preventDefault();
    _openSSOLoginDialog();
  });
  divSSOLink.find("span").append(ssoLink);
  divSSOLink.removeClass('hidden');
  <% } %>
  
  function _showSSOLOginWaitingStatus() {
    divUID.addClass("hidden");
    divPWD.addClass("hidden");
    divSSOLink.addClass("hidden");
    divWait.removeClass("hidden");
    dlg.dialog({ buttons: [] });

    divSSOWaitForMessage.html("<p><b>Waiting for SSO Login...</b></p><p>Make sure your browser consents popups.</p>");
    divSSOWaitForMessage.removeClass("hidden");
  }
  
  function _openSSOLoginDialog() {
    _showSSOLOginWaitingStatus();
    var loginPopup = window.open('<%=pageBase.getContextURL()%>', "LoginWindow", "width=400,height=500");
    //Check If loginPopup has been manually closed and if true close dlg as well.
    let checkPopupClosed = setInterval(() => {
        try {
          if (loginPopup.closed) {
            clearInterval(checkPopupClosed);
            dlg.dialog("close");
          }
        } catch (e) {
          clearInterval(checkPopupClosed);
        }
    }, 500);
    
    //Message listener for external login success.
    window.addEventListener("message", _handleExternalLoginDoneMessage)

    function _handleExternalLoginDoneMessage(event) {
      if (event.origin === window.location.origin) {
        if (event.data.eventName === 'loginSuccessFull') {
          const args = event.data.args;
          dlg.dialog("close");
          loginPopup.close();
          if (callback)
            callback();
          window.removeEventListener("message", _handleExternalLoginDoneMessage)
        }
      }
    }    
  }

  function serviceCallBack(ans) {
    var error = null;
    if (ans.Header == null)
      error = "Unreadable response";
    else if (ans.Header.StatusCode != 200)
      error = ans.Header.ErrorMessage;
    
    if (error == null) {
      dlg.dialog("close");
      if (callback)
        callback();
    }
    else {
      uid.removeAttr("disabled");
      pwd.removeAttr("disabled");
      divANS.addClass("login-error");
      divANS.html(error);
      divANS.removeClass("hidden");
      divWait.addClass("hidden");
      divSSOWaitForMessage.addClass("hidden");
      pwd.focus();
    }
  }
  
  function doLogin() {
    divWait.removeClass("hidden");
    divANS.addClass("hidden");
    uid.attr("disabled", "disabled");
    pwd.attr("disabled", "disabled");
    
    varLoginAdapter = [];
    
    $('.login-item').find('.custom-field').each(function() {
      var item = {};
      item ['key'] = this.id;
      item ['value'] = $(this).val();
      
      varLoginAdapter.push(item);
    });
    
    var reqDO = {
      Command: "Login",
      Login: {
        WorkstationId: (loggedWorkstationId || <%=JvString.jsString(pageBase.getVgsContext())%>),
        UserName: $("#login-user-name").val(),
        Password: pwd.val(),
        WorkstationType: <%=pageBase.isVgsContext("B2B") ? LkSNWorkstationType.B2B.getCode() : null%>,
        ReturnDetails: false,
        LoginAdapterCustomFields: varLoginAdapter
      }
    };
    vgsService("Login", reqDO, true, serviceCallBack);
  }
  
}

function doLogout(redirectUrl) {
  snpAPI.cmd("Login", "Logout", {"WorkstationId":loggedWorkstationId}).then(() => {
    window.location = redirectUrl ? redirectUrl : vgsContextURL;
  });
}

/**
 * @param page "first" | "next" | "prev" | number
 */
function changeGridPage(gridSelector, page) {
  if ($(gridSelector).hasClass("listcontainer"))
    gridSelector = $(gridSelector).parent(); 
  if ($(gridSelector).length > 0) {
    var pagePos = parseInt($(gridSelector).find(".listcontainer").attr("data-PagePos"));
    var pageTot = parseInt($(gridSelector).find(".listcontainer").attr("data-PageTot"));
    
    page = page || "first";
    
    if (!Number.isNaN(parseInt(page)))
      pagePos = parseInt(page)
    else if (page == "first")
      pagePos = 1;
    else if ((page == "next") && (pagePos < pageTot))
      pagePos++;
    else if ((page == "prev") && (pagePos > 1))
      pagePos--;
    else
      throw new Error(itl("@Common.InvalidValueError", page));
    
    pagePos = Math.max(0, pagePos);
    pagePos = Math.min(pageTot, pagePos);
    
    var params = $(gridSelector).data("params");
    if (params) {
      params.PagePos = pagePos;
      $(gridSelector).asyncGrid(params);
      return;
    }
    
    function doRequest() {
      var urlo = setUrlParam($(gridSelector).find(".listcontainer").attr("data-url"), "qp", pagePos);
      if (urlo) {
        var overlay = $("<div class='grid-overlay'><div class='spinner-box'><i class='fa fa-circle-notch fa-spin fa-fw'></i></div></div>").appendTo(gridSelector);

        $.ajax({
          url: urlo,
          dataType:'html',
          cache: false,
          complete: function(jqXHR, textStatus) {
            overlay.remove();
            
            if (jqXHR.status == 200) { 
              $(gridSelector).html(jqXHR.responseText);
              $(document).trigger("cbListClicked");
            }
            else if (jqXHR.status == 401) 
              loginPopup(doRequest);         
            else {
              $(gridSelector).text(itl("@Common.GenericError"));
            }
          }
        });
      }
    }

    doRequest();
  }
}

function refreshPageBoxes() {
  var containers = $(".grid-widget-container");
  for (var i=0; i<containers.length; i++) {
    var id = $(containers[i]).attr("id");
    var grid = $(containers[i]).find(".listcontainer");
    var box = $(".page-box[data-GridId='" + id + "']");
    var totrec = parseInt(grid.attr("data-rectot"));
    var pagepos = parseInt(grid.attr("data-pagepos"));
    var pagetot = parseInt(grid.attr("data-pagetot"));
    var hasQuery64 = grid.attr("data-querybase64") != null;
    
    box.find(".navbuttons").css("display", (totrec == "0") ? "none" : "inline");
    
    box.find(".tot-rec-count").html(formatAmount(totrec, 0));
    box.find(".txt-pagenum").val(formatAmount(pagepos, 0) + " / " + formatAmount(pagetot, 0));
    
    var firstPage = (pagepos == 1);
    var lastPage = (pagepos >= pagetot);
    box.find(".page-link-first").prop("disabled", firstPage);
    box.find(".page-link-prev").prop("disabled", firstPage);
    box.find(".page-link-next").prop("disabled", lastPage);
    box.find(".btn-grid-download").prop("disabled", !hasQuery64 || (totrec <= 0));
  }
}

function initGrid() {
  refreshPageBoxes();
  $(document).trigger("cbListClicked");
}

function initAsyncGrid(selector, isJSON, params) {
  var $grid = $(selector);
  if (!$grid.is(".v-grid-initialized")) {
    $grid.addClass("v-grid-initialized");
    if (isJSON) 
      $grid.asyncGrid(params || {});
    else
      asyncLoad($grid, $grid.find(".listcontainer").attr("data-url"));
  }
}

/**
 * JSON OBJ example
   {
     OutputFormat : "CSV/XLS"
     Options: {
       CSV_FieldDelimiter : "",
       CSV_QuoteCharacter : "",
       CSV_IncludeHeaderLine : "true/false"
     }
   } 
 **/
function gridDownload(gridId, options) {
   optionsObj = JSON.parse(options);
  if (optionsObj.OutputFormat == "CSV" && optionsObj.Options=="{}")
    chooseOptions(gridId);
  else {
    var queryBase64 = $("#" + gridId + " .listcontainer").attr("data-querybase64");
    var action = "docproc?OutputFormat=" + optionsObj.OutputFormat + "&CSV_FieldDelimiter=" + optionsObj.Options.CSV_FieldDelimiter + "&CSV_QuoteCharacter=" + optionsObj.Options.CSV_QuoteCharacter + "&CSV_IncludeHeaderLine=" + optionsObj.Options.CSV_IncludeHeaderLine;
    var $form = $("<form method=\"post\" action=" + action + " target=\"_blank\"/>").appendTo("body");
    try {
      var $input = $("<input type='hidden' name='QueryBase64'/>").appendTo($form);
      $input.val(queryBase64);
      $form.submit();
    }
    finally {
      $form.remove();
    }
  }
}

function chooseOptions(gridId) {
  asyncDialogEasy("common/csv_options_dialog","GridId=" + gridId);
}

function setGridUrlParam(gridSelector, paramName, paramValue, doRefresh) {
  var grid = $(gridSelector).find(".listcontainer");
  var urlo = grid.attr("data-url");
  if (urlo) {
    grid.attr("data-url", setUrlParam(urlo, paramName, paramValue));
    
    if (doRefresh == true) 
      changeGridPage(gridSelector, "first");
  }
}

function setGridNumericParam(gridSelector, paramName, val) {
  var num = parseFloatOrNull(val);
  if (isNaN(num))
    throw itl("@Common.InvalidValueError", val);
  else
    setGridUrlParam(gridSelector, paramName, val);
}

jQuery.fn.asyncGrid = function(params) {
  var grid = $(this);
  grid.data("params", params);
  var overlay = $("<div class='grid-overlay' style='visibility:hidden'/>").appendTo(grid);
  overlay.css("top", $(grid).position().top + "px");
  overlay.css("left", $(grid).position().left + "px");
  overlay.css("width", $(grid).outerWidth() + "px");
  overlay.css("height", $(grid).outerHeight() + "px");
  
  var spinnerBox = $("<div class='spinner-box' style='visibility:hidden'/>").appendTo(grid);
  $(spinnerBox).position({
    my: "center center",
    at: "center center",
    of: overlay
  });
  
  setTimeout(function() {
    overlay.css("visibility", "visible");
    spinnerBox.css("visibility", "visible");
  }, 300);
  
  $.ajax({
    url: "<%=pageBase.getContextURL()%>?page=grid_widget&jsp=" + grid.attr("data-jsp") + "&ts=" + (new Date()).getTime(),
    type: "POST",
    data: "params=" + encodeURIComponent(JSON.stringify(params))
  }).always(function(ans) {
    overlay.remove();
    spinnerBox.remove();
    if ((ans.status != null) && (ans.status != 200)) 
      $(grid).html(ans.status + ": " + ans.statusText);
    else 
      grid.html(ans);
  });
};

jQuery.fn.getCheckedValues = function(selector) {
  return $(this).filter(":checked").map(function(){return this.value;}).get().join(",");
};

jQuery.fn.getStringArray = function(selector) {
  var obj = $(this).selectize()[0];
  return (obj) ? obj.selectize.getValue() : null;
};

jQuery.fn.moveUp = function() {
  if ($(this).prev())
    $(this).prev().before(this);
};

jQuery.fn.moveDown = function() {
  if ($(this).next())
    $(this).next().after(this);
};

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
      SystemTimestamp: (posTimestamp) ? posTimestamp : dateToXML(new Date()),
      WorkstationId: (reqDO) ? (reqDO.ForceWorkstationId || loggedWorkstationId) : loggedWorkstationId,
      CorrelationId: newStrUUID()
    },
    Request: reqDO
  };
  
  if (forwardToServerId)
    req.Header.ForwardToServerId = forwardToServerId;
  
  if (dontKeepSessionAlive)
    req.Header.DontKeepSessionAlive = dontKeepSessionAlive;
  
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
        hideWaitGlass();
        loginPopup(function() {
          vgsService(cmd, reqDO, silent, callback);
        });         
      }
      else {
        var errorMsg = getVgsServiceError(ans);
        if (errorMsg != null) {
          hideWaitGlass();
          showIconMessage("warning", errorMsg);
        } 
        else if (callback)
          callback(ans);
      }
    }
  });
}

const snpAPI = {
  /*
  params = {
      silent: boolean (default FALSE) // Indicate if an error message dialog should shown automatically in case of api error
      showWaitGlass: boolean (default TRUE) // Indicate is the "wait glass" panel should be automatically shown during API request
  }
  */
  cmd: function(service, command, reqDO, params) {
    return new Promise((resolve, reject) => {
      var req = {Command: command};
      req[command] = reqDO;
      
      params = params || {};
      params.silent        = (params.silent === true) ? true : false;
      params.showWaitGlass = (params.showWaitGlass === false) ? false : true;

      if (params.showWaitGlass === true)
        showWaitGlass();
      
      vgsService(service, req, params.silent, function(ans) {
        if (params.showWaitGlass === true)
          hideWaitGlass();
        
        var errorMsg = null;
        if (params.silent === true) 
          errorMsg = getVgsServiceError(ans);
        
        if (errorMsg) 
          reject(new Error(errorMsg));
        else
          resolve((ans.Answer || {})[command]);
      });
    });
  }
}


function vgsBroadcastCommand(showSpinner, dstWorkstationId, broadcastName, broacastData, callback) {
  var reqDO = {
    Command: "AppendCommand",
    AppendCommand: {
      SrcWorkstationId: (reqDO) ? (reqDO.ForceWorkstationId || loggedWorkstationId) : loggedWorkstationId,
      DstWorkstationId: dstWorkstationId,
      ValidityMin: 1,
      BroadcastName: broadcastName,
      BroadcastData: JSON.stringify({
        Header:{
          RequestCode: broadcastName
        }, 
        Request:broacastData
      })
    }
  };
  
  if (showSpinner)
    showWaitGlass();

  vgsService("broadcast", reqDO, true, function(ansDO) {
    if (showSpinner)
      hideWaitGlass();

    var errorMsg = getVgsServiceError(ansDO);
    if (errorMsg != null) {
      if ((ansDO) && (ansDO.Header) && (ansDO.Header.StatusCode == 401))
        window.location.reload();
      else if (showSpinner)
        showIconMessage("warning", errorMsg);
      else
        console.log(errorMsg);
    }
    
    if (callback)
      callback(ansDO);
  });
}

function showWaitGlass() {
  var $overlay = $("<div id='v-wait-glass' class='ui-widget-overlay'/>").appendTo("body");
  var $div = $("<div class='v-wait-glass-spinner'/>").appendTo($overlay);
  $div.append("<i class='fa fa-circle-notch fa-spin fa-fw'></i>");
  $div.append("<span class='sr-only'>Loading...</span>");
  $div.css("margin-top", (($(window).height() - $div.height()) / 2) + "px");
  var z = Math.max(1000, getMaxZIndex()) + 100;
  $overlay.css("z-index", z);
}

function hideWaitGlass() {
  $("#v-wait-glass").remove();
}

function asyncDialog(params) {
//  var postData = (getNull(params.data) == null) ? null : JSON.stringify(params.data);
  var postData = params.data;
  
  showWaitGlass();
  $.ajax({
    url: params.url,// + "&ts=" + (new Date()).getTime(),
    dataType:'html',
    cache: false,
    data: postData,
    method: (postData == null) ? "GET" : "POST",
    complete: function(jqXHR, textStatus) {
      hideWaitGlass();
      if (jqXHR.status == 200) {
        var html = $(jqXHR.responseText);
        var scripts = html.find("script");
        for (var i=0; i<scripts.length; i++) 
          $(scripts[i]).prepend("//# sourceURL=" + params.url + ((i==0) ? "" : ("&srcidx=" + i)) + "\n");
        $(html).appendTo("body");
        hidePasswordDOM();
      }
      else if (jqXHR.status == 401) {
        loginPopup(function() {
          asyncDialog(params);
        });         
      }
      else {
        showMessage(itl("@Common.GenericError"));
      }
    }
  });
};

function asyncDialogEasy(jsp, params, data) {
  asyncDialog({
    "url": "<%=pageBase.getContextURL()%>?page=widget&jsp=" + jsp + ((params) ? "&"+params : ""),
    "data": data
  });
}

function vgsImportDialog(action_url, hintContainer, accept) {
  var dlg = $("<div/>");
  
  if (hintContainer)
    $("<div class='import-hint-box'/>").appendTo(dlg).html($(hintContainer).html());
  if (accept) {
    accept = ' accept="{0}"'.format(accept);
  } else {
    accept = '';
  }

  var form = $("<form method='post' enctype='multipart/form-data' action='" + action_url + "'/>").appendTo(dlg);
  $("<input type='file' name='InputFile'{0}/>".format(accept)).appendTo(form);

  dlg.dialog({
    title: itl("@Common.Import"),
    modal: true,
    width: 600,
    resizable: false,
    buttons: [
      {
        "text": itl("@Common.Ok"),
        "click": function() {
          showWaitGlass();
          form.submit();
        }
      },
      {
        "text": itl("@Common.Cancel"),
        "click": doCloseDialog
      }
    ] 
  });
}


function showTagPickupDialog_OLD(entityType, contextId) {
  asyncDialogEasy("tag_pickup_dialog", "EntityType=" + entityType + "&ContextId=" + encodeURIComponent(contextId));
}

function removeDialog() {
  $(this).remove();
}

$.fn.asyncProcessProgressBar = function(config) {
  config = (config) ? config : {};
  if (config.AsyncProcessId == null)
    throw "missing AsyncProcessId";
  
  var $bar = $(this);
  
  var removed = false;
  $bar.on("remove", function () {
    removed = true;
  });

  function _getProcess() {
    if (!removed) {
      var reqDO = {
        Command: "GetProcess",
        GetProcess: {
          AsyncProcessId: config.AsyncProcessId
        }
      };
      
      vgsService("AsyncProcess", reqDO, false, function(ansDO) {
        var process = ansDO.Answer.GetProcess;
        if (process.AsyncProcessStatus == <%=LkSNAsyncProcessStatus.Finished.getCode()%>) {
          $bar.find(".progress-bar").css("width", "100%");
          if (config.onComplete)
            config.onComplete(process);
        }
        else if ((process.AsyncProcessStatus == <%=LkSNAsyncProcessStatus.Aborted.getCode()%>) || (process.AsyncProcessStatus == <%=LkSNAsyncProcessStatus.Failed.getCode()%>)) {
          if (config.onError)
            config.onError(process);
        }
        else {
          var sperc = process.PercComplete + "%";
          $bar.find(".progress-bar").css("width", sperc).text(sperc);
          setTimeout(_getProcess, 500);
        }
        if (config.onProgress)
          config.onProgress(process);
      });
    }
  }
  
  _getProcess();
};

function getMaxZIndex() {
  var max = 0;
  var ols = $(".ui-widget-overlay");
  for (var i=0; i<ols.length; i++) 
    max = Math.max(max, strToIntDef($(ols[i]).css("z-index"), 0));
  return max;
}

function doToggleFilters() {
  $("#main-container").toggleClass("hide-filters");
  document.cookie = "snapp-filterbar=" + (!$("#main-container").hasClass("hide-filters"));
}

function checkEmptyDatePicker(picker) {
  if ($(picker).val() == "") {
    var id = $(picker).attr("id");
    var idx = id.indexOf("-picker");
    if (idx > 0) {
      id = id.substring(0, idx);
      $("#" + id.replace(".", "\\.")).val("");
    }
  }
}

function initDatePicker(elem) {
  var $elem = $(elem);
  var altFieldId = $elem.attr("data-altfieldid");
  if (altFieldId)
    altFieldId = "#" + altFieldId.replace(".", "\\\\.");
  
  $elem.datepicker({
    changeMonth: true,
    changeYear: true,
    showOtherMonths: true,
    selectOtherMonths: true,
    altField: altFieldId,
    altFormat:"yy-mm-dd",
    firstDay: snpFirstDayOfWeek,
    beforeShow: function() {
      setTimeout(function() {
        var $pickers = $(".ui-datepicker");
        var zIndex = parseInt($pickers.css("z-index"));
        if (zIndex < 10)
          $pickers.css("z-index", 10);
      }, 0);
    }
  });

  var value = getNull($elem.val());
  if (value != null) {
    var regex = new RegExp("^[0-9]{4}-[0-9]{2}-[0-9]{2}$");
    if (regex.test(value))
      $elem.datepicker("setDate", new Date(value)); 
  }
}

$(document).ready(function() {
  initProfilePic(".profile-pic-inner");
}); 

function initProfilePic(obj) {
  var $obj = $(obj);
  $obj.on("dragover", function(e) {
    e.stopPropagation();
    e.preventDefault();
    $(this).addClass("drag-over");
  });
  $obj.on("dragenter", function(e) {
    e.stopPropagation();
    e.preventDefault();
  });
  $obj.on("dragleave", function(e) {
    e.stopPropagation();
    e.preventDefault();
    $(this).removeClass("drag-over");
  });
  $obj.on("drop", function(e) {
    e.stopPropagation();
    e.preventDefault();
    if($obj.hasClass('no-dragdrop')) {
      showMessage(<%=JvString.jsString(JvMultiLang.translate(request, "@Common.SaveFirstError"))%>);
      $(this).removeClass("drag-over");
    } else {
      handleFileUpload(e.originalEvent.dataTransfer.files[0], this);
    }
  });
}

function handleFileUpload(file, obj) {
  var cont = $(obj).parent();
  var entityType = parseInt(cont.attr("data-EntityType"));
  var entityId = cont.attr("data-EntityId");
  var repoEntityType = parseInt(cont.attr("data-RepoEntityType"));
  var repoEntityId = cont.attr("data-RepoEntityId");

  var good = (file) && (file.type) && (file.type.indexOf("image/") == 0);
  if (!good)
    showMessage("Invalid file type");
  else {
    var dlg = $("<div title=\"Uploading...\" style=\"background-position:center center;background-repeat:no-repeat;background-image:url('<v:config key="resources_url"/>/admin/images/spinner32.gif')\"/>");
    dlg.dialog({
      width: 150,
      height: 150,
      modal: true,
      resizable: false
    });
    
    var reader = new FileReader();
    reader.onload = function(e) {
      var reqDO = {
        Command: "Save",
        Save: {
          EntityType: repoEntityType,
          EntityId: repoEntityId,
          ProfileEntityType: entityType,
          ProfileEntityId: entityId,
          FileName: file.name,
          DocData: reader.result.substring(reader.result.indexOf(",") + 1),
          ProfilePicture: true
        }
      };
      
      vgsService("Repository", reqDO, false, function(ansDO) {
        if (functionExists("repositoryPickupCallback"))
          repositoryPickupCallback(ansDO.Answer.Save.RepositoryId);
        
        $(obj).removeClass("drag-over");
        dlg.remove();
      });
    };
    reader.readAsDataURL(file);
  }
}

function doTicketChangePriority(portfolioId, ticketIDs) {
  var reqDO = {
    Command: "ChangePriority",
    ChangePriority: {
      AutoPriorityOrder: true,
      Portfolio: {
        PortfolioId: portfolioId
      },
      TicketList: []
    }
  };
  
  for (var i=0; i<ticketIDs.length; i++) {
    reqDO.ChangePriority.TicketList.push({
      Ticket: {
        TicketId: ticketIDs[i]
      }
    });
  }
  
  showWaitGlass();
  vgsService("Ticket", reqDO, false, function() {
    hideWaitGlass();
  });
}


<%@ include file="tree.js" %>
<%@ include file="combo.js" %>
<%@ include file="dyncombo.js" %>
<jsp:include page="lkdialog-js.jsp"/>
<jsp:include page="entity-page-js.jsp"/>
<%@ include file="menu.js" %>
<jsp:include page="tooltip-js.jsp"/>
<%@ include file="repository_file_drop.js" %>
<%@ include file="ajax_page_load.js" %>
<%@ include file="side-filter.js" %>
<%@ include file="colorpicker.js" %>
<%@ include file="switch.js" %>
<%@ include file="tabs.js" %>
<%@ include file="nav-wizard.js" %>
<%@ include file="async_process_dialog.js" %>
<%@ include file="icon-alias.js" %>
<%@ include file="crud_control.js" %>
<%@ include file="task-progress-bar.js" %>
<%@ include file="common-mark-listener.js" %>
<%@ include file ="input-upload-drop.js" %>
<%@ include file="metafield-picture.js" %>
<%@ include file="richdesc.js" %>
<%@ include file="cfgform.js" %>
<%@ include file="cal-month.js" %>
<%@ include file="visibility-controller.js" %>
<%@ include file="doc-view-bind.js" %>
<%@ include file="upload-tile.js" %>
<%@ include file="date-picker.js" %>
<%@ include file="time-picker.js" %>

function parentPickupSelItem(elem, obj) {
  var $elem = $(elem); 
  if ($elem.attr("id") == obj.ItemId)
    showMessage(itl("@Common.PasteErrorRecursive"));
  else {
    $elem.attr("data-ItemURL", obj.ItemURL);
    $elem.find(".parent-EntityId").val(obj.ItemId);
    $elem.find(".parent-EntityType").val(obj.ItemEntityType);
    $elem.find(".v-combobtn-caption").text(obj.ItemName);
    $elem.removeClass("empty");
    onFieldChanged({target:elem});
  }
}

function showParentPickupDialog(elem) {
  var $elem = $(elem);
  var urlo = $elem.attr("data-ItemURL");
  if (event.ctrlKey && (urlo) && (urlo != ""))
    window.open(urlo);
  else if (!$elem.hasClass("disabled")) {
    if ($elem.attr("data-EntityTypes").split(",").length > 1)    
      entityTypes = $elem.attr("data-EntityTypes").split(",");
    else
      entityTypes = null;
    showLookupDialog({
      EntityType: $elem.attr("data-DefEntityType"),
      EntityTypes: entityTypes,
      onPickup: function(item) {     
        parentPickupSelItem(elem, {
          ItemId: item.ItemId,
          ItemEntityType: item.ItemEntityType,
          ItemName: item.ItemName,
          ItemCode: item.ItemCode,
          IconName: item.IconName,
          ProfilePictureId: item.ProfilePictureId,
          ItemURL: item.ItemURL
        });
      }
    });
  }
};

function showHistoryLog(entityType) {
  var urlo = BASE_URL + "/admin?page=historylog_list" + "&EntityType=" + entityType;
  window.open(urlo, '_self');
}

function showTagPickupDialog(btn) {
  var combo = $(btn).closest(".v-combobtn");
  if (!combo.is(".disabled")) {
    var entityType = combo.attr("data-EntityType");
    var handlerId = (new Date()).getTime();
    var formTitle = combo.attr("data-FormTitle");
    formTitle = (formTitle) ? formTitle : "";
    if (formTitle == "") 
      formTitle = combo.closest(".form-field").find(".form-field-caption").text();
    
    combo.attr("data-HandlerId", handlerId);
    asyncDialogEasy("common/tag_pickup_dialog", "EntityType=" + entityType + "&HandlerId=" + handlerId + "&FormTitle=" + encodeURIComponent(formTitle));
    event.stopPropagation();
  }
}

function comboBtnClear(btn) {
  var combo = $(btn).closest(".v-combobtn");
  combo.find("input").val("");
  combo.find(".v-combobtn-caption").html("&nbsp;");
  combo.addClass("empty");
  if (event)
    event.stopPropagation();
  onFieldChanged({target:combo});
}

function comboBtnCallback(handlerId, tagId, tagCode, tagName) {
  $("[data-HandlerId='" + handlerId + "']").vcombobtn_SetValue(tagId, tagCode, tagName);
}

jQuery.fn.vcombobtn_SetValue = function(id, code, name) {
  var handler = $(this);
  if (id == null)
    comboBtnClear(this);
  else {
    var caption = name;
    if (code != "")
      caption = "[" + code + "] " + caption;

    handler.find("input").val(id);
    handler.find(".v-combobtn-caption").text(caption);
    handler.removeClass("empty");
  }
};

function enableNameExt(elem) {
  $(elem).closest(".form-field").find(".form-field-value #name-ext-container").setClass("v-hidden", !$(elem).isChecked());
}



var old_jquery_dialog_open = $.ui.dialog.prototype.open;
$.ui.dialog.prototype.open = function() {
  old_jquery_dialog_open.apply(this, arguments);
  this.uiDialogTitlebar.find(".ui-dialog-titlebar-close").html("<i class='fa fa-times'></i>");
  this.uiDialogButtonPane.find("button").addClass("btn btn-default");
};

/**
 * detect IE
 * returns version of IE or false, if browser is not Internet Explorer
 */
function detectIE() {
  var ua = window.navigator.userAgent;
  var msie = ua.indexOf('MSIE ');
  if (msie > 0) {
    // IE 10 or older => return version number
    return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
  }
  var trident = ua.indexOf('Trident/');
  if (trident > 0) {
    // IE 11 => return version number
    var rv = ua.indexOf('rv:');
    return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
  }
  var edge = ua.indexOf('Edge/');
  if (edge > 0) {
    // Edge (IE 12+) => return version number
    return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10);
  }
  // other browser
  return false;
}

$.fn.removeInactiveOptions = function() {
  var $this = $(this);
  $this.find("option.inactive").not("[value='" + $this.val() + "']").remove();
  return $this;
};

String.prototype.toSentenceCase = function() {
  return (this.length == 0) ? "" : this[0].toUpperCase() + this.slice(1).toLowerCase();
}

String.prototype.toPascalCase = function() {
  var out = "";
  this.split(" ").forEach(function(item, idx) {
    if (idx > 0)
      out += " ";
    out += item[0].toUpperCase() + item.slice(1).toLowerCase();
  });
  return out;
}

function convertPriceValue(value) {
  var result = null;
  if (value) {
    value = value.replace(",", ".");
    if (value != "") {
      result = parseFloat(value);
      if (isNaN(result))
        result = null;
    }
  }
  return result;
}

function currencyValidation(value){
  if(value==''){
    return {  valid: true,
              currency: ''
           };
    }
  var commaCleanValue = value.replace(",", ".");
  var floatValue = parseFloat(commaCleanValue);
  return {  valid: !isNaN(floatValue),
            currency: floatValue
         };
}

function showNotification(content, style) {
	style = (style) ? style : "success";
	var op = 0;
	var $alert = $("<div class='success-notification-visible alert alert-" + style + " alert-dismissible' style='opacity:0'/>");
	$alert.append("<a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a>");
	$alert.append(content);
	$alert.appendTo("#notification-box");
	
	function _setOpacity(opacity) {
	  op = opacity;
	  $alert.css("opacity", op);
  }
	
	function _alertFadeIn() {
	  _setOpacity(op + 0.1);
	  if (op < 1)
	    setTimeout(_alertFadeIn, 10);
	  else
	    setTimeout(_alertFadeOut, 3000);
  }
	
	function _alertFadeOut() {
	 if (!$alert.is(".mouseover"))
	   _setOpacity(op - 0.05);
	 if (op <= 0)
	   $alert.remove();
	 else 
	   setTimeout(_alertFadeOut, 100);
	}
	
  $alert.on("mouseover", function() {
    $alert.addClass("mouseover");
    _setOpacity(1);
  });

  $alert.on("mouseout", function() {
    $alert.removeClass("mouseover");
  });

  _alertFadeIn();
}

function showTransactionRecapDialog(data) {
  var dlg = $("<div class='recap-dialog'></div>");
  
  if ((data.PaymentStatus) && (data.PaymentStatus != <%=LkSNPaymentStatus.Approved.getCode()%>)) {
    var errorbox = $("<div class='errorbox'/>").appendTo(dlg);
    $("<div></div>").appendTo(errorbox).text(itl("@Payment.NotApprovedError") + ":");
    $("<div></div>").appendTo(errorbox).html("<p>");
    $("<div></div>").appendTo(errorbox).text(data.ErrorMessage);
  }
  else {
    $("<div></div>").appendTo(dlg).text(itl("@Common.TransactionPostedOK"));
    if (data.AuthorizationCode) 
      dlg.append("<p>" + itl("@Payment.AuthorizationCode") + ": <b>" + data.AuthorizationCode + "</b>");
    dlg.append("<p>PNR: <a href='<%=pageBase.getContextURL()%>?page=sale&id=" + data.SaleId + "'><b>" + data.SaleCode + "</b></a>");
    
    if ((data.OrganizationInventoryBuild != <%=LkSNTransactionType.OrganizationInventoryBuild.getCode()%>) && (<%=pageBase.getRights().B2BAgent_PahDownloadOption.getInt()%> > 0) && (data.PahRelativeUrl != undefined)) {    
      var href = 'javascript:doPrintAtHome("' + data.PahRelativeUrl + '")';
      dlg.append("<p>" + itl("@Common.PrintAtHome") + ":&nbsp;<a href='" + href + "'>" + itl("@Common.ClickHereToDownload") +"</a>");
    }
    
    if (typeof data.AdditionalText != 'undefined') {
    	$("<br/><div></div>").appendTo(dlg).text(data.AdditionalText);
    }
  }
  
  dlg.dialog({
    title: "SnApp",
    modal: true,
    width: 400,
    close: function() {
      dlg.remove();
    },
    buttons: {
      <v:itl key="@Common.Ok" encode="JS"/>: doCloseDialog
    }
  });
}

function showNotificationEasy(title, msg, style) {
  var $content = $("<div/>");
  if (title) 
    $("<h4/>").appendTo($content).text(title);
  if (msg)
    $("<p/>").appendTo($content).text(msg);
  showNotification($content, style);
}

function openEntityLink(entityType, entityId, newTab) {
  if ((entityType) && (entityType >= 0) && (entityId) && (entityId != "")) {
    var url = getPageURL(entityType, entityId);
    if (url) {
      if (url.indexOf("javascript:") >= 0) 
        eval(url.substr("javascript:".length));
      else {
        if (newTab == true) 
          window.open(url);
        else
          window.location = url;
      } 
    }
  }
}

/**
 * Checks both <b>SearchesMinDate</b> and <b>SearchesMaxPastDays</b> rights.</br>
 * The more restrictive one sets the farthest allowed date in the past for searches.</br>
 * @param dateFrom
 */
function checkSearchesDateRights(todayDate, dateFrom, rightSearchesMinDate, rightSearchesMaxPastDays) {
	var invalidDateFrom = false; 
	var checkSearchMinDate = !(rightSearchesMinDate === null);
	var checkSearchMaxPastDays = rightSearchesMaxPastDays != 0;
	var dateSearchesMinDate = new Date(rightSearchesMinDate);
	var errMsg = "";
    
	if ((checkSearchMinDate || checkSearchMaxPastDays)) {
    var maxDaysSearchDate = new Date(todayDate); 
    maxDaysSearchDate.setDate(maxDaysSearchDate.getDate() - rightSearchesMaxPastDays);
    checkSearchMinDate = !checkSearchMinDate ? false : dateSearchesMinDate > maxDaysSearchDate;
    checkSearchMaxPastDays = !checkSearchMaxPastDays ? false : maxDaysSearchDate > dateSearchesMinDate;

    var minDateAllowed = new Date(checkSearchMaxPastDays ? maxDaysSearchDate : dateSearchesMinDate);
    invalidDateFrom = minDateAllowed > dateFrom;

    if (checkSearchMinDate && invalidDateFrom) 
    	errMsg = itl("@Common.SearchesMinDate", rightSearchesMinDate);
    else if (checkSearchMaxPastDays && invalidDateFrom) 
    	errMsg = itl("@Common.SearchesMaxPastDays", rightSearchesMaxPastDays);
	}
	
	if (invalidDateFrom) { 
		showMessage(errMsg);
	  return false;
	}
	    
	return true;
}

function checkMaxDateRange(dateFrom, dateTo, searchesMaxDateRange) {
	var rangeDays = (dateTo - dateFrom)/1000/60/60/24;
  if ((searchesMaxDateRange!=0) && ((dateFrom==null || dateTo==null) || rangeDays > searchesMaxDateRange)) {
	  showMessage(itl("@Common.MaxSearchesDateRangeExceeded", searchesMaxDateRange));
	  return false;
  }
  return true;
}

function getGridSelectionBean(gridSelector, checkBoxSelector) {
  var result = {
    ids: "",
    queryBase64: ""
  };

  var $grid = $(gridSelector);
//Check if the grid or any of its children have the "multipage-selected" class
  var $multipageSelected = $grid.add($grid.find("*")).filter(".multipage-selected");
  
  result.ids = $grid.find(checkBoxSelector).filter(":checked").map(function () {return this.value;}).get().join(",");
  if (result.ids.length == 0) {
    result = null;
    showMessage(itl("@Common.NoElementWasSelected"));
  }
  else if ($multipageSelected.length > 0) {
    result.ids = "";
    result.queryBase64 = encodeURIComponent($multipageSelected.attr("data-QueryBase64"));
  }
  
  return result;
}

function showMultiEditDialog(entityType, gridSelector, checkBoxSelector) {
  var bean = getGridSelectionBean(gridSelector, checkBoxSelector);
  if (bean)
    asyncDialogEasy("common/multiedit_dialog", "EntityType=" + entityType + "&EntityIDs=" + bean.ids + "&QueryBase64=" + bean.queryBase64);
}

function resizeDialogWidth(dialogSelector, newWidth) {
  var $dlg = $(dialogSelector);
  $dlg.css("height", "");

  var $parent = $dlg.parents(".ui-dialog");
  $parent.width(newWidth);
  $parent.css("left", (($(window).width() - newWidth) / 2) + "px");
}

$(document).on("change", ".input-group select", function(e) {
  var $this = $(this);
  $this.closest(".input-group").find(".combo-link-btn").attr("disabled", $this.val() == "");
});

$(document).on("click", ".combo-link-btn", function(e) {
  var $this = $(this);
  var $dyncombo = $this.closest(".v-dyncombo");
  
  if ($dyncombo.length > 0) {
    var entityType = strToIntDef($dyncombo.attr("data-entitytype"), -1);
    var entityId = $dyncombo.val();
    openEntityLink(entityType, entityId, true);
  }
  else {
    var entityType = strToIntDef($this.closest(".input-group").find("select").attr("data-entitytype"), -1);
    var entityId = $this.closest(".input-group").find("select").val();
    openEntityLink(entityType, entityId, true);
  }
});

$(document).on("click", ".selectize-control .item", function(e) {
  var $item = $(this);
  var entityType = strToIntDef($item.closest(".selectize-control").prev("select.selectized").attr("data-entitytype"), -1);
  openEntityLink(entityType, $item.attr("data-value"), true);
});

$(document).on("keypress", "input", function() {
  if (event.keyCode == KEY_ENTER) { 
    event.preventDefault();
    $(this).trigger("enterKeyPressed");
  }
});



//--- Save bind ---//

function onFieldChanged(e, form) {
  if ((e == null) || (e.target == null) || !$(e.target).is(".cblist")) {
    var $form = null;
    if (form != null)
      $form = $(form);
    else if (e != null) 
      $form = $(e.target).closest("form.track-changes");

    if ($form != null) {
      $form.addClass("data-changed");
      $form.find(".bind-save").removeAttr("disabled");
    }
  }
}

$(document).on("change", onFieldChanged);
$(document).on("keypress", "input.form-control", onFieldChanged);
$(document).on("keyup", "input.form-control", function(e) {
  if (e.keyCode == KEY_BACKSPACE)
    onFieldChanged(e);
});

function hasUnsavedData() {
  return $("form.track-changes.data-changed").length > 0;
}

window.addEventListener("beforeunload", function (e) {
  if (hasUnsavedData()) {
    var confirmationMessage = itl("@Common.DiscardChangesConfirm");
    (e || window.event).returnValue = confirmationMessage; //Gecko + IE
    return confirmationMessage; //Gecko + Webkit, Safari, Chrome etc.
  }
  else
    return false;
});

function calcEntityRightDesc(entityType) {
  switch (entityType) {
  case <%=LkSNEntityType.DistributionChannel.getCode()%>:   return itl("@Common.DistributionChannel"); 
  case <%=LkSNEntityType.Location.getCode()%>:              return itl("@Account.Location"); 
  case <%=LkSNEntityType.OperatingArea.getCode()%>:         return itl("@Account.OpArea"); 
  case <%=LkSNEntityType.Workstation.getCode()%>:           return itl("@Common.Workstation");
  case <%=LkSNEntityType.Organization.getCode()%>:          return itl("@Account.Organization");
  case <%=LkSNEntityType.Category_Organization.getCode()%>: return itl("@Category.Category");
  case <%=LkSNEntityType.Person.getCode()%>:                return itl("@Account.Person");
  case <%=LkSNEntityType.Role.getCode()%>:                  return itl("@Common.SecurityRole");
  case <%=LkSNEntityType.SaleChannel.getCode()%>:           return itl("@SaleChannel.SaleChannel");
  case <%=LkSNEntityType.ResOwnerNone.getCode()%>:          return itl("@Account.OrderOwner");
  case <%=LkSNEntityType.ResOwnerPerson.getCode()%>:        return itl("@Account.Person");
  case <%=LkSNEntityType.Account_All.getCode()%>:           return itl("@Account.Account");
  case <%=LkSNEntityType.ProductType.getCode()%>:           return itl("@Product.ProductType");
  }
  return "Unknown";
}

function getLookupDesc(tableObj, itemCode) {
  for (const [key, item] of Object.entries(tableObj)) 
    if (item.code === itemCode)
      return item.desc;
  return null;
}

function dialogButton(text, click, id) {
  var result = {
    "text": itl(text),
    "click": click
  };
  
  if (id)
    result["id"] = id;
  
  return result;
}

function isLogEnabled() {
  return (localStorage.getItem("snp-log-enabled") === "true");
}

var _console_log = console.log;
console.log = function(p) {
  if (isLogEnabled())
    _console_log(p);
};

function convertRichDescWidgetList(wList) {
  var result = [];
  wList.forEach(function (item, index) {
    result.push({
      LangISO: item.LangISO,
      Description: item.Translation 
    })
  });
  return result;
}

function getSearchKeys(text) {
  var result = [];
  for (const key of (text || "").split(" ")) {
    if (key.trim().length > 0)
      result.push(key.trim().toLowerCase());
  }
  return result;
}

function isTextFullSearch(text, keys) {
  if (text) {
    for (const key of keys) {
      if (text.toLowerCase().indexOf(key) < 0)
        return false;
    }
    return true;
  }
  return false;
}

function getFieldValue($elem) {
  $elem = $($elem);
  
  if ($elem.is(".v-datepicker"))
    return $elem.getXMLDate();
  
  if ($elem.is("input[type=checkbox]"))
    return $elem.isChecked();
  
  return $elem.val();
} 

$.fn.initMultiBox = function() {
  var $this = $(this);
  $this.removeClass("form-control");
  $this.attr("multiple", "multiple");
  $this.selectize({
    dropdownParent: "body",
    plugins: ["remove_button","drag_drop"]
  });
  return $this;
}

$.fn.setCommonStatusStyle = function(color) {
  if (getNull(color) == null) 
    color = "rgba(0,0,0,0)";

  $(this).css("border-left", "4px " + color + " solid");
}

$(document).ready(function() {
  $(window).on("resize", _heightToBottom);
  
  snpObserver.registerListener("v-height-to-bottom", null, _heightToBottom);

  function _heightToBottom() {
    var $wnd = $(window);
    $(".v-height-to-bottom").each(function() {
      var $elem = $(this);
      $elem.css("height", $wnd.height() - $elem.offset().top + "px");
    });
  }
});

/**
 * Async function which returns a  com.vgs.snapp.dataobject.DODocEditorFile JSON
 *
 * @options: see window.showOpenFilePicker options
 */
function asyncUploadFileEasy(options) {
  var $dlg = $("<div><div class='progress' style='margin-top:20px'><div class='progress-bar bg-green'></div></div></div>").dialog({
    title: itl("@Common.PleaseWait"),
    modal: true
  });
   
  return new Promise((resolve, reject) => {
    asyncUploadFile(options)
      .then(docEditorFiles => __doUpload(docEditorFiles[0]))
      .then(responseJSON => {
        __closeDialog();
        resolve(responseJSON);
      })
      .catch(error => {
        __closeDialog();
        if (!isAbortError(error))
          showIconMessage("warning", error);
      });
  });
   
  function __closeDialog() {
    $dlg.dialog("close");
    $dlg.remove();
  } 
    
  function __doUpload(docEditorFile) {
    return new Promise((resolve, reject) => {
      $.ajax({  
        url: BASE_URL + "/FileUploadServlet",
        type: "POST",
        data: JSON.stringify(docEditorFile),
        dataType: "json",
        contentType: "application/json",
        xhr: __progressListener,
        complete: function(jqXHR, textStatus) {
          try {
            if (jqXHR.status == 200) {
              if (jqXHR.responseJSON.IsUploadable !== true) 
                throw jqXHR.responseJSON.ErrorMessage;
  
              resolve(jqXHR.responseJSON);
            }
            else 
              throw itl("@Common.GenericError");
          }
          catch (error) {
            reject(error);
          }
        }
      });
    });
  }
  
  function __progressListener() {
    var xhr = new window.XMLHttpRequest();
    xhr.upload.addEventListener("progress", function(evt) {
      if (evt.lengthComputable) {
        var perc = (evt.loaded / evt.total) * 100;
        $dlg.find(".progress-bar").css("width", perc + "%");
      }
    }, false);
    return xhr;
  }
}

<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
</script>
<% } %>
