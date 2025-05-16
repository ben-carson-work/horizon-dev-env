<%@page import="com.vgs.snapp.dataobject.DOTicketRef"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicketCancellationDialog" scope="request"/>
<jsp:useBean id="portfolio" class="com.vgs.entity.dataobject.DOEnt_TicketMediaMatch" scope="request"/>

<% PageTicketCancellationDialog.PayMethodList payMethods = pageBase.getAllowedPaymentMethods(portfolio); %>

<div id="void-as-dialog">

<% String[] ticketIDs = new String[0]; %>
<% long amount = 0; %>
<v:grid>
  <thead>
    <tr class="header">
      <td colspan="100%"><v:itl key="@Ticket.Tickets"/></td>
    </tr>
  </thead>
  <tbody>
  <% for (DOTicketRef ticket : portfolio.TicketMediaMatch.TicketList) { %>
    <% if (ticket.TicketStatus.getInt() < LkSNTicketStatus.GoodTicketLimit) { %>
      <% 
      ticketIDs = JvArray.add(ticket.TicketId.getString(), ticketIDs); 
      if (ticket.Paid.getBoolean())  
        amount -= ticket.UnitAmount.getMoney() * ticket.GroupQuantity.getInt(); 
      %>
      <tr class="grid-row">
        <td><v:grid-icon name="<%=ticket.IconName.getString()%>"/></td>
        <td width="50%">
          <%=ticket.TicketCode.getHtmlString()%><br/>
          <span class="list-subtitle"><%=ticket.ProductName.getHtmlString()%></span>
        </td>
        <td width="50%" align="right">
          <% if (!ticket.Paid.getBoolean()) { %>
            <span class="list-subtitle">(<v:itl key="@Ticket.NotPaid"/>)</span>
          <% } %>
        
          <%=pageBase.formatCurrHtml(ticket.UnitAmount.getMoney() * ticket.GroupQuantity.getInt())%><br/>
          <% if (!ticket.GroupTicketOption.isLookup(LkSNGroupTicketOption.NoGroup)) { %>
            <span class="list-subtitle"><%=ticket.GroupTicketOption.getLookupDesc(pageBase.getLang())%> (<%=ticket.GroupQuantity.getInt()%>)</span>
          <% } %>
        </td>
      </tr>
    <% } %>
  <% } %>
  
  <% if (ticketIDs.length == 0) { %>
    <tr><td colspan="100%"><v:itl key="@Ticket.NoActiveTickets"/></td></tr>
  <% } %>
  </tbody>
</v:grid>
  
<% if (amount != 0) { %>
&nbsp;<br/>
<v:grid>
  <thead>
    <tr class="header">
      <td width="50%"><v:itl key="@Payment.TotalDue"/></td>
      <td width="50%" align="right"><%=pageBase.formatCurrHtml(amount)%></td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td colspan="100%">
        <select id="PaymentMethodId" class="form-control" style="width:100%">
        <% for (PageTicketCancellationDialog.PayMethodBean payMethod : payMethods) { %>
          <option value="<%=JvString.escapeHtml(payMethod.paymentMethodId)%>" data-PaymentType="<%=payMethod.paymentType%>" data-AccountId="<%=JvString.getEmpty(payMethod.accountId)%>"><%=JvString.escapeHtml(payMethod.paymentMethodName)%></option>
        <% } %>
        </select>
      </td>
    </tr>
  </tbody>
</v:grid>

<% } %>

<% if (ticketIDs.length > 0) { %>
  &nbsp;<br/>
  <v:itl key="@Common.Notes"/>
  <textarea id="Notes" rows="5" class="form-control"></textarea>
<% } %>

<script>

$(document).ready(function() {
  var dlg = $("#void-as-dialog");
  
  dlg.dialog({
    title: "<v:itl key="@Lookup.TransactionType.TicketCancellation" encode="UTF-8"/>",
    modal: true,
    width: 500,
    close: function() {
      dlg.remove();
    },
    buttons: {
      <v:itl key="@Common.Save" encode="JS"/>: doSave,
      <v:itl key="@Common.Cancel" encode="JS"/>: doClose
    }
  });

  <% if (ticketIDs.length == 0) { %>
    btnSave.button({disabled:true});
  <% } %>
  
  dlg.find(".tabs").tabs();
  
  function doClose() {
    dlg.dialog("close");
  }
  
  function doSave() {
    dlg.find(".ui-dialog-buttonpane .btn").addClass("disabled");    
    
    var reqDO = {
      Command: "TicketCancellation",
      TicketCancellation: {
        TicketIDs: "<%=JvArray.arrayToString(ticketIDs, ",")%>",
        PaymentMethodId: $("#PaymentMethodId").val(),
        PaymentAccountId: $("#PaymentMethodId option[value='" + $("#PaymentMethodId").val() + "']").attr("data-AccountId"),
        PaymentAmount: <%=JvString.sqlMoney(amount)%>,
        Notes: $("#Notes").val()
      }
    };
    
    $("#void-as-dialog").html("<div class='spinner32-bg' style='height:90px'></div>");
    dlg.dialog({height:200,resizable:false});

    vgsService("Sale", reqDO, true, function(ansDO) {
      if (ansDO.Header.StatusCode != 200) {
        doClose();
        showMessage(ansDO.Header.ErrorMessage);
      }
      else {
        doClose();
        showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>, function() {
          window.open("<v:config key="site_url"/>/docproc?id=<%=pageBase.getRights().TrnReceipt_DocTemplateId.getHtmlString()%>&p_TransactionId=" + ansDO.Answer.TicketCancellation.TransactionId);
          window.location.reload();
        });
      }
    });
  }
});

</script>


</div>
