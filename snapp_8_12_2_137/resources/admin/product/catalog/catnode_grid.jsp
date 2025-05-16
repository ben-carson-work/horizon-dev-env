<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Catalog.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Catalog.class)
    .addFilter(Fil.ParentCatalogId, pageBase.getNullParameter("CatalogId"))
    .addSort(Sel.PriorityOrder)
    .addSelect(
        Sel.IconName,
        Sel.IconAlias,
        Sel.ForegroundColor,
        Sel.BackgroundColor,
        Sel.ProfilePictureId,
        Sel.CatalogId,
        Sel.CatalogName,
        Sel.CatalogCode,
        Sel.CatalogType,
        Sel.EntityType,
        Sel.EntityId,
        Sel.ManualChange,
        Sel.ButtonDisplayType,
        Sel.PricePointProductId,
        Sel.PricePointProductCode,
        Sel.PricePointProductName);

JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>


<v:grid id="catnode-grid-inner" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Catalog%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td></td>
      <td width="40%"><v:itl key="@Common.Name"/></td>
      <td width="30%"><v:itl key="@Common.Type"/></td>
      <td width="30%"><v:itl key="@Catalog.ButtonDisplayType"/></td>
      <td></td>
    </tr>
  </thead>
  
  <tbody>
    <v:ds-loop dataset="<%=ds%>">
      <tr class="grid-row" data-id="<%=ds.getField(Sel.CatalogId).getHtmlString()%>" data-entityid="<%=ds.getField(Sel.EntityId).getHtmlString()%>">
        <% LookupItem catalogType = LkSN.CatalogType.getItemByCode(ds.getField(Sel.CatalogType)); %>
        <% LookupItem entityType = LkSN.EntityType.findItemByCode(ds.getField(Sel.EntityType)); %>
        <td><v:grid-checkbox dataset="ds" fieldname="CatalogId" name="CatalogId"/></td>
        <td><v:grid-icon name="<%=ds.getField(Sel.IconName)%>" repositoryId="<%=ds.getField(Sel.ProfilePictureId)%>" iconAlias="<%=ds.getField(Sel.IconAlias)%>" foregroundColor="<%=ds.getField(Sel.ForegroundColor)%>" backgroundColor="<%=ds.getField(Sel.BackgroundColor)%>" /></td>
        <td>
          <% if (catalogType.isLookup(LkSNCatalogType.Folder) || ((entityType != null) && entityType.isLookup(LkSNEntityType.Event, LkSNEntityType.ProductFamily))) { %>
            <a class="list-title" href="javascript:selectFolder('<%=ds.getField(Sel.CatalogId).getEmptyString()%>')"><%=ds.getField(Sel.CatalogName).getHtmlString()%></a>
          <% } else { %>
            <b><%=ds.getField(Sel.CatalogName).getHtmlString()%></b>
          <% } %>
          <br/>
          <span class="list-subtitle"><%=ds.getField(Sel.CatalogCode).getHtmlString()%></span>
        </td>
        <td>
        <% if (catalogType.isLookup(LkSNCatalogType.Entity)) { %>
          <% if (entityType != null) { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.EntityId)%>" entityType="<%=entityType%>"  openOnNewTab="true"><%=entityType.getHtmlDescription(pageBase.getLang())%></snp:entity-link>
          <% } %>
        <% } else { %>
          <span class="list-subtitle"><%=catalogType.getHtmlDescription(pageBase.getLang())%></span>
        <% } %>
        <br/>
        <% if (ds.getField(Sel.ManualChange).getBoolean()) { %>
          <span class="list-subtitle"><v:itl key="@Catalog.ManualChange"/></span>
        <% } else { %>
          &nbsp;
        <% } %>
        </td>
        <td>
          <div class="list-subtitle"><%=LkSN.ButtonDisplayType.getItemByCode(ds.getField(Sel.ButtonDisplayType), LkSNButtonDisplayType._2x1).getHtmlDescription(pageBase.getLang())%></div>
          <div class="list-subtitle">
            <% if (ds.getField(Sel.PricePointProductId).isNull()) { %>
              &nbsp;
            <% } else { %>
              <v:itl key="@Catalog.PricePoint"/>
              <snp:entity-link entityId="<%=ds.getField(Sel.PricePointProductId)%>" entityType="<%=LkSNEntityType.ProductType%>" openOnNewTab="true">
                <%=ds.getField(Sel.PricePointProductName).getHtmlString()%>
              </snp:entity-link>
            <% } %>
          </div>
        </td>
        <td><span class="row-hover-visible"><i class="fa fa-bars drag-handle"></i></td>
      </tr>
    </v:ds-loop>
  </tbody>
</v:grid>

<script>

$("#catnode-grid-inner tbody").sortable({
  handle: ".drag-handle",
  helper: fixHelper,
  stop: function(event, ui) {
    var catalogId = ui.item.attr("data-id");
    var treeNode = $("#catalog-tree").find("[data-id='" + catalogId + "']");
    vgsService("Catalog", {
      Command: "ChangeNodePriority",
      ChangeNodePriority: {
        CatalogId: catalogId,
        PriorityOrder: ui.item.index()
      }
    });
  }
});
</script>