<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Sale.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="/resources/common/error/grid_error.jspf"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
String accountId = pageBase.getNullParameter("AccountId");
String locationId = pageBase.getNullParameter("LocationId");

DOSaleSearchRequest reqDO = new DOSaleSearchRequest();

//Paging
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);


//Sort
reqDO.SearchRecap.addSortField("SaleFiscalDate", true);
reqDO.SearchRecap.addSortField("SaleDateTime", true);

// Where
if (pageBase.getNullParameter("SaleCode") != null) {
  reqDO.Filters.SaleCode.setString(pageBase.getNullParameter("SaleCode")); 
  if (accountId != null)
    reqDO.Filters.AccountId.setString(accountId);
}
else {
  if (accountId != null)
    reqDO.Filters.AccountId.setString(accountId);
  if (pageBase.getNullParameter("FullText") != null)
    reqDO.Filters.FullText.setString(pageBase.getNullParameter("FullText"));
  
  reqDO.Filters.FromDateTime.setDateTime((pageBase.getNullParameter("FromDateTime") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FromDateTime")));
  reqDO.Filters.ToDateTime.setDateTime((pageBase.getNullParameter("ToDateTime") == null) ? null : pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("ToDateTime")));
  
  if (pageBase.getNullParameter("LinkedSaleId") != null)
    reqDO.Filters.LinkedSaleId.setString(pageBase.getNullParameter("LinkedSaleId"));
  
  if (pageBase.hasParameter("MembershipAccountId") && (pageBase.getNullParameter("MembershipAccountId") != null))
    reqDO.Filters.MembershipAccountId.setString(pageBase.getNullParameter("MembershipAccountId"));
  
  if (pageBase.getNullParameter("Flag_Approved") != null) 
    reqDO.Filters.Approved.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_Approved"), false));
  
  if (pageBase.getNullParameter("Flag_Consignment") != null) 
    reqDO.Filters.Consignment.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_Consignment"), false));
  
  if (pageBase.getNullParameter("Flag_Paid") != null) 
    reqDO.Filters.Paid.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_Paid"), false));
  
  if (pageBase.getNullParameter("Flag_Encoded") != null) 
    reqDO.Filters.Encoded.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_Encoded"), false));
  
  if (pageBase.getNullParameter("Flag_Printed") != null) 
    reqDO.Filters.Printed.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_Printed"), false));
  
  if (pageBase.getNullParameter("Flag_Validated") != null) 
    reqDO.Filters.Validated.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_Validated"), false));
  
  if (pageBase.getNullParameter("Flag_Completed") != null) 
    reqDO.Filters.Completed.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_Completed"), false));
  
  if (pageBase.getNullParameter("Flag_NotApproved") != null) 
    reqDO.Filters.NotApproved.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_NotApproved"), false));
  
  if (pageBase.getNullParameter("Flag_NotConsignment") != null) 
    reqDO.Filters.NotConsignment.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_NotConsignment"), false));
  
  if (pageBase.getNullParameter("Flag_NotPaid") != null) 
    reqDO.Filters.NotPaid.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_NotPaid"), false));
  
  if (pageBase.getNullParameter("Flag_NotEncoded") != null) 
    reqDO.Filters.NotEncoded.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_NotEncoded"), false));
  
  if (pageBase.getNullParameter("Flag_NotPrinted") != null) 
    reqDO.Filters.NotPrinted.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_NotPrinted"), false));
  
  if (pageBase.getNullParameter("Flag_NotValidated") != null) 
    reqDO.Filters.NotValidated.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_NotValidated"), false));
  
  if (pageBase.getNullParameter("Flag_NotCompleted") != null) 
    reqDO.Filters.NotCompleted.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("Flag_NotCompleted"), false));
  
  if (pageBase.getNullParameter("SaleCalcStatus") != null)
    reqDO.Filters.Status.setArray(JvArray.stringToIntArray(pageBase.getNullParameter("SaleCalcStatus"), ","));
  
  if (pageBase.getNullParameter("OpenOrderBalance") != null)
    reqDO.Filters.OpenOrderBalance.setBoolean(JvString.strToBoolDef(pageBase.getNullParameter("OpenOrderBalance"), false));
  
  if (pageBase.getNullParameter("WksLocationId") != null)
    reqDO.Filters.SaleLocationId.setString(pageBase.getNullParameter("WksLocationId"));
  
  if (pageBase.getNullParameter("OpAreaId") != null)
    reqDO.Filters.SaleOperatingAreaId.setString(pageBase.getNullParameter("OpAreaId"));
  
  if (pageBase.getNullParameter("WorkstationId") != null)
    reqDO.Filters.SaleWorkstationId.setString(pageBase.getNullParameter("WorkstationId"));
  
  if (pageBase.getNullParameter("UserAccountId") != null)
    reqDO.Filters.UserAccountId.setString(pageBase.getNullParameter("UserAccountId"));
  
  if ((pageBase.getNullParameter("PaymentMethodId") != null))
    reqDO.Filters.PaymentMethodId.setString(pageBase.getNullParameter("PaymentMethodId"));
  
  if ((pageBase.getNullParameter("TotalAmountFrom") != null))
    reqDO.Filters.TotalAmountFrom.setMoney(JvString.strToMoneyDef(pageBase.getNullParameter("TotalAmountFrom"), 0));
  
  if ((pageBase.getNullParameter("TotalAmountTo") != null))
    reqDO.Filters.TotalAmountTo.setMoney(JvString.strToMoneyDef(pageBase.getNullParameter("TotalAmountTo"), 0));
  
  if ((pageBase.getNullParameter("PaidAmountFrom") != null))
    reqDO.Filters.PaidAmountFrom.setMoney(JvString.strToMoneyDef(pageBase.getNullParameter("PaidAmountFrom"), 0));

  if ((pageBase.getNullParameter("PaidAmountTo") != null))
    reqDO.Filters.PaidAmountTo.setMoney(JvString.strToMoneyDef(pageBase.getNullParameter("PaidAmountTo"), 0));
  
  if ((pageBase.getNullParameter("BulkSalePayTransactionId") != null))
    reqDO.Filters.BulkSalePayTransactionId.setString(pageBase.getNullParameter("BulkSalePayTransactionId"));
  
  if ((pageBase.getNullParameter("AssociationAccountId") != null))
    reqDO.Filters.AssociationAccountId.setString(pageBase.getNullParameter("AssociationAccountId"));
  
  DOSearchGroupContainer mfg = SnappUtils.encodeSearchGroupContainerByParams(request);
  if (mfg != null) 
    reqDO.Filters.SearchFieldGroupList.assign(mfg.SearchFieldGroupList);
}

// Exec
DOSaleSearchAnswer ansDO = new DOSaleSearchAnswer();   
pageBase.getBL(BLBO_Sale.class).searchSale(reqDO, ansDO);
%>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.Sale%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="120px" nowrap>
      <v:itl key="@Sale.PNR"/><br/>
      <v:itl key="@Common.DateTime"/>
    </td>
    <td width="120px" nowrap>
      <v:itl key="@Common.Status"/><br/>
      <v:itl key="@Reservation.Flags"/>
    </td>
    <td width="45%">
      <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> &raquo; <v:itl key="@Common.Workstation"/><br/>
      <v:itl key="@Common.User"/>
    </td>
    <td width="25%">
      <v:itl key="@Account.Account"/><br/>
      <v:itl key="@SaleChannel.SaleChannel"/>
    </td>
    <td width="15%" align="right">
      <v:itl key="@Common.Quantity"/>
    </td>
    <td width="15%" align="right">
      <v:itl key="@Reservation.TotalAmount"/><br/>
      <v:itl key="@Reservation.PaidAmount"/>
    </td>
  </tr>
  <v:grid-row search="<%=ansDO%>" dateGroupFieldName="SaleFiscalDate" idFieldName="saleId" archivedFieldName="ArchivedPurged">
    <% 
    DOSaleRef saleDO = ansDO.getRecord();
    LookupItem saleStatus = saleDO.SaleStatus.isNull() ? LkSNSaleStatus.Normal : LkSN.SaleStatus.getItemByCode(saleDO.SaleStatus); %>
    <td style="<v:common-status-style status="<%=saleDO.CommonStatus%>"/>">
      <v:grid-checkbox name="SaleId" value="<%=saleDO.SaleId.getString()%>"/>
      <snp:grid-note entityType="<%=LkSNEntityType.Sale%>" entityId="<%=saleDO.SaleId.getString()%>" noteCountField="<%=saleDO.NoteCount%>"/>
    </td>
    <td><v:grid-icon name="<%=saleDO.IconName.getString()%>"/></td>
    <td nowrap>
      <snp:entity-link entityId="<%=saleDO.SaleId.getString()%>" entityType="<%=LkSNEntityType.Sale%>" clazz="list-title"><%=saleDO.SaleCodeDisplay.getHtmlString()%></snp:entity-link><br/>
      <snp:datetime timestamp="<%=saleDO.SaleDateTime.getDateTime()%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
    </td>
    <td>
      <div>
        <% LookupItem saleCalcStatus = LkSN.SaleCalcStatus.getItemByCode(saleDO.SaleCalcStatus.getInt()); %>
        <%=saleCalcStatus.getHtmlDescription(pageBase.getLang())%>
      </div>
      <div class="list-subtitle" style="white-space:nowrap;">
        <% if (saleDO.Approved.getBoolean()) {    %><i class="fa fa-handshake" title="<v:itl key="@Reservation.Flag_Approved"/>"></i><% } %>
        <% if (saleDO.Consignment.getBoolean()) { %><i class="fa fa-scanner" title="<v:itl key="@Reservation.Flag_Consignemnt"/>"></i><% } %>
        <% if (saleDO.Paid.getBoolean()) {        %><i class="fa fa-money-bill" title="<v:itl key="@Reservation.Flag_Paid"/>"></i><% } %>
        <% if (saleDO.Encoded.getBoolean()) {     %><i class="fa fa-print" title="<v:itl key="@Reservation.Flag_Encoded"/>"></i><% } %>
        <% if (saleDO.Validated.getBoolean()) {   %><i class="fa fa-check" title="<v:itl key="@Reservation.Flag_Validated"/>"></i><% } %>
        <% if (saleDO.ActionCount.getInt() > 0) { %><i class="fa fa-envelope" title="<v:itl key="@Common.Email"/>"></i><% } %>
      </div>
    </td>
    <td>
      <snp:entity-link entityId="<%=saleDO.LocationAccountId%>" entityType="<%=LkSNEntityType.Location%>"><%= saleDO.LocationAccountName.getHtmlString() %></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=saleDO.OpAreaAccountId%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%= saleDO.OpAreaAccountName.getHtmlString() %></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=saleDO.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>"><%= saleDO.WorkstationName.getHtmlString() %></snp:entity-link>
      <br/>
      <snp:entity-link entityId="<%=saleDO.UserAccountId%>" entityType="<%=LkSNEntityType.Person%>"><%= saleDO.UserAccountName.getHtmlString() %></snp:entity-link>
    </td>
    <td>
      <% if (saleDO.AccountId.isNull()) { %>
        <span class="list-subtitle"><v:itl key="@Account.AnonymousAccount"/></span>
      <% } else { %>
        <snp:entity-link entityId="<%=saleDO.AccountId%>" entityType="<%=saleDO.AccountEntityType%>"><%= saleDO.AccountName.getHtmlString() %></snp:entity-link>
      <% } %>
      <br/>
      <% if (saleDO.SaleChannelId.isNull()) { %>
        <span class="list-subtitle"><v:itl key="@Common.Default"/></span>
      <% } else { %>
        <snp:entity-link entityId="<%=saleDO.SaleChannelId%>" entityType="<%=LkSNEntityType.SaleChannel%>"><%=saleDO.SaleChannelName.getHtmlString()%></snp:entity-link>
      <% } %>
    </td>
    <% String lineThrough = saleStatus.isLookup(LkSNSaleStatus.Deleted) ? "line-through" : ""; %>
    <td align="right" class="<%=lineThrough%>">
      <%= saleDO.ItemCount.getHtmlString() %>
    </td>
    <td align="right" class="<%=lineThrough%>">
      <%=pageBase.formatCurrHtml(saleDO.TotalAmount)%><br/>
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(saleDO.PaidAmount)%></span>
    </td>
  </v:grid-row>
</v:grid>
