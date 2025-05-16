<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_IntercompanyCostCenter.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_IntercompanyCostCenter.class);
// Select
qdef.addSelect(
    Sel.IntercompanyCostCenterId,
    Sel.IntercompanyCostCenterCode,
    Sel.IntercompanyCostCenterName,
    Sel.Active,
    Sel.ForceReceipt);
//sort
qdef.addSort(Sel.IntercompanyCostCenterName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>


<v:grid id="IntercompanyCostCenter-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.IntercompanyCostCenter%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td width="25%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="75%">
      <v:itl key="@Common.Options"/>
    </td>
</tr>
  <v:grid-row dataset="ds">
    <% LookupItem commonStatus = ds.getBoolean(Sel.Active) ? LkCommonStatus.Active : LkCommonStatus.Draft; %>
  	<td style="<v:common-status-style status="<%=commonStatus%>"/>"><v:grid-checkbox name="IntercompanyCostCenterId" dataset="ds" fieldname="IntercompanyCostCenterId"/></td>
  	<td>
      <snp:entity-link entityId="<%=ds.getField(Sel.IntercompanyCostCenterId).getString()%>" entityType="<%=LkSNEntityType.IntercompanyCostCenter%>" clazz="list-title" >
        <%=ds.getField(Sel.IntercompanyCostCenterName).getHtmlString()%>
      </snp:entity-link><br/>
			<span class="list-subtitle"><%=ds.getField(Sel.IntercompanyCostCenterCode).getHtmlString()%>
      </span>
    </td>
    <td>
      <%
      String[] options = new String[0];
      if (ds.getField(Sel.ForceReceipt).getBoolean())
        options = JvArray.add(JvString.escapeHtml(pageBase.getLang().Payment.ForceReceipt.getText()), options);
      %>
      <div class="list-subtitle"><%=JvArray.arrayToString(options, ", ")%></div>
    </td>
  </v:grid-row>
</v:grid>
