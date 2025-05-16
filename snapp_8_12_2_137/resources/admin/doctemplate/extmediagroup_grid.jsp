<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ExtMediaGroup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_ExtMediaGroup.class);
// Select
qdef.addSelect(Sel.ExtMediaGroupId);
qdef.addSelect(Sel.ExtMediaGroupCode);
qdef.addSelect(Sel.ExtMediaGroupName);
qdef.addSelect(Sel.NotifyQuantityLow);
qdef.addSelect(Sel.NotifyQuantityCritical);
qdef.addSelect(Sel.NotifyExpirationDays);
qdef.addSelect(Sel.IconName);
//sort
qdef.addSort(Sel.ExtMediaGroupName);
// Filter
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getParameter("FullText"));
if (pageBase.getNullParameter("ExtMediaGroupId") != null)
  qdef.addFilter(Fil.ExtMediaGroupId, pageBase.getNullParameter("ExtMediaGroupId"));

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef); 
request.setAttribute("ds", ds);

%>

<v:grid id="extmediagroup-grid" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.ExtMediaGroup%>">
  <tr class="header">
    <td>
      <v:grid-checkbox header="true"/>
    </td>
    <td>&nbsp;</td>
    <td width="100%">
      <v:itl key="@Common.Name"/><br />
      <v:itl key="@Common.Code"/>         
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td>
      <v:grid-checkbox dataset="ds" fieldname="ExtMediaGroupId" name="ExtMediaGroupId"/>
    </td>
    <td>
      <v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(QryBO_ExtMediaGroup.Sel.ExtMediaGroupId)%>" entityType="<%=LkSNEntityType.ExtMediaGroup%>" clazz="list-title">
        <%=ds.getField(QryBO_ExtMediaGroup.Sel.ExtMediaGroupName).getHtmlString()%>
      </snp:entity-link><br />
      <span class="list-subtitle"><%=ds.getField(QryBO_ExtMediaGroup.Sel.ExtMediaGroupCode).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>