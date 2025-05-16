<%@page import="com.vgs.web.library.BLBO_Stats"%>
<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  JvDateTime dateFrom = JvDateTime.createByXML(pageBase.getParameter("DateFrom"));
JvDateTime dateTo = JvDateTime.createByXML(pageBase.getParameter("DateTo"));
String locationId = pageBase.getNullParameter("LocationId");
String opAreaId = pageBase.getNullParameter("OpAreaId");
String workstationId = pageBase.getNullParameter("WorkstationId");
DOGeneralActivity data = pageBase.getBL(BLBO_Stats.class).getGeneralActivity(dateFrom, dateTo, locationId, opAreaId, workstationId);
%>
  
<%!
private String encodeSubTitle(String caption) {
  if (JvString.getNull(caption) == null)
    return "&nbsp;";
  else
    return JvString.escapeHtml(caption);
}

private String renderTotalRow(PageBO_Base<?> pageBase, String printGroup, int quantity, int voids, long totalAmount, long totalTax) {
  return
      "<tr class='group'>" +
      "<td colspan='2'>" + ((printGroup == null) ? "&mdash;" : JvString.escapeHtml(printGroup)) + "</td>" +
      "<td align='right'>" + quantity + "<br/>(" + voids + ")</td>" +
      "<td align='right'>" + pageBase.formatCurrHtml(totalAmount) + "<br/>" + pageBase.formatCurrHtml(totalTax) + "</td>" +
      "</tr>";
}
%>


<style>

#header-table .postbox {
  min-height: 160px;
}

.stats-subtotal {
  border-top: 1px black solid;
  margin-left: 20%;
  margin-bottom: 10px;
  font-weight: bold;
}

#pay-widget .recap-value {
  font-weight: normal;
}

#pay-widget .stats-subtotal .recap-value {
  font-weight: bold;
}

</style>

<table id="header-table" style="width:100%">
  <tr valign="top">
    <td width="50%">
      <v:widget caption="@Common.Recap">
        <v:widget-block>
          Ticket Encoded and Validated
          <span class="recap-value"><%=data.TicketCount.getInt()%></span>
          <br/>
          Total Revenues 
          <span class="recap-value"><%=pageBase.formatCurrHtml(data.TotalRevenue)%></span>
          <br/>
          Taxes
          <span class="recap-value"><%=pageBase.formatCurrHtml(data.Taxes)%></span>
        </v:widget-block>
        <v:widget-block>
          Voided Tickets
          <span class="recap-value"><%=data.VoidCount.getInt()%></span>
          <br/>
          Amount Voided
          <span class="recap-value"><%=pageBase.formatCurrHtml(data.VoidAmount)%></span>
        </v:widget-block>
      </v:widget>
    </td>
    <td>&nbsp;</td>
    <td width="50%">
      <v:widget id="pay-widget" caption="@Payment.Payments">
        <v:widget-block>
        <% String oldTagId = null; %>
        <% String oldTagName = null; %>
        <% long total = 0; %>
        <% boolean first = true; %>
        <% for (DOGeneralActivity.DOPayment payDO : data.PaymentList.getItems()) { %>
          <% if (!first && !payDO.PaymentGroupTagId.isSameString(oldTagId)) { %>
            <div class="stats-subtotal"><%=encodeSubTitle(oldTagName)%><span class="recap-value"><%=pageBase.formatCurrHtml(total)%></span></div>
            <% total = 0; %>
          <% } %>
          <% first = false; %>
          <% oldTagId = payDO.PaymentGroupTagId.getString(); %>
          <% oldTagName = payDO.PaymentGroupTagName.getString(); %>
          <% total += payDO.Amount.getMoney(); %>
          <%=payDO.PaymentMethodName.getHtmlString()%>
          <span class="recap-value"><%=pageBase.formatCurrHtml(payDO.Amount)%></span><br/>
        <% } %>
        <% if (!data.PaymentList.isEmpty()) { %>
          <div class="stats-subtotal"><%=encodeSubTitle(oldTagName)%><span class="recap-value"><%=pageBase.formatCurrHtml(total)%></span></div>
        <% } %>
        </v:widget-block>
      </v:widget>
    </td>
  </tr>
</table>

<v:grid>
  <thead>
    <tr class="grid-row">
      <td></td>
      <td width="50%"><v:itl key="@Product.ProductType"/></td>
      <td width="25%" align="right">
        <v:itl key="@Common.Quantity"/><br/>
        (<v:itl key="@Common.Void"/>)
      </td>
      <td width="25%" align="right">
        <v:itl key="@Common.Revenue"/><br/>
        <v:itl key="@Common.Tax"/>
      </td>
    </tr>
  </thead>

  <tbody>
  <% 
  String oldTagId = null;
  String oldTagName = null;
  long totalAmount = 0;
  long totalTax = 0;
  int totalQuantity = 0;
  int totalVoids = 0;
  boolean first = true; 
  %>
  <% for (DOGeneralActivity.DOItem itemDO : data.ItemList.getItems()) { %>
    <%
    if (!first && !itemDO.PrintGroupTagId.isSameString(oldTagId)) { 
      %>
      <%=renderTotalRow(pageBase, oldTagName, totalQuantity, totalVoids, totalAmount, totalTax)%>
      <%
      totalAmount = 0;
      totalTax = 0;
      totalQuantity = 0;
      totalVoids = 0;
    }
    first = false; 
    oldTagId = itemDO.PrintGroupTagId.getString(); 
    oldTagName = itemDO.PrintGroupTagName.getString(); 
    totalAmount += itemDO.SoldAmount.getMoney(); 
    totalTax += itemDO.TaxAmount.getMoney(); 
    totalQuantity += itemDO.QtySold.getInt(); 
    totalVoids += itemDO.QtyVoid.getInt(); 
    %>
    <tr class="grid-row">
      <td><v:grid-icon name="<%=itemDO.IconName.getString()%>" repositoryId="<%=itemDO.ProfilePictureId.getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=itemDO.ProductId%>" entityType="<%=itemDO.EntityType%>">
          <strong><%=itemDO.ProductName.getHtmlString()%></strong>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=itemDO.ProductCode.getHtmlString()%></span>
      </td>
      <td align="right">
        <%=itemDO.QtySold.getHtmlString()%><br/>
        <span class="list-subtitle">(<%=itemDO.QtyVoid.getHtmlString()%>)</span>
      </td>
      <td align="right">
        <%=pageBase.formatCurrHtml(itemDO.SoldAmount)%><br/>
        <span class="list-subtitle"><%=pageBase.formatCurrHtml(itemDO.TaxAmount)%></span>
      </td>
    </tr>
  <% } %>
  <% if (!data.ItemList.isEmpty()) { %>
    <%=renderTotalRow(pageBase, oldTagName, totalQuantity, totalVoids, totalAmount, totalTax)%>
  <% } %>
  </tbody>
</v:grid>
