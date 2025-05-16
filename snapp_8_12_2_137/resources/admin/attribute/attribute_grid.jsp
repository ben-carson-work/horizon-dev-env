<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
QueryDef qdef = new QueryDef(QryBO_Attribute.class);
// Select
qdef.addSelect(QryBO_Attribute.Sel.IconName);
qdef.addSelect(QryBO_Attribute.Sel.AttributeId);
qdef.addSelect(QryBO_Attribute.Sel.AttributeCode);
qdef.addSelect(QryBO_Attribute.Sel.AttributeName);
qdef.addSelect(QryBO_Attribute.Sel.AttributeWeight);
qdef.addSelect(QryBO_Attribute.Sel.ParentEntityType);
qdef.addSelect(QryBO_Attribute.Sel.ParentEntityId);
qdef.addSelect(QryBO_Attribute.Sel.ParentEntityName);
qdef.addSelect(QryBO_Attribute.Sel.ItemNames);
// Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(QryBO_Attribute.Fil.FullText, pageBase.getParameter("FullText"));
if (pageBase.getNullParameter("ParentEntityId") != null)
  qdef.addFilter(QryBO_Attribute.Fil.ParentEntityId, pageBase.getParameter("ParentEntityId"));
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(QryBO_Attribute.Sel.AttributeWeight);
qdef.addSort(QryBO_Attribute.Sel.AttributeName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="attribute-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Attribute%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="15%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="15%">
      <v:itl key="@Common.Parent"/>
    </td>
    <td width="10%">
      <v:itl key="@Common.PriorityOrder"/>
    </td>
    <td width="60%">
      <v:itl key="@Common.Items"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox name="AttributeId" dataset="ds" fieldname="AttributeId"/></td>
    <td><v:grid-icon name="<%=ds.getField(QryBO_Attribute.Sel.IconName).getString()%>"/></td>
    <td>
      <%       
      FtCRUD rights = pageBase.getEntityRightCRUD(LkSNEntityType.Attribute, ds.getField(QryBO_Attribute.Sel.AttributeId).getString(), pageBase.getBL(BLBO_Attribute.class).getAttributeLocationIDs(ds.getField(QryBO_Attribute.Sel.AttributeId).getString()));
      String hRef="";
      if (rights.canRead()) 
        hRef="javascript:asyncDialogEasy('attribute/attribute_dialog', 'id=" + ds.getField(QryBO_Attribute.Sel.AttributeId).getHtmlString() + "')";
      else
        hRef="javascript:showMessage('Warning: The user does not have the required permission level.');";
        
      LookupItem parentEntityType = LkSN.EntityType.findItemByCode(ds.getField(QryBO_Attribute.Sel.ParentEntityType));
      %>
      <a href="<%=hRef%>" class="list-title"><%=ds.getField(QryBO_Attribute.Sel.AttributeName).getHtmlString()%></a><br/>      
      <span class="list-subtitle"><%=ds.getField(QryBO_Attribute.Sel.AttributeCode).getHtmlString()%></span>
    </td>
    <td>
      <% if (!ds.getField(QryBO_Attribute.Sel.ParentEntityId).isNull()) { %>
        <% String hrefParent = BLBO_PagePath.getUrl(pageBase, ds.getField(QryBO_Attribute.Sel.ParentEntityType).getInt(), ds.getField(QryBO_Attribute.Sel.ParentEntityId).getString()); %>
        <a href="<%=hrefParent%>"><%=ds.getField(QryBO_Attribute.Sel.ParentEntityName).getHtmlString()%></a>&nbsp;<br/>
        <span class="list-subtitle"><%=(parentEntityType == null) ? "&nbsp;" : parentEntityType.getHtmlDescription(pageBase.getLang())%></span>
      <% } %>
    </td>
    <td><%=ds.getField(QryBO_Attribute.Sel.AttributeWeight).getHtmlString()%></td>
    <td><span class="list-subtitle"><%=ds.getField(QryBO_Attribute.Sel.ItemNames).getHtmlString()%></span></td>
  </v:grid-row>
</v:grid>
