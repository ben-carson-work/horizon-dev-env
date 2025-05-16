<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_MetaFieldGroup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_MetaFieldGroup.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.MetaFieldGroupId,
    Sel.MetaFieldGroupCode,
    Sel.MetaFieldGroupName,
    Sel.SearchMatchType);
//Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getParameter("FullText"));
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
//qdef.addSort(Sel.FieldType);
qdef.addSort(Sel.MetaFieldGroupName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.MetaFieldGroup%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="100%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox name="MetaFieldGroupId" dataset="ds" fieldname="MetaFieldGroupId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <a href="javascript:asyncDialogEasy('metadata/metafieldgroup_dialog', 'id=<%=ds.getField(Sel.MetaFieldGroupId).getHtmlString()%>')" class="list-title"><%=ds.getField(Sel.MetaFieldGroupName).getHtmlString()%></a><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.MetaFieldGroupCode).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>
