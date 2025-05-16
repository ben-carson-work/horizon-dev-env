<%@page import="com.vgs.cl.document.JvNode"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_AccountCrossPlatform.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_AccountCrossPlatform.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.CrossPlatformId);
qdef.addSelect(Sel.CrossPlatformType);
qdef.addSelect(Sel.CrossPlatformStatus);
qdef.addSelect(Sel.CrossPlatformURL);
qdef.addSelect(Sel.CrossPlatformName);

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.WorkstationName);
// Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if (pageBase.getNullParameter("CrossPlatformStatus") != null)
  qdef.addFilter(Fil.CrossPlatformStatus, JvArray.stringToArray(pageBase.getNullParameter("CrossPlatformStatus"), ","));

if (pageBase.getNullParameter("CrossPlatformType") != null)
  qdef.addFilter(Fil.CrossPlatformType, JvArray.stringToArray(pageBase.getNullParameter("CrossPlatformType"), ","));

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Account_All%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="50%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.URL"/>
    </td>
    <td width="25%">
      <v:itl key="@Common.Status"/><br/>
    </td>
    <td width="25%">
      <v:itl key="@Common.Type"/><br/>
    </td>
  </tr>    
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="CrossPlatformId" dataset="ds" fieldname="CrossPlatformId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.CrossPlatformId)%>" entityType="<%=LkSNEntityType.CrossPlatform%>" clazz="list-title"><%=ds.getField(Sel.CrossPlatformName).getHtmlString()%></snp:entity-link><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.CrossPlatformURL).getHtmlString()%></span>
    </td>
    <td>
      <% LookupItem status = LkSN.CrossPlatformStatus.findItemByCode(ds.getField(Sel.CrossPlatformStatus).getInt());%>
      <%=status.getHtmlDescription()%>
    </td>
    <td>
      <% LookupItem type = LkSN.CrossPlatformType.findItemByCode(ds.getField(Sel.CrossPlatformType).getInt());%>
      <%=type.getHtmlDescription()%>
    </td>
    
  </v:grid-row>
</v:grid>
