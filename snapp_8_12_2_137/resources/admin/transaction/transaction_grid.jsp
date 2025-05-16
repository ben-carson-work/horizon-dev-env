<%@page import="com.vgs.snapp.api.transaction.*"%>
<%@page import="com.vgs.snapp.dataobject.transaction.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Transaction.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="/resources/common/error/grid_error.jspf"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%

String transactionCode = pageBase.getNullParameter("TransactionCode");
String accountId = pageBase.getNullParameter("AccountId");

APIDef_Transaction_Search.DORequest reqDO = new APIDef_Transaction_Search.DORequest();

//Paging
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

//Sort
reqDO.SearchRecap.addSortField(Sel.TransactionFiscalDate, true);
reqDO.SearchRecap.addSortField(Sel.TransactionDateTime, true);
reqDO.SearchRecap.addSortField(Sel.TransactionSerial, true);

// Where
reqDO.Filters.AccountId.setString(accountId);
if (transactionCode != null) 
  reqDO.Filters.Code.setString(transactionCode);  
else {
  reqDO.Filters.FullText.setString(pageBase.getNullParameter("FullText"));
  reqDO.Filters.SaleId.setString(pageBase.getNullParameter("SaleId"));
  reqDO.Filters.BoxId.setString(pageBase.getNullParameter("BoxId"));
  reqDO.Filters.TicketId.setString(pageBase.getNullParameter("TicketId"));
  reqDO.Filters.MediaId.setString(pageBase.getNullParameter("MediaId"));
  reqDO.Filters.FromDateTime.setDateTime((pageBase.getNullParameter("FromDateTime") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FromDateTime")));
  reqDO.Filters.ToDateTime.setDateTime((pageBase.getNullParameter("ToDateTime") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("ToDateTime")));
  reqDO.Filters.FiscalDateFrom.setDateTime((pageBase.getNullParameter("FiscalDateFrom") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FiscalDateFrom")));
  reqDO.Filters.FiscalDateTo.setDateTime((pageBase.getNullParameter("FiscalDateTo") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FiscalDateTo")));
  reqDO.Filters.LocationId.setString(pageBase.getNullParameter("LocationId"));
  reqDO.Filters.OpAreaId.setString(pageBase.getNullParameter("OpAreaId"));
  reqDO.Filters.WorkstationId.setString(pageBase.getNullParameter("WorkstationId"));
  reqDO.Filters.UserAccountId.setString(pageBase.getNullParameter("UserAccountId"));
  reqDO.Filters.SupervisedOnly.setString(pageBase.getNullParameter("SupervisedOnly"));
  reqDO.Filters.TransactionWarnStatus.setArray(JvArray.stringToIntArray(pageBase.getNullParameter("TransactionWarnStatus"), ","));
  reqDO.Filters.TransactionType.setLkValue(LkSN.TransactionType.findItemByCode(pageBase.getNullParameter("TransactionType")));
  reqDO.Filters.PaymentMethodId.setString(pageBase.getNullParameter("PaymentMethodId"));
  reqDO.Filters.TotalAmountFrom.setString(pageBase.getNullParameter("TotalAmountFrom"));
  reqDO.Filters.TotalAmountTo.setString(pageBase.getNullParameter("TotalAmountTo"));
  reqDO.Filters.PaidAmountFrom.setString(pageBase.getNullParameter("PaidAmountFrom"));
  reqDO.Filters.PaidAmountTo.setString(pageBase.getNullParameter("PaidAmountTo"));
  reqDO.Filters.LinkedTransactionId.setString(pageBase.getNullParameter("LinkedTransactionId"));
  reqDO.Filters.LinkedSaleId.setString(pageBase.getNullParameter("LinkedSaleId"));
  reqDO.Filters.InvoiceId.setString(pageBase.getNullParameter("InvoiceId"));

  DOSearchGroupContainer mfg = SnappUtils.encodeSearchGroupContainerByParams(request);
  if (mfg != null) 
    reqDO.SearchFieldGroupList.assign(mfg.SearchFieldGroupList);
}  

// Exec
APIDef_Transaction_Search.DOResponse ansDO = pageBase.getBL(API_Transaction_Search.class).execute(reqDO);   
%>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.Transaction%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="120px" nowrap>
      <v:itl key="@Common.Code"/><br/>
      <v:itl key="@Common.DateTime"/>
    </td>
    <td width="15%" nowrap>
      <v:itl key="@Reservation.Flags"/><br/>
      <v:itl key="@Common.Type"/>
    </td>
    <td width="45%">
      <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> &raquo; <v:itl key="@Common.Workstation"/><br/>
      <v:itl key="@Common.User"/>
    </td>
    <td width="15%">
      <v:itl key="@Sale.PNR"/><br/>
      <v:itl key="@Box.Box"/>
    </td>
    <td width="10%" align="right">
      <v:itl key="@Common.Quantity"/>
    </td>
    <td width="15%" align="right">
      <v:itl key="@Reservation.TotalAmount"/><br/>
      <v:itl key="@Reservation.PaidAmount"/>
    </td>
  </tr>
   <v:grid-row search="<%=ansDO%>" dateGroupFieldName="TransactionFiscalDate" idFieldName="transactionId" archivedFieldName="ArchivedPurged">
    <%
    DOTransactionRef trnDO = ansDO.getRecord();
    LookupItem transactionType = trnDO.TransactionType.getLkValue(); 
    %>
    <td style="<v:common-status-style status="<%=trnDO.CommonStatus%>"/>">
      <v:grid-checkbox name="TransactionId" value="<%=trnDO.TransactionId.getString()%>"/>
      <snp:grid-note entityType="<%=LkSNEntityType.Sale%>" entityId="<%=trnDO.SaleId.getString()%>" noteCountField="<%=trnDO.SaleNoteCount%>"/>
    </td>
    <td><v:grid-icon name="<%=trnDO.IconName.getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=trnDO.TransactionId.getString()%>" entityType="<%=LkSNEntityType.Transaction%>" clazz="list-title">
        <%=trnDO.TransactionCode.getHtmlString()%>
      </snp:entity-link>
      <br/>
      <snp:datetime timestamp="<%=trnDO.TransactionDateTime.getDateTime()%>" format="shortdatetime" timezone="local" clazz="list-subtitle" showMillisHint="true"/>
    </td>
    <td>
      <%= SnappUtils.encodeTransactionFlags(trnDO.Approved, trnDO.Consignment, trnDO.Paid, trnDO.Encoded, trnDO.Printed, trnDO.Validated) %><br/>
      <span class="list-subtitle"><%= transactionType.getDescription(pageBase.getLang()) %></span>
    </td>
    <td>
      <snp:entity-link entityId="<%=trnDO.LocationId.getString()%>" entityType="<%=LkSNEntityType.Location%>"><%=trnDO.LocationName.getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=trnDO.OpAreaId.getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=trnDO.OpAreaName.getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=trnDO.WorkstationId.getString()%>" entityType="<%=LkSNEntityType.Workstation%>"><%=trnDO.WorkstationName.getHtmlString()%></snp:entity-link>
      <br/>
      <% if (trnDO.UserAccountId.isNull()) { %>
        &nbsp;
      <% } else { %>
        <% LookupItem userAccountEntityType = trnDO.UserAccountEntityType.getLkValue(); %>
        <snp:entity-link entityId="<%=trnDO.UserAccountId.getString()%>" entityType="<%=userAccountEntityType%>"><%=trnDO.UserAccountName.getHtmlString()%></snp:entity-link>
      <% }%>
      <% if (!trnDO.SupAccountId.isNull()) { %>
        <span class="list-subtitle">&nbsp;(<v:itl key="@Common.Supervisor"/>:
          <% LookupItem supAccountEntityType = trnDO.SupAccountEntityType.getLkValue(); %>
          <snp:entity-link entityId="<%=trnDO.SupAccountId.getString()%>" entityType="<%=supAccountEntityType%>"><%=trnDO.SupAccountName.getHtmlString()%></snp:entity-link>)
        </span>
      <% } %>
    </td>
    <td>
      <snp:entity-link entityId="<%=trnDO.SaleId.getString()%>" entityType="<%=LkSNEntityType.Sale%>">
        <%=trnDO.SaleCodeDisplay.getHtmlString()%>
      </snp:entity-link>
      <br/>
      <% if (trnDO.BoxId.isNull()) { %>
        <span class="list-subtitle"><v:itl key="@Common.None"/></span>
      <% } else { %>
	      <snp:entity-link entityId="<%=trnDO.BoxId.getString()%>" entityType="<%=LkSNEntityType.Box%>">
	        <%=trnDO.BoxCode.getHtmlString()%>
	      </snp:entity-link>
      <% } %>
    </td>
    <td align="right">
      <%=trnDO.ItemCount.getHtmlString()%>
    </td>
    <td align="right">
      <%=pageBase.formatCurrHtml(trnDO.TotalAmount.getMoney())%><br/>
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(trnDO.PaidAmount.getMoney())%></span>
    </td>
  </v:grid-row>
</v:grid>