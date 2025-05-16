<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_CodeAliasType.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_CodeAliasType.class);
// Select
qdef.addSelect(Sel.CodeAliasTypeId);
qdef.addSelect(Sel.CodeAliasTypeCode);
qdef.addSelect(Sel.CodeAliasTypeName);
qdef.addSelect(Sel.UniquePerObject);
qdef.addSelect(Sel.IconName);
// Filter
qdef.addFilter(Fil.CodeAliasTypeStatus, LkSNCodeAliasTypeStatus.Active.getCode());
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getParameter("FullText"));
if (pageBase.getNullParameter("CodeAliasTypeId") != null)
  qdef.addFilter(Fil.CodeAliasTypeId, pageBase.getNullParameter("CodeAliasTypeId"));

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef); 
request.setAttribute("ds", ds);

%>

<v:grid id="codealiastype-grid" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.CodeAliasType%>">
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
      <v:grid-checkbox dataset="ds" fieldname="CodeAliasTypeId" name="CodeAliasTypeId"/>
    </td>
    <td>
      <v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(QryBO_CodeAliasType.Sel.CodeAliasTypeId)%>" entityType="<%=LkSNEntityType.CodeAliasType%>" clazz="list-title">
        <%=ds.getField(QryBO_CodeAliasType.Sel.CodeAliasTypeName).getHtmlString()%>
      </snp:entity-link><br />
      <span class="list-subtitle"><%=ds.getField(QryBO_CodeAliasType.Sel.CodeAliasTypeCode).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>