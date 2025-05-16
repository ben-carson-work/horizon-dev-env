<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageRepositoryListWidget" scope="request"/>
<% 
boolean canEdit = !pageBase.isParameter("readonly", "true");
LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getEmptyParameter("EntityType"));
String tabContentClass = canEdit ? "repository-file-drop" : "";
TagAttributeBuilder tabContentAttributes = TagAttributeBuilder.builder().put("data-entitytype", request.getParameter("Repository_EntityType")).put("data-entityid", request.getParameter("Repository_EntityId")); 
%>

<v:tab-toolbar>
  <% String href = "javascript:showUploadDialog(" + request.getAttribute("Repository_EntityType") + ", '" + request.getAttribute("Repository_EntityId") + "', false);"; %>
  <v:button caption="Upload" href="<%=href%>" fa="upload" title="Upload a new document" enabled="<%=canEdit%>"/>
  <v:button id="repository-delete-button" caption="@Common.Delete" fa="trash" bindGrid="repository-grid" onclick="doDeleteRepository()" enabled="<%=canEdit%>"/>
  <v:pagebox gridId="repository-grid"/>
</v:tab-toolbar>
  
<v:tab-content id="repository_tab_content" clazz="<%=tabContentClass%>" attributes="<%=tabContentAttributes%>">
  <% String params = "EntityType=" + entityType.getCode() + "&EntityId=" + pageBase.getId() + "&canEdit=" + canEdit;%>
  <v:async-grid id="repository-grid" jsp="repository/repository_grid.jsp" params="<%=params%>" />
</v:tab-content>
  
<script>

function doDeleteRepository() {
  var ids = $("[name='cbRepositoryId']").getCheckedValues();
  if (ids == "")
    showMessage(itl("@Common.NoElementWasSelected"));
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "Delete",
        Delete: {
          RepositoryIDs: $("[name='cbRepositoryId']").getCheckedValues()
        }
      };
      
      vgsService("Repository", reqDO, false, function(ansDO) {
        showMessage("Deleted: " + ansDO.Answer.Delete.DeletedCount + "\nSkipped: " + ansDO.Answer.Delete.SkippedCount);
        triggerEntityChange(<%=LkSNEntityType.Repository.getCode()%>);
      });
    });
  }
}
</script>
