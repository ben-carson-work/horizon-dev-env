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
QueryDef qdef = new QueryDef(QryBO_Sale.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.SaleId,
    Sel.SaleCode,
    Sel.SaleDateTime,
    Sel.SaleFiscalDate,
    Sel.SaleStatus,
    Sel.SaleB2BStatus,
    Sel.ItemCount,
    Sel.TotalAmount,
    Sel.PaidAmount,
    Sel.UserAccountId,
    Sel.UserAccountName,
    Sel.UserAccountParentId,
    Sel.ShipAccountId,
    Sel.ShipAccountName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.SaleDateTime, false);
// Where
qdef.addFilter(Fil.AccountId, pageBase.getSession().getOrgAccountId());

if (pageBase.getNullParameter("SaleCode") != null)
  qdef.addFilter(Fil.SaleCode, pageBase.getNullParameter("SaleCode"));
else {
  if (pageBase.getNullParameter("FromDate") != null)
    qdef.addFilter(Fil.FromFiscalDate, pageBase.getNullParameter("FromDate"));

  if (pageBase.getNullParameter("ToDate") != null)
    qdef.addFilter(Fil.ToFiscalDate, pageBase.getNullParameter("ToDate"));

  if (pageBase.getNullParameter("FromDateTime") != null)
    qdef.addFilter(Fil.FromDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FromDateTime")));

  if (pageBase.getNullParameter("ToDateTime") != null)
    qdef.addFilter(Fil.ToDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("ToDateTime")));

  if (pageBase.hasParameter("AccountId") && (pageBase.getNullParameter("AccountId") != null))
    qdef.addFilter(Fil.AccountId, pageBase.getNullParameter("AccountId"));

  if (pageBase.getNullParameter("LinkedSaleId") != null)
    qdef.addFilter(Fil.LinkedSaleId, pageBase.getNullParameter("LinkedSaleId"));

  if (pageBase.hasParameter("MembershipAccountId") && (pageBase.getNullParameter("MembershipAccountId") != null))
    qdef.addFilter(Fil.MembershipAccountId, pageBase.getNullParameter("MembershipAccountId"));

  if (pageBase.getNullParameter("Flag_Approved") != null) 
    qdef.addFilter(Fil.Approved, pageBase.getNullParameter("Flag_Approved"));

  if (pageBase.getNullParameter("Flag_Paid") != null) 
    qdef.addFilter(Fil.Paid, pageBase.getNullParameter("Flag_Paid"));

  if (pageBase.getNullParameter("Flag_Encoded") != null) 
    qdef.addFilter(Fil.Encoded, pageBase.getNullParameter("Flag_Encoded"));

  if (pageBase.getNullParameter("Flag_Printed") != null) 
    qdef.addFilter(Fil.Printed, pageBase.getNullParameter("Flag_Printed"));

  if (pageBase.getNullParameter("Flag_Validated") != null) 
    qdef.addFilter(Fil.Validated, pageBase.getNullParameter("Flag_Validated"));

  if (pageBase.getNullParameter("Flag_Completed") != null) 
    qdef.addFilter(Fil.Completed, pageBase.getNullParameter("Flag_Completed"));

  if (pageBase.getNullParameter("WksLocationId") != null)
    qdef.addFilter(Fil.WksLocationId, pageBase.getNullParameter("WksLocationId"));

  if (pageBase.getNullParameter("OpAreaId") != null)
    qdef.addFilter(Fil.OpAreaId, pageBase.getNullParameter("OpAreaId"));

  if (pageBase.getNullParameter("WorkstationId") != null)
    qdef.addFilter(Fil.WorkstationId, pageBase.getNullParameter("WorkstationId"));

  if (pageBase.getNullParameter("UserAccountId") != null)
    qdef.addFilter(Fil.UserAccountId, pageBase.getNullParameter("UserAccountId"));
}

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="120px" nowrap>
      <v:itl key="@Sale.PNR"/><br/>
      <v:itl key="@Common.DateTime"/>
    </td>
    <td width="120px" nowrap>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="70%">
      <v:itl key="@Account.Account"/><br/>
      <v:itl key="@Common.User"/>
    </td>
    <td width="15%" align="right">
      <v:itl key="@Common.Quantity"/>
    </td>
    <td width="15%" align="right">
      <v:itl key="@Reservation.TotalAmount"/><br/>
      <v:itl key="@Reservation.PaidAmount"/>
    </td>
  </tr>
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.SaleFiscalDate.name()%>">
    <% LookupItem saleStatus = LkSN.SaleStatus.getItemByCode(ds.getField(Sel.SaleStatus)); %>
    <td><v:grid-checkbox name="SaleId" dataset="ds" fieldname="SaleId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td nowrap>
      <snp:entity-link entityId="<%=ds.getField(Sel.SaleId).getString()%>" entityType="<%=LkSNEntityType.Sale%>" clazz="list-title">
        <%=ds.getField(Sel.SaleCode).getHtmlString()%>
      </snp:entity-link><br/>
      <snp:datetime timestamp="<%=ds.getField(Sel.SaleDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
    </td>
    <td>
      <% LookupItem saleB2BStatus = LkSN.SaleB2BStatus.getItemByCode(ds.getField(Sel.SaleB2BStatus)); %>
      <%=saleB2BStatus.getHtmlDescription(pageBase.getLang())%>
    </td>
    <td>
      <%=ds.getField(Sel.ShipAccountId).isNull() ? "-" : ds.getField(Sel.ShipAccountName).getHtmlString()%><br/>
      <% if (ds.getField(Sel.UserAccountParentId).isSameString(pageBase.getSession().getOrgAccountId())) { %>
        <span class="list-subtitle"><%=ds.getField(Sel.UserAccountName).getHtmlString()%></span>
      <% } %>&nbsp;
    </td>
    <% String lineThrough = saleStatus.isLookup(LkSNSaleStatus.Deleted) ? "line-through" : ""; %>
    <td align="right" class="<%=lineThrough%>">
      <%= ds.getField(Sel.ItemCount).getHtmlString() %>
    </td>
    <td align="right" class="<%=lineThrough%>">
      <%=pageBase.formatCurrHtml(ds.getField(Sel.TotalAmount))%><br/>
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(ds.getField(Sel.PaidAmount))%></span>
    </td>
  </v:grid-row>
</v:grid>
