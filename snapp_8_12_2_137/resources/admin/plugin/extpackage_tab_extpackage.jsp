<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageExtensionPackage" scope="request"/>

<%
  boolean canCreate = pageBase.getRights().SuperUser.getBoolean() || pageBase.getRights().ExtensionPackages.canCreate();
  boolean canEdit = pageBase.getRights().SuperUser.getBoolean() || pageBase.getRights().ExtensionPackages.canUpdate();
%>

<div class="tab-toolbar">
  <v:button fa="upload" caption="@Common.UploadFile" onclick="asyncDialogEasy('plugin/extpackage_upload_dialog')" enabled="<%=canCreate%>"/>
  <v:button fa="sync-alt" caption="@Common.CheckForUpdates" href="javascript:showUpdatesDialog()" enabled="<%=canEdit%>"/>
  <v:pagebox gridId="extpackage-grid"/>
</div>
    
<div class="tab-content">
  <v:last-error/>

  <v:async-grid id="extpackage-grid" jsp="plugin/extpackage_grid.jsp"/>
</div>


<script>
function showUploadDialog() {
  vgsImportDialog("<v:config key="site_url"/>/admin?page=extpackage&action=upload");
}
function showUpdatesDialog() {
  asyncDialogEasy("plugin/extpackage_update_dialog");
}
</script>