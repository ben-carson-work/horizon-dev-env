<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.BLBO_DocTemplate"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% String accountId = pageBase.getId(); %>

<v:dialog id="changeotherpassword_dialog" title="@Common.ChangePassword" width="640">

<v:widget>
  <v:widget-block>
    <v:form-field caption="@Common.PasswordNew">
      <v:input-text type="password" field="NewPassword" autocomplete="false"/>
    </v:form-field>
    <v:form-field caption="@Common.PasswordNewRepeat">
      <v:input-text type="password" field="NewPasswordConfirm" autocomplete="false"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $dlg = $("#changeotherpassword_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Ok", doChangePassword),
      dialogButton("@Common.Cancel", doCloseDialog)
    ];
  });
  
  function doChangePassword() {
    var newPassword = $dlg.find("#NewPassword").val();
    var newPasswordConfirm = $dlg.find("#NewPasswordConfirm").val();
    
    if (newPassword != newPasswordConfirm) 
      showIconMessage("warning", itl("@Common.PasswordMismatch"));
    else {
      snpAPI
        .cmd("Account", "SaveAccount", {
          AccountId: <%=JvString.jsString(accountId)%>,
          AccountLogin: {
            Password: newPassword,
            PasswordConfirm: newPasswordConfirm
          }
        })
        .then(() => $dlg.dialog("close"));
    }
  }
});
</script>

</v:dialog>