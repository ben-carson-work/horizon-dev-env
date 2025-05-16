<%@page import="com.vgs.snapp.dataobject.ticket.DOTicketAmortizationRef"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>

<v:tab-content>
  <v:alert-box type="warning" include="<%=LkSNInstallmentContractStatus.isBlockedStatus(ticket.InstallmentContractStatus.getLkValue())%>">
    <v:itl key="@Product.AmortizationPeriodsProcessWarning"/>
  </v:alert-box>

  <v:grid>
    <thead>
      <tr>
        <td width="10%">
          <v:itl key="@Common.Date"/><br/>
          <v:itl key="@Common.Status"/>
        </td>
        <td width="75%"> 
          <v:itl key="Gate Category"/>
        </td>  
        </td>
        <td width="15%" align="right"> 
          <v:itl key="@Common.Amount"/>
        </td>
      </tr>
    </thead>
    
    <tbody>
    <% for (DOTicketAmortizationRef item : ticket.AmortizationList) { %>
      <tr class="grid-row">
        <td style="<v:common-status-style status="<%=item.CommonStatus%>"/>">
          <div class="list-title"><%=item.AmortizationDate.formatHtml(pageBase.getShortDateFormat())%></div>
          <div class="list-subtitle"><%=item.TicketAmortizationStatus.getHtmlLookupDesc(pageBase.getLang())%></div>
        </td>
        <td>
          <snp:entity-link entityId="<%=item.GateCategoryId%>" entityType="<%=LkSNEntityType.GateCategory%>" clazz="list-title">
            <%=item.GateCategoryName.getHtmlString()%>
          </snp:entity-link>
          <div class="list-subtitle"><%=item.GateCategoryCode.getHtmlString()%></div>
        </td>
        <td align="right">
          <div class="list-title"><%=pageBase.formatCurrHtml(item.AmortizationAmount)%></div>
          <%if (!item.LedgerDateTime.isNull()) {%>
            <snp:entity-link entityId="<%=item.TicketAmortizationId%>" entityType="<%=LkSNEntityType.LedgerGroup%>" clazz="list-title">
              <v:itl key="@Ledger.Ledger"/>
            </snp:entity-link>
          <%}%>
          </span>
        </td>
      </tr>
    <% } %>
    </tbody>
  </v:grid>
</v:tab-content>