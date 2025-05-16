<%@page import="java.util.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String ticketId = pageBase.getId();
String gateCategoryId = pageBase.getNullParameter("GateCategoryId");
DOTicket ticket = pageBase.getBL(BLBO_Portfolio.class).getPortfolioTicket(ticketId);
List<DOLedgerClearing> list = (gateCategoryId == null) ? ticket.LedgerClearingList.getItems() : ticket.LedgerClearingList.filter(it -> it.GateCategoryId.isSameString(gateCategoryId));
%>

<v:dialog id="ledger_dialog" title="@Ledger.ClearingUsed" width="800" height="600" autofocus="false">

<v:grid>
  <thead>
    <tr>
      <td width="120px"><v:itl key="@Common.DateTime"/></td>
      <td><v:itl key="@Ledger.TriggerType"/></td>
      <td><v:itl key="@Product.GateCategory"/></td>
      <td align="right"><v:itl key="@Common.Amount"/></td>
    </tr>
  </thead>
  <tbody>
    <% for (DOLedgerClearing item : list) { %>
      <tr class="grid-row">
        <td><snp:datetime timestamp="<%=item.LedgerDateTime%>" format="shortdatetime" timezone="local"/></td>
        <td><%=item.LedgerTriggerType.getHtmlLookupDesc(pageBase.getLang())%></td>
        <td>
          <% if (item.GateCategoryId.isNull()) { %>
            <span class="list-subtitle"><v:itl key="@Common.None"/></span>
          <% } else { %>
            <snp:entity-link entityId="<%=item.GateCategoryId%>" entityType="<%=LkSNEntityType.GateCategory%>" clazz="entity-tooltip">
              <%=item.GateCategoryName.getHtmlString()%>
            </snp:entity-link>
          <% } %>
        </td>
        <td align="right"><%=pageBase.formatCurrHtml(item.DeltaAmount)%></td>
      </tr>
    <% } %>
  </tbody>
</v:grid>

<script>

$(document).ready(function() {
  var $dlg = $("#ledger_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Close", doCloseDialog)
    ];
  });
});

</script>

</v:dialog>

