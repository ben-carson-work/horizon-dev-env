<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="/resources/common/error/grid_error.jspf"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
DOInvoiceSearchRequest reqDO = new DOInvoiceSearchRequest();  

// Paging
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

// Where
reqDO.Filters.FromDate.setDateTime((pageBase.getNullParameter("FromIssueDate") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FromIssueDate")));
reqDO.Filters.ToDate.setDateTime((pageBase.getNullParameter("ToIssueDate") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("ToIssueDate")));
reqDO.Filters.FromDateTime.setDateTime((pageBase.getNullParameter("FromIssueDateTime") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FromIssueDateTime")));
reqDO.Filters.ToDateTime.setDateTime((pageBase.getNullParameter("ToIssueDateTime") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("ToIssueDateTime")));
reqDO.Filters.FromDueDate.setDateTime((pageBase.getNullParameter("FromDueDate") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FromDueDate")));
reqDO.Filters.ToDueDate.setDateTime((pageBase.getNullParameter("ToDueDate") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("ToDueDate")));
reqDO.Filters.InvoiceStatus.setArray((pageBase.getNullParameter("InvoiceStatus") == null) ? null : JvArray.stringToIntArray(pageBase.getParameter("InvoiceStatus"), ","));
reqDO.Filters.LocationId.setString(pageBase.getNullParameter("LocationId"));
reqDO.Filters.OpAreaId.setString(pageBase.getNullParameter("OpAreaId"));
reqDO.Filters.WorkstationId.setString(pageBase.getNullParameter("WorkstationId"));
reqDO.Filters.AccountId.setString(pageBase.getNullParameter("AccountId"));
reqDO.Filters.InvoiceCode.setString(pageBase.getNullParameter("InvoiceCode"));
reqDO.Filters.TransactionId.setString(pageBase.getNullParameter("SettlementTransactionId"));
reqDO.Filters.SaleId.setString(pageBase.getNullParameter("SaleId"));
reqDO.Filters.TransactionId.setString(pageBase.getNullParameter("TransactionId"));

// Sort
reqDO.SearchRecap.addSortField("IssueDateTime", true);

// Exec
DOInvoiceSearchAnswer ansDO = new DOInvoiceSearchAnswer();  
pageBase.getBL(BLBO_Invoice.class).searchInvoice(reqDO, ansDO);
%>

<style>
  .strike-out {text-decoration: line-through}
</style>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.Invoice%>">
<% if (pageBase.isParameter("show-title", "true")) { %>
  <tr>
    <td class="widget-title" colspan="100%">
      <span class="widget-title-caption"><v:itl key="@Invoice.Invoices"/></span>
      <v:pagebox gridId="invoice-grid"/>
    </td>
  </tr>
<% } %>
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="20%" nowrap>
      <v:itl key="@Common.Code"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="20%" nowrap>
      <v:itl key="@Invoice.IssueDate"/><br/>
      <v:itl key="@Invoice.IssueDateTime"/>
    </td>
    <td width="20%">
      <v:itl key="@Account.Account"/><br/>
      <v:itl key="@Invoice.DueDate"/>
    </td>
    <td width="20%">
      <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> &raquo; <v:itl key="@Common.Workstation"/><br/>
      <v:itl key="@Common.Operator"/>
    </td>
    <td width="20%" align="right">
      <v:itl key="@Invoice.TotalAmount"/><br/>
      <v:itl key="@Invoice.TotalTax"/>
    </td>
  </tr>
  <v:grid-row search="<%=ansDO%>" dateGroupFieldName="IssueDateTime" idFieldName="invoiceId">
    <%
    DOInvoiceRef invDO = ansDO.getRecord();
    %>
    <td style="<v:common-status-style status="<%=invDO.CommonStatus%>"/>">
      <v:grid-checkbox name="InvoiceId" value="<%=invDO.InvoiceId.getString()%>"/>
      <snp:grid-note entityType="<%=LkSNEntityType.Invoice%>" entityId="<%=invDO.InvoiceId.getString()%>" noteCountField="<%=invDO.NoteCount%>"/>
    </td>
    <td><v:grid-icon name="<%=invDO.IconName.getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=invDO.InvoiceId.getString()%>" entityType="<%=LkSNEntityType.Invoice%>">
        <%=invDO.InvoiceCode.getHtmlString()%>
      </snp:entity-link>
      <br/>
      <div class="list-subtitle"><%=invDO.InvoiceStatusDesc.getHtmlString()%>
      <% if (invDO.NegativePaymentCount.getInt() > 0) { %>
      &nbsp;<i class="fa fa-exclamation-triangle" style="color: <%=JvCLDef.Colors.clrOrange%>" title="<v:itl key="@Invoice.OrdersWithNegativePayments"/>"></i></div>
      <%} %>
    </td>
    <td>
      <%=pageBase.format(invDO.IssueFiscalDate, pageBase.getShortDateFormat())%>
      <br/>
      <snp:datetime timestamp="<%=invDO.IssueDateTime.getDateTime()%>" format="shortdatetime" timezone="local"/>
    </td> 
    <td>
      <% if (invDO.AccountId.isNull()) { %>
        <span class="list-subtitle"><v:itl key="@Account.AnonymousAccount"/></span>
      <% } else { %>
        <snp:entity-link entityId="<%=invDO.AccountId%>" entityType="<%=invDO.AccountEntityType%>">
          <%=invDO.AccountName.getHtmlString()%>
        </snp:entity-link>
      <% } %>
      <br/>
      <div class="list-subtitle"><%=pageBase.format(invDO.DueDate, pageBase.getShortDateFormat())%></div>
    </td>
    <td>
      <snp:entity-link entityId="<%=invDO.LocationId%>" entityType="<%=LkSNEntityType.Location%>">
        <%=invDO.LocationName.getHtmlString()%>
      </snp:entity-link>
      <% if (!invDO.OpAreaId.isNull()) { %>
        &raquo;
        <snp:entity-link entityId="<%=invDO.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>">
          <%=invDO.OpAreaName.getHtmlString()%>
        </snp:entity-link>
      <% } %>
      &raquo;
      <snp:entity-link entityId="<%=invDO.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>">
        <%=invDO.WorkstationName.getHtmlString()%>
      </snp:entity-link>
      <br/>
      <snp:entity-link entityId="<%=invDO.UserAccountId%>" entityType="<%=invDO.UserAccountEntityType%>">
        <%=invDO.UserAccountName.getHtmlString()%>
      </snp:entity-link>
    </td>
    <td align="right">
      <%=pageBase.formatCurrHtml(invDO.TotalAmount)%><br/>
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(invDO.TotalTax)%></span>
    </td>
  </v:grid-row>
</v:grid>