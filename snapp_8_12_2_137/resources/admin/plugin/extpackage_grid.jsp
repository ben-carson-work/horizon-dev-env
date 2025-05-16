<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ExtensionPackage.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_ExtensionPackage.class);
// Select
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.ExtensionPackageId);
qdef.addSelect(Sel.ExtensionPackageCode);
qdef.addSelect(Sel.ExtensionPackageName);
qdef.addSelect(Sel.ExtensionPackageVersion);
qdef.addSelect(Sel.Enabled);
qdef.addSelect(Sel.NeedRestart);
qdef.addSelect(Sel.JarSmoothSize);
// Where
// Sort
qdef.addSort(Sel.ExtensionPackageCode);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.ExtensionPackage%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="50%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Description"/>
    </td>
    <td width="50%" align="right">
      <v:itl key="@Common.Size"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
  </tr>
  <v:ds-loop dataset="<%=ds%>">
    <tr id="<%=ds.getField(Sel.ExtensionPackageId).getHtmlString()%>">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="ExtensionPackageId" dataset="ds" fieldname="ExtensionPackageId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.ExtensionPackageId)%>" entityType="<%=LkSNEntityType.ExtensionPackage%>" clazz="list-title">
          <%=ds.getField(Sel.ExtensionPackageCode).getHtmlString()%>
          <%=ds.getField(Sel.ExtensionPackageVersion).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=ds.getField(Sel.ExtensionPackageName).getHtmlString()%></span>
      </td>
      <td align="right" nowrap>
        <%=ds.getField(Sel.JarSmoothSize).getHtmlString()%><br/>
        <% String status = ds.getField(Sel.Enabled).getBoolean() ? "@Common.Active" : "@Common.Inactive"; %>
        <span class="list-subtitle"><v:itl key="<%=status%>"/></span>
      </td>
    </tr>
  </v:ds-loop>
</v:grid>

