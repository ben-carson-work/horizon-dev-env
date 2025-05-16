<%@page import="com.vgs.web.library.BLBO_DBInfo"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.LkSNErrorCode"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% 
String errorStyle = "'color:red;font-weight:bold;text-align:center'";
String moreInfoStyle = "'color:black;font-weight:bold;text-align:center'";
%>

<v:dialog id="forgot_password_dialog" title="@Login.ForgotPasswordDialogTitle" width="600" height="450" autofocus="true">
  <v:alert-box type="info">
     <div><v:itl key="@Login.ForgotPasswordLine1"/></div>
     <div style="margin-top:10px"><v:itl key="@Login.ForgotPasswordLine2"/></div>
     <div style="margin-top:30px"><v:itl key="@Login.ForgotPasswordLine3"/></div>
  </v:alert-box>
  <v:input-text field="loginUserName" placeholder="@Login.UserEmailPlaceholder"/>
  <div id="err-msg"></div>
  
<style>
#forgot_password_dialog {
  background-color: white;
  padding: 20px;
  color: rgba(0,0,0,0.8);
}

#forgot_password_dialog, 
#forgot_password_dialog input {
  font-size: 16px;
}

#forgot_password_dialog .form-field {
  margin: 0;
  margin-bottom: 10px;
}
#forgot_password_dialog .form-field-caption {
  width: 190px;
} 
#forgot_password_dialog .form-field-value {
  margin-left: 200px;
} 
.ui-dialog-buttonset .btn {
  margin-left: 4px;
}
</style>
  
<script>

$(document).ready(function() {
  var dlg = $("#forgot_password_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: itl("@Common.Continue"),
        click: doContinue
      },
      {
        text: itl("@Common.Clear"),
        click: doClear
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ]; 
  });
  
  dlg.keypress(function() {
    if (event.keyCode == KEY_ENTER)
      doContinue();
  });

  function doContinue() {
    $("#err-msg").html("");
    if ($("#loginUserName").val() != "") {
      var reqDO = {
          Command: "ForgotPassword",
          ForceWorkstationId: <%=JvString.jsString(BLBO_DBInfo.getWorkstationId_BKO())%>,
          ForgotPassword: {
            UserName: $("#loginUserName").val()
          }
        };
        
        vgsService("Login", reqDO, true, function(ansDO) {
          var errorCode = 200;
          var errorMessage = getVgsServiceError(ansDO);
          if (errorMessage != null)
            errorCode = ansDO.Header.StatusCode;
          
          if (errorMessage != null) 
            $("#err-msg").html(errorMessage);
          
          $('#err-msg').attr('style',<%=errorStyle%>);
          if (errorCode == <%=LkSNErrorCode.ForgotPasswordEmailFailed.getCode()%>)
            $("#loginEmail").focus();
          else if (errorCode != 200) {
            $("#form-field-username").find(".form-field-caption").text(itl("@Login.UserEmailPlaceholder"));
            $("#loginEmail").val("");
          }
          else { 
            $("#forgot_password_dialog").dialog("close");
            showMessage(itl("@Login.ForgotPasswordAcknoledge"));
          }
        });
    }
    else {
      doClear();
      $('#err-msg').attr('style',<%=moreInfoStyle%>);
      $("#err-msg").text(itl("@Login.ForgotPasswordLine1"));
      $("#loginUserName").focus();
    }
  }

  function doClear() {
    $("#form-field-username").find(".form-field-caption").text(itl("@Login.UserEmailPlaceholder"));
    $("#loginUserName").val("");
    $("#loginEmail").val("");
    $("#err-msg").html("");
    $("#loginUserName").focus();
  }

});

</script>

</v:dialog>