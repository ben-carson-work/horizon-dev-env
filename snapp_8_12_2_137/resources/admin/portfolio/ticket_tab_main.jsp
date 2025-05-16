<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>
<jsp:useBean id="ticketRights" class="com.vgs.snapp.dataobject.ticket.DOTicketRights" scope="request"/>


<% String ticketId = pageBase.getId(); %> 

<script>

function showBiometricOverrideDialog() {
  var params = "TicketId=<%=pageBase.getId()%>" + "&BiometricOverride=" + <%=ticket.BiometricTicketOverride.getInt()%>;
  asyncDialogEasy("portfolio/biometric_override_dialog", params);
}

</script>

<v:tab-toolbar include="<%=ticketRights.CRUD.canUpdate()%>">
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Ticket%>"/>
  
  <v:button-group>
    <%
    boolean showStatusButton = (ticket.TicketStatus.getInt() < LkSNTicketStatus.GoodTicketLimit);
    boolean blocked = ticket.TicketStatus.isLookup(LkSNTicketStatus.ManuallyBlocked, LkSNTicketStatus.SupervisorBlocked);
    String statusButtonIcon    = blocked ? "unlock" : "lock";
    String statusButtonCaption = blocked ? "@Common.Unblock" : "@Common.Block";
    String statusButtonValue   = blocked ? "unblock" : "block";
    String clickStatus = "asyncDialogEasy('portfolio/ticket_update_dialog', 'ticketIDs=" + pageBase.getId() + "&ticketStatus=" + statusButtonValue + "&TicketUpdateSteps=" + LkSNTicketUpdateStep.Status.getCode() + "')";
    %>  
    <v:button caption="<%=statusButtonCaption%>" fa="<%=statusButtonIcon%>" onclick="<%=clickStatus%>" enabled="<%=ticketRights.BlockUnblock.getBoolean()%>" include="<%=showStatusButton%>"/>

    <% String clickChangeValidity = "asyncDialogEasy('portfolio/ticket_update_dialog', 'ticketIDs=" + pageBase.getId() + "&TicketUpdateSteps=" + LkSNTicketUpdateStep.Validity.getCode() + "')"; %>
    <v:button caption="@Common.Validity" fa="calendar-alt" onclick="<%=clickChangeValidity%>" enabled="<%=ticketRights.ValidityButton.getBoolean()%>"/>
  </v:button-group>
  
  <% String tckPaid = ticket.Paid.getBoolean()? "true" : "false"; %>
  <% String clickLedger = "asyncDialogEasy('ledger/ledgermanual_dialog', 'TicketId=" + pageBase.getId() + "&TicketPaid=" + tckPaid + "')"; %>
  <v:button caption="@Ledger.LedgerManualEntry" fa="money-check-edit-alt" onclick="<%=clickLedger%>" enabled="<%=ticketRights.LedgerManualEntry.getBoolean()%>"/>
  <v:button caption="@Ticket.BiometricOverrideLevel" fa="fingerprint" onclick="showBiometricOverrideDialog()" enabled="<%=ticketRights.BiometricOverride.getBoolean()%>" include="<%=!ticket.BiometricCheckLevel.isLookup(LkSNBiometricCheckLevel.None)%>"/>
  
  <% String manualRedemptionOnClick = "asyncDialogEasy('portfolio/manual_redemption_dialog', 'ticketId=" + pageBase.getId() + "')"; %>
  <v:button caption="@Lookup.TransactionType.ManualRedemption" fa="scanner" onclick="<%=manualRedemptionOnClick%>" enabled="<%=rights.ManualRedemption.getBoolean()%>"/>
</v:tab-toolbar>

<v:tab-content>
  <table class="recap-table" style="width:100%">
    <tr>
      <%-- TICKET --%>
      <td width="33%">     
        <jsp:include page="ticket_tab_main_ticket_widget.jsp"></jsp:include>
      </td>
      
      <%-- PRODUCT TYPE --%>
      <td width="33%">
        <jsp:include page="ticket_tab_main_product_widget.jsp"></jsp:include>
        <jsp:include page="ticket_tab_main_revenue_widget.jsp"></jsp:include>
        <jsp:include page="ticket_tab_main_resource_widget.jsp"></jsp:include>
        <jsp:include page="ticket_tab_main_biometric_widget.jsp"></jsp:include>
        <jsp:include page="ticket_tab_main_incprod_widget.jsp"></jsp:include>
        <jsp:include page="ticket_tab_main_revalidate_widget.jsp"></jsp:include>
      </td>     

      <%-- PORTFOLIO --%>
      <td width="33%">
        <jsp:include page="ticket_tab_main_portfolio_widget.jsp"></jsp:include>
      </td>     
    </tr>
  </table>

  <% if (rights.RedemptionLog.getBoolean()) { %>
    <div>
      <v:widget caption="@Ticket.Usages">
        <v:widget-block> 
          <v:button id="btn-voidable-only" caption="@Media.ShowVoidableScanOnly" title="@Media.ShowVoidableScanOnlyHint"/>
          <v:pagebox gridId="accesslog-grid"/>
        </v:widget-block>
      </v:widget>
  
      <% String params = "TicketId=" + pageBase.getId(); %>
      <v:async-grid id="accesslog-grid" jsp="accesslog_grid.jsp" params="<%=params%>"/>
    </div>
  <% } %>

  <% request.setAttribute("listTimedTicketStatement", ticket.TimedTicketStatementList.getItems()); %>
  <jsp:include page="../product/timedticket/timedticketstatement_widget.jsp"></jsp:include>
</v:tab-content>

<script>

$(document).ready(function() {
  $("#btn-voidable-only").click(function() {
    var $btn = $(this);
    var active = !$btn.is(".active");
    var ticketId = <%=JvString.jsString(pageBase.getId())%>;
    $btn.setClass("active", active);
    setGridUrlParam("#accesslog-grid", "VoidableOnly", active ? true : "");
    setGridUrlParam("#accesslog-grid", "TicketId", ticketId, true);
  });  

});
</script>
