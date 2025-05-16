<%@page import="com.vgs.web.page.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
LookupItem entityType = LkSN.EntityType.getItemByCode(JvUtils.getServletParameter(request, "EntityType"));
LookupItem transactionType = LkSN.TransactionType.getItemByCode(JvUtils.getServletParameter(request, "TransactionType"));
String entityTDSSN = JvUtils.getServletParameter(request, "EntityTDSSN");
List<DOExternalIdentifier> listExtIDs = pageBase.getBL(BLBO_Plugin.class).getExternalIdentifierList(entityType, entityTDSSN, transactionType);
%>
<v:dialog id="external-identifiers-dialog" width="800" height="450" title="@Common.ExternalIdentifiers">
  <% if ((listExtIDs != null) && !listExtIDs.isEmpty()) { %>
  <v:widget>
    <v:widget-block>
    <% for (DOExternalIdentifier extid : listExtIDs) { %>
      <div class="recap-value-item">
        <span class="recap-value-caption"><%=extid.ExternalIdentifierName.getHtmlString()%></span>
        <span class="recap-value"><%=extid.ExternalIdentifierValue.getHtmlString()%></span>
      </div>
    <% } %>
    </v:widget-block>
  </v:widget>
  <% } %>
  
<script>
$(document).ready(function() {
  var dlg = $("#external-identifiers-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
   		Cancel : {
   			text: <v:itl key="@Common.Close" encode="JS"/>,
   			click: doCloseDialog
   		}
    };
  });
});
</script>
</v:dialog>

