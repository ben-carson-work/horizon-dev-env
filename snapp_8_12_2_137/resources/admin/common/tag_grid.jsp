<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"));

QueryDef qdef = new QueryDef(QryBO_Tag.class)
    .addFilter(QryBO_Tag.Fil.EntityType, entityType.getCode())
    .addSort(QryBO_Tag.Sel.TagName)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addSelect(
        QryBO_Tag.Sel.IconName,
        QryBO_Tag.Sel.TagId,
        QryBO_Tag.Sel.TagCode,
        QryBO_Tag.Sel.TagName);

JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

String gridClass = "";
if (entityType.isLookup(LkSNEntityType.Unknown)) { 
  gridClass = "hidden";
}
%>

<v:grid id="tag-grid-table" clazz="<%=gridClass%>" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Tag%>">
  <thead>
    <v:grid-title caption="<%=entityType.getRawDescription()%>"/>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="100%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td><v:grid-checkbox name="TagId" dataset="ds" fieldname="TagId"/></td>
      <td><v:grid-icon name="<%=ds.getField(QryBO_Tag.Sel.IconName).getString()%>"/></td>
      <td>
        <a class="list-title" href="javascript:asyncDialogEasy('common/tag_edit_dialog', 'ListMode=true&id=<%=ds.getField(QryBO_Tag.Sel.TagId).getHtmlString()%>')"><%=ds.getField(QryBO_Tag.Sel.TagName).getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField(QryBO_Tag.Sel.TagCode).getHtmlString()%></span>&nbsp;
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    