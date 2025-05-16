<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Catalog.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Catalog.class)
    .addSelect(
        Sel.IconName,
        Sel.ProfilePictureId,
        Sel.CatalogId,
        Sel.CatalogName,
        Sel.ItemCount)
    .addSort(Sel.CatalogName)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addFilter(Fil.ParentCatalogId, (String)null)
    .addFilter(Fil.CatalogType, LkSNCatalogType.Catalog.getCode());

if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));

// Exec    
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>


<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Catalog%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td></td>
      <td width="50%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/><br/>
      </td>
      <td width="50%" align="right">
        <v:itl key="@Common.Items"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row dataset="ds">
      <td><v:grid-checkbox dataset="ds" fieldname="CatalogId" name="CatalogId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.ProfilePictureId).getString()%>"/></td>
      <td>
        <a class="list-title" href="<v:config key="site_url"/>/admin?page=catalog&id=<%=ds.getField(Sel.CatalogId).getEmptyString()%>"><%=ds.getField(Sel.CatalogName).getHtmlString()%></a><br/>
        <span class="list-subtitle"></span><br/>
      </td>
      <td align="right"><%=ds.getField(Sel.ItemCount).getHtmlString()%></td>
    </v:grid-row>
  </tbody>
</v:grid>