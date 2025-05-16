<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
  String accountId = pageBase.getEmptyParameter("AccountId");
  String currentBiometricOverride = pageBase.getEmptyParameter("BiometricOverride"); 
  pageBase.setDefaultParameter("BiometricOverride", currentBiometricOverride);
%>

<v:dialog id="account-bio-override-dialog" title="@Ticket.BiometricOverrideLevel" width="400" height="200">
  <v:form-field caption="@Ticket.BiometricOverrideLevel">
  	<select name="BiometricOverride" id="BiometricOverride" class="form-control">
  	<% for (LookupItem item : LkSN.BiometricTicketOverrideType.getItems()) { %>
  	  <% String disabled = !LkSNBiometricOverrideLevel.isEnabled(pageBase.getRights().BiometricOverrideLevel.getLkValue(), item) ? "disabled" : ""; %>
  	  <% String selected = item.getCode() == JvString.strToIntDef(currentBiometricOverride, 0) ? "selected" : ""; %>
  	  <option value="<%=item.getCode()%>" <%=disabled%> <%=selected%>><%=item.getHtmlDescription(pageBase.getLang())%></option>
  	<% } %>
    </select>
  </v:form-field>

<script>
$(document).ready(function() {
  var dlg = $("#account-bio-override-dialog");
  
  $("#BiometricOverride").change(enableDisableBtn);
  
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        id: "btn-confirm",
        text: itl("@Common.Confirm"),
        click: confirmOverride,
        disabled: $("#BiometricOverride").val() == <%=currentBiometricOverride%>
      },
      {
        text: itl("@Common.Close"),
        click: doCloseDialog
      }
    ]
  });
  
  
});

function confirmOverride() {
	var reqDO = {
	  Command: "SaveAccount",
	    SaveAccount: {
	      AccountId : <%=JvString.jsString(accountId)%>,
	      BiometricOverride: $("#BiometricOverride").val()
	    }
	  };
	
	showWaitGlass();
	vgsService("Account", reqDO, false, function(ansDO) {
	  window.location.reload();
	  hideWaitGlass(); 
	});
}

function enableDisableBtn() {
  $("#btn-confirm").attr("disabled", $("#BiometricOverride").val() == <%=currentBiometricOverride%>);
}
</script>

</v:dialog>