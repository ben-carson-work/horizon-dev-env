<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_CommissionRule.class);
// Select
qdef.addSelect(QryBO_CommissionRule.Sel.IconName);
qdef.addSelect(QryBO_CommissionRule.Sel.CommonStatus);
qdef.addSelect(QryBO_CommissionRule.Sel.CommissionId);
qdef.addSelect(QryBO_CommissionRule.Sel.CommissionCode);
qdef.addSelect(QryBO_CommissionRule.Sel.CommissionName);
qdef.addSelect(QryBO_CommissionRule.Sel.Enabled);
qdef.addSelect(QryBO_CommissionRule.Sel.PeriodType);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(QryBO_CommissionRule.Sel.CommissionName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.CommissionRule%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="40%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="60%">
      <v:itl key="@Period"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(QryBO_CommissionRule.Sel.CommonStatus)%>"/>"><v:grid-checkbox name="cbCommissionId" dataset="ds" fieldname="CommissionId"/></td>
    <td><v:grid-icon name="<%=ds.getField(QryBO_CommissionRule.Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(QryBO_CommissionRule.Sel.CommissionId)%>" entityType="<%=LkSNEntityType.CommissionRule%>" clazz="list-title">
        <%=ds.getField(QryBO_CommissionRule.Sel.CommissionName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=ds.getField(QryBO_CommissionRule.Sel.CommissionCode).getHtmlString()%></span>
    </td>
    <td>
      <% LookupItem periodType = LkSN.PeriodType.getItemByCode(ds.getField(QryBO_CommissionRule.Sel.PeriodType)); %>
      <%=periodType.getHtmlDescription(pageBase.getLang())%>
    </td>
  </v:grid-row>
</v:grid>
