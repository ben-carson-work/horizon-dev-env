<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<style>
.error {
  border: 1px solid red !important;
}
</style>

<%
String view = pageBase.getParameter("view");
String title = "Log in smart card";
int height = 140;
if ("change_pin".equals(view)) {
  title = "Modifica PIN";
  height = 200;
} else if ("unblock_pin".equals(view)) {
  title = "Sblocca PIN";
  height = 200;
}
%>
<v:dialog id="pin_dialog" icon="smartcard.png" title="<%=title%>" width="400" height="<%=height%>">
  <v:widget-block>
  <% if ("change_pin".equals(view)) { %>
    <v:form-field caption="Vecchio PIN">
  	  <input placeholder="cifre" required="required" type="password" pattern="^[0-9]{8}$" id="oldPin" class="default-focus form-control" maxlength="8" onkeypress="return keypressValidate(this, event);">
  	</v:form-field>
  	<v:form-field caption="Nuovo PIN">
  	  <input placeholder="cifre" required="required" type="password" pattern="^[0-9]{8}$" id="newPin" class="default-focus form-control" maxlength="8" onkeypress="return keypressValidate(this, event);">
  	</v:form-field>
  <% } else if ("unblock_pin".equals(view)) { %>
    <v:form-field caption="PUK">
  	  <input placeholder="cifre" required="required" type="password" pattern="^[0-9]{8}$" id="puk" class="default-focus form-control" maxlength="8" onkeypress="return keypressValidate(this, event);">
  	</v:form-field>
  	<v:form-field caption="Nuovo PIN">
  	  <input placeholder="cifre" required="required" type="password" pattern="^[0-9]{8}$" id="pin" class="default-focus form-control" maxlength="8" onkeypress="return keypressValidate(this, event);">
  	</v:form-field>
  <% } else {%>
    <v:form-field caption="PIN">
      <input placeholder="cifre" required="required" type="password" pattern="^[0-9]{8}$" id="pin" class="default-focus form-control" maxlength="8" onkeypress="return keypressValidate(this, event);">
    </v:form-field>
  <% }%>
  </v:widget-block>
<script>
var dlg = $("#pin_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    {
      text: <v:itl key="@Common.Save" encode="JS"/>,
      click: doSave
    }, 
    {
      text: <v:itl key="@Common.Cancel" encode="JS"/>,
      click: doCloseDialog
    }
  ];
  $(".default-focus").focus();
});

function doSave() {
  var fields = [$('#oldPin'), $('#newPin')];
  if (!sendValidate(fields)) {
    return false;
  }
  if ($('#puk').length > 0) {
    var reqDO = {
        Command: "UnblockPIN",
        UnblockPIN: {
          CodiceCarta: <%=JvString.jsString(pageBase.getParameter("cardCode")) %>,
          PUK: $('#puk').val(),
          PIN: $('#newPin').val()
        }
      };
  } else if ($('#newPin').length > 0) {
    var reqDO = {
        Command: "ChangePIN",
        ChangePIN: {
          CodiceCarta: <%=JvString.jsString(pageBase.getParameter("cardCode")) %>,
          OldPIN: $('#oldPin').val(),
          NewPIN: $('#newPin').val()
        }
      };
  } else {
    var reqDO = {
        Command: "VerifyPIN",
        VerifyPIN: {
          CodiceCarta: <%=JvString.jsString(pageBase.getParameter("cardCode")) %>,
          PIN: $('#pin').val()
        }
      };
  }
  vgsService('siae', reqDO, false, function() {
    triggerEntityChange(<%=LkSNEntityType.SiaeCard.getCode()%>);
    $('#pin_dialog').dialog("close");
  });
};

function keypressValidate(input, event) {
  event = event || window.event;
  $(input).removeClass('error');
  var charCode = event.which || event.keyCode;
  var charStr = String.fromCharCode(charCode);
  // Firefox fires keypress for navigate keys: arrows, backspace, delete
  // but sets charCode to 0
  if (event.charCode !== 0) { 
    var regex = new RegExp('[0-9]+');
    if (!regex.test(charStr)) {
      event.preventDefault();
      return false;
    }
  }
  return true;
};

function sendValidate(fields) {
  for (var i = 0; i < fields.length; ++i) {
    var field = fields[i];
    if (field.length === 0) continue;
    var val = $(field).val();
    var pattern = $(field).attr('pattern');
    var regexp = new RegExp(pattern);
    message = '';
    if (val.length != 8) message = 'Il campo PIN deve essere lungo 8' 
    else if (val === '') message = 'Il campo PIN non può essere vuoto';
    else if (!regexp.test(val)) message = 'Il campo PIN deve essere numerico';
    else continue;
    showMessage(message);
    field.addClass('error');
    return false;
  }
  return true;
};
</script>
</v:dialog>