<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Box.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_Box.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.CommonStatus,
    Sel.BoxId,
    Sel.BoxCode,
    Sel.FBoxDate,
    Sel.BoxStatus,
    Sel.LocationAccountId,
    Sel.LocationAccountName,
    Sel.OpAreaAccountId,
    Sel.OpAreaAccountName,
    Sel.UserAccountId,
    Sel.UserAccountNameMasked,
    Sel.LastWorkstationId,
    Sel.LastWorkstationName,
    Sel.DepositCount,
    Sel.OverShort,
    Sel.OverShortFlag,
    Sel.LastBagNumber);

// Filter
String boxCode = pageBase.getNullParameter("BoxCode");
if (boxCode != null) {
  qdef.addFilter(Fil.BoxCode, boxCode);
}
else {
  if (pageBase.getNullParameter("BagNumber") != null)
    qdef.addFilter(Fil.BagNumber, pageBase.getNullParameter("BagNumber"));
  
  if ((pageBase.getNullParameter("UserAccountId") != null))
    qdef.addFilter(Fil.UserAccountId, pageBase.getNullParameter("UserAccountId"));
  
  if (pageBase.getNullParameter("FromDate") != null)
    qdef.addFilter(Fil.FromDate, pageBase.getNullParameter("FromDate"));
  
  if (pageBase.getNullParameter("ToDate") != null)
    qdef.addFilter(Fil.ToDate, pageBase.getNullParameter("ToDate"));
  
  if (pageBase.getNullParameter("BoxStatus") != null)
    qdef.addFilter(Fil.BoxStatus, JvArray.stringToIntArray(pageBase.getNullParameter("BoxStatus"), ","));
  
  if (pageBase.getNullParameter("CashLimitWarnOnly") != null)
    qdef.addFilter(Fil.CashLimitWarnOnly, pageBase.getNullParameter("CashLimitWarnOnly"));

  if (pageBase.getNullParameter("LocationId") != null)
    qdef.addFilter(Fil.LocationId, pageBase.getNullParameter("LocationId"));

  if (pageBase.getNullParameter("OpAreaId") != null)
    qdef.addFilter(Fil.OpAreaId, pageBase.getNullParameter("OpAreaId"));
  
  if (pageBase.getNullParameter("LastDepositLocationId") != null)
    qdef.addFilter(Fil.LastDepositLocationId, pageBase.getNullParameter("LastDepositLocationId"));

  if (pageBase.getNullParameter("LastDepositOpAreaId") != null)
    qdef.addFilter(Fil.LastDepositOpAreaId, pageBase.getNullParameter("LastDepositOpAreaId"));

  if (pageBase.getNullParameter("LastDepositWorkstationId") != null)
    qdef.addFilter(Fil.LastDepositWorkstationId, pageBase.getNullParameter("LastDepositWorkstationId"));
}
  
// Sort
qdef.addSort(Sel.BoxCode, false);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Box%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td>
        <v:itl key="@Common.Code"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="10%">
        <v:itl key="@Common.FiscalDate"/><br/>
        <v:itl key="@Box.LastBag"/>
      </td>
      <td width="40%">
        <v:itl key="@Common.User"/><br/>
        <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> | <v:itl key="@Box.LastWorkstation"/>
      </td>
      <td width="50%" align="right">
        <v:itl key="@Box.NrOperations"/><br/>
        <v:itl key="@Box.OverShort"/>
      </td>
    </tr>
  </thead>
  <tbody>
  <v:grid-row dataset="ds" dateGroupFieldName="FBoxDate">
    <% LookupItem boxStatus = LkSN.BoxStatus.getItemByCode(ds.getField(Sel.BoxStatus)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="BoxId" dataset="ds" fieldname="BoxId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td nowrap>
      <div><snp:entity-link entityId="<%=ds.getField(Sel.BoxId)%>" entityType="<%=LkSNEntityType.Box %>" clazz="list-title"><%=ds.getField(Sel.BoxCode).getHtmlString()%></snp:entity-link></div>
      <div class="list-subtitle"><%=boxStatus.getHtmlDescription(pageBase.getLang())%></div>
    </td>
    <td>
      <div>
        <% ds.getField(Sel.FBoxDate).setDisplayFormat(pageBase.getShortDateFormat()); %>
        <%=ds.getField(Sel.FBoxDate).getHtmlString()%>
      </div>
      <div class="list-subtitle">
      <% if (ds.getField(Sel.LastBagNumber).isNull()) { %>
        &mdash;
      <% } else { %>
        <%=ds.getField(Sel.LastBagNumber).getHtmlString()%>
      <% } %>
      </div>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.UserAccountId).getEmptyString()%>" entityType="<%=LkSNEntityType.Person%>"><%=ds.getField(Sel.UserAccountNameMasked).getHtmlString()%></snp:entity-link><br/>
      <snp:entity-link entityId="<%=ds.getField(Sel.LocationAccountId).getEmptyString()%>" entityType="<%=LkSNEntityType.Location%>"><%=ds.getField(Sel.LocationAccountName).getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaAccountId).getEmptyString()%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=ds.getField(Sel.OpAreaAccountName).getHtmlString()%></snp:entity-link> |
      <snp:entity-link entityId="<%=ds.getField(Sel.LastWorkstationId).getEmptyString()%>" entityType="<%=LkSNEntityType.Workstation%>"><%=ds.getField(Sel.LastWorkstationName).getHtmlString()%></snp:entity-link>
    </td>
    <td align="right">
      <%=ds.getField(Sel.DepositCount).getHtmlString()%><br/>
      <% long amount = ds.getField(Sel.OverShort).getMoney(); %>
      <% if (!ds.getField(Sel.OverShortFlag).getBoolean()) { %>
        &mdash;
      <% } else { %>
        <span style="color:red"><%=pageBase.formatCurrHtml(amount)%></span>
      <% } %>
    </td>
  </v:grid-row>
  </tbody>
</v:grid>
