<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ProductFamily.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_ProductFamily.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.ProductFamilyId);
qdef.addSelect(Sel.CategoryId);
qdef.addSelect(Sel.ProductFamilyStatus);
qdef.addSelect(Sel.ProductFamilyCode);
qdef.addSelect(Sel.ProductFamilyName);
qdef.addSelect(Sel.ShowNameExt);
qdef.addSelect(Sel.ProductFamilyNameExt);
qdef.addSelect(Sel.TargetProductFamilyId);
qdef.addSelect(Sel.ProfilePictureId);
qdef.addSelect(Sel.CategoryRecursiveName);
qdef.addSelect(Sel.ProductCount);
qdef.addSelect(Sel.RepositoryCount);
qdef.addSelect(Sel.ParentEntityId);
qdef.addSelect(Sel.ParentEntityType);
qdef.addSelect(Sel.ParentEntityName);
qdef.addSelect(Sel.CommonStatus);
// Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));
if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));
if ((pageBase.getNullParameter("ProductFamilyStatus") != null))
  qdef.addFilter(Fil.ProductFamilyStatus, JvArray.stringToArray(pageBase.getNullParameter("ProductFamilyStatus"), ","));
if (pageBase.hasParameter("ParentEntityId"))
  qdef.addFilter(Fil.ParentEntityId, pageBase.getNullParameter("ParentEntityId"));

// Sort
qdef.addSort(Sel.ProductFamilyName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="15%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="25%">
      <v:itl key="@Common.Parent"/><br/>
      <v:itl key="@Category.Category"/>            
    </td>
    <td>&nbsp;</td>
    <td width="45%">
      <v:itl key="@Product.UpgradeProductFamily"/>
    </td>
    <td width="15%">
      <v:itl key="@Common.Status"/><br/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="ProductFamilyId" dataset="ds" fieldname="ProductFamilyId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.ProfilePictureId).getString()%>"/></td>
    <td>
      <a href="<v:config key="site_url"/>/admin?page=prodfamily&id=<%=ds.getField(Sel.ProductFamilyId).getEmptyString()%>" class="list-title"><%=ds.getField(Sel.ProductFamilyName).getHtmlString()%></a><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.ProductFamilyCode).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
    <% if (ds.getField(Sel.ParentEntityId).isNull()) { %>
      <span class="list-subtitle"><v:itl key="@Common.None"/></span>
    <% } else { %>
      <% String hrefParent = BLBO_PagePath.getUrl(pageBase, ds.getField(Sel.ParentEntityType).getInt(), ds.getField(Sel.ParentEntityId).getString()); %>
      <a href="<%=hrefParent%>"><%=ds.getField(Sel.ParentEntityName).getHtmlString()%></a>
    <% } %>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%>&nbsp;</span>
    </td>
    <% if (ds.getField(Sel.TargetProductFamilyId).isNull()) { %>
      <td/>
      <td>
        <span class="list-subtitle"><v:itl key="@Common.None"/></span>
        <br/>
      </td>
    <% } else { %>
      <td><v:grid-icon name="<%=ds.getField(Sel.TargetIconName).getString()%>" repositoryId="<%=ds.getField(Sel.TargetProfilePictureId).getString()%>"/></td>
      <td>
        <a href="<v:config key="site_url"/>/admin?page=prodfamily&id=<%=ds.getField(Sel.TargetProductFamilyId).getEmptyString()%>"><%=ds.getField(Sel.TargetProductFamilyName).getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.TargetProductFamilyCode).getHtmlString()%>&nbsp;</span>
      </td>
    <% } %>
    <td>
      <% LookupItem productFamilyStatus = LkSN.ProductStatus.getItemByCode(ds.getField(Sel.ProductFamilyStatus)); %>
      <span class="list-subtitle"><%=productFamilyStatus.getDescription(pageBase.getLang())%></span>
    </td>
  </v:grid-row>
</v:grid>