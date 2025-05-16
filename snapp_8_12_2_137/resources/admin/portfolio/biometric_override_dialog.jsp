<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
  String ticketId = pageBase.getEmptyParameter("TicketId");
  String currentBiometricOverride = pageBase.getEmptyParameter("BiometricOverride"); 
  pageBase.setDefaultParameter("BiometricOverride", currentBiometricOverride);
%>

<v:dialog id="bio-override-dialog" title="@Ticket.BiometricOverrideLevel" width="600" height="400">
  <v:form-field caption="@Ticket.BiometricOverrideLevel">
    <select name="BiometricOverride" id="BiometricOverride" class="form-control">
    <% for (LookupItem item : LkSN.BiometricTicketOverrideType.getItems()) { %>
      <% String disabled = !LkSNBiometricOverrideLevel.isEnabled(pageBase.getRights().BiometricOverrideLevel.getLkValue(), item) ? "disabled" : ""; %>
      <% String selected = item.getCode() == JvString.strToIntDef(currentBiometricOverride, 0) ? "selected" : ""; %>
      <option value="<%=item.getCode()%>" <%=disabled%> <%=selected%>><%=item.getHtmlDescription()%></option>
    <% } %>
    </select>
  </v:form-field>
  <v:form-field caption="@Common.Notes">
    <v:input-txtarea field="BioOverrideNote" rows="12"/>
  </v:form-field>
<script>

$(document).ready(function() {
  var dlg = $("#bio-override-dialog");
  
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
      Command: "UpdateTicket",
      UpdateTicket: {
        TicketList: [{
          TicketId: <%=JvString.jsString(ticketId)%>
        }],
        OverrideBiometric: $("#BiometricOverride").val(),
        AddNote: $("#BioOverrideNote").val()
      }
    };
    showWaitGlass();
    vgsService("Ticket", reqDO, false, function(ansDO) {
      window.location.reload();
      hideWaitGlass(); 
    });
}

function enableDisableBtn() {
  $("#btn-confirm").attr("disabled", $("#BiometricOverride").val() == <%=currentBiometricOverride%>);
}
</script>

</v:dialog>