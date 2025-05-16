<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageCategoryList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"));%>
<% boolean canCreate = pageBase.getCategoryRights(entityType).canCreate(); %> 
<% boolean canRead = pageBase.getCategoryRights(entityType).canRead(); %>
<% boolean canEdit = pageBase.getCategoryRights(entityType).canUpdate(); %>
<% boolean canDelete = pageBase.getCategoryRights(entityType).canDelete(); %> 
<% JvDataSet ds = pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(Integer.valueOf(pageBase.getParameter("EntityType"))); %>
<% request.setAttribute("ds", ds); %>

<v:page-form page="category_list">

<v:tab-toolbar>
  <v:button-group>
    <v:button id="btn-add-category" caption="@Common.Add" fa="plus" enabled="<%=canCreate%>"/> 
    <v:button id="btn-del-category" caption="@Common.Delete" fa="trash" bindGrid="category-grid" enabled="<%=canDelete%>"/>
  </v:button-group> 

  <v:button id="btn-move-category" caption="@Common.Move" fa="arrows-alt" enabled="<%=canEdit%>"/>
  
  <v:button-group>
    <v:button id="btn-import-category" caption="@Common.Import" fa="sign-in" bindGrid="category-grid" bindGridEmpty="true"/>
    <v:button id="btn-export-category" caption="@Common.Export" fa="sign-out" bindGrid="category-grid" bindGridEmpty="true"/>
  </v:button-group>

  <v:button id="btn-history-category" caption="@Common.History" fa="history" bindGrid="category-grid" bindGridEmpty="true" enabled="<%=rights.History.getBoolean()%>"/>
</v:tab-toolbar>

<v:tab-content>
  
  <v:grid id="category-grid" clazz="grid-widget-container">
    <tr class="header">
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.Forms"/><br/>
        <v:itl key="@Account.Locations"/>
      </td>
      <td width="29%">
        <v:itl key="@Common.Tags"/><br/>
      </td>
      <td width="29%">
        <v:itl key="@Account.AccountContexts"/><br/>
      </td>
      <td width="2%"></td>
    </tr>
    <v:grid-row dataset="ds">
      <td><v:grid-checkbox name="CategoryId" dataset="ds" fieldname="CategoryId"/></td>
      <td><v:grid-icon name="<%=ds.getField(QryBO_Category.Sel.IconName).getNullString()%>" repositoryId="<%=ds.getField(QryBO_Category.Sel.ProfilePictureId).getNullString()%>"/></td>
      <td>
        <% for (int i=0; i<ds.getField("IndentCount").getInt(); i++) { %>
          &mdash;
        <% } %>
        <snp:entity-link entityId="<%=ds.getField(QryBO_Category.Sel.CategoryId)%>" entityType="<%=LkSNEntityType.Category%>">
          <%=ds.getField(QryBO_Category.Sel.CategoryNameITL).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=ds.getField(QryBO_Category.Sel.CategoryCode).getHtmlString()%></span>&nbsp;
      </td>
      <td>
        <span class="<%=ds.getField(QryBO_Category.Sel.InheritMask).getBoolean() ? "list-subtitle" : ""%>"><%=ds.getField(QryBO_Category.Sel.MaskNames).getHtmlString()%></span>&nbsp;<br/>
        <span class="<%=ds.getField(QryBO_Category.Sel.InheritLocation).getBoolean() ? "list-subtitle" : ""%>"><%=ds.getField(QryBO_Category.Sel.LocationNames).getHtmlString()%></span>&nbsp;
      </td>
      <td>
        <span class="list-subtitle"><%=ds.getField(QryBO_Category.Sel.TagNames).getHtmlString()%></span>
      </td>
      <td>
        <span class="<%=ds.getField(QryBO_Category.Sel.InheritAccountContext).getBoolean() ? "list-subtitle" : ""%>"><%=ds.getField(QryBO_Category.Sel.AccountContextNames).getHtmlString()%></span>&nbsp;
      </td>
      
      <td align="right">
        <v:button clazz="btn-add-category row-hover-visible" fa="plus"/>
      </td>
    </v:grid-row>
  </v:grid>
</v:tab-content>

</v:page-form>

<script>

$(document).ready(function() {
  $("#btn-add-category").click(addCategory);
  $(".btn-add-category").click(addCategory);
  $("#btn-del-category").click(deleteCategory);
  $("#btn-move-category").click(moveCategory);
  $("#btn-import-category").click(showImportDialog);
  $("#btn-export-category").click(exportCategory);
  $("#btn-history-category").click(showHistory);
  
  function showHistory() {
    showHistoryLog(<%=LkSNEntityType.Category.getCode()%>);
  }
  
  function addCategory() {
    var parentCategoryId = $(this).closest("tr").find(".cblist").val();
    if (parentCategoryId)  
      asyncDialogEasy("category_dialog", "EntityType=<%=pageBase.getParameter("EntityType")%>&Operation=add&ParentCategoryId=" + parentCategoryId);
    else
      asyncDialogEasy("category_dialog", "EntityType=<%=pageBase.getParameter("EntityType")%>&Operation=add");
  }

  function deleteCategory() {
    var ids = $("[name='CategoryId']").getCheckedValues();
    if (ids == "")
      showMessage(itl("@Common.NoElementWasSelected"));
    else {
      confirmDialog(null, function() {
        snpAPI.cmd("Category", "DeleteCategory", {
          CategoryIDs: ids
        })
        .then(ansDO => {
          window.location = "<%=pageBase.getContextURL()%>?page=category_list&EntityType=<%=pageBase.getParameter("EntityType")%>";
        });

      });  
    }
  }

  function moveCategory() {
    var ids = $("[name='CategoryId']").getCheckedValues();
    if (ids == "")
      showMessage(itl("@Common.NoElementWasSelected"));
    else 
      asyncDialogEasy("category_dialog", "EntityType=<%=pageBase.getParameter("EntityType")%>&Operation=move&CategoryIDs=" + ids);
  }

  function showImportDialog() {
    asyncDialogEasy("category_snapp_import_dialog", "EntityType=<%=pageBase.getParameter("EntityType")%>");
  }

  function exportCategory() {
    window.location = BASE_URL + "/admin?page=export&EntityIDs=<%=entityType.getCode()%>&EntityType=<%=LkSNEntityType.Category.getCode()%>"
  }
});

</script>