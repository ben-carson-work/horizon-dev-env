<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePluginConfig" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  boolean canCreate = rights.SuperUser.getBoolean() || pageBase.getRights().ExtensionPackages.canCreate();
  boolean canDelete = rights.SuperUser.getBoolean() || pageBase.getRights().ExtensionPackages.canDelete();
%>

<v:last-error/>
<v:page-form>

<script>
  function search() {
    setGridUrlParam("#font-grid", "FullText", $("#full-text-search").val());
  }
  
  function deleteFonts() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteFont",
        DeleteFont: {
          FontIDs: $("[name='FontId']").getCheckedValues()
        }
      };

      showWaitGlass();
      vgsService("Repository", reqDO, false, function(ansDO) {
        hideWaitGlass();
        triggerEntityChange(<%=LkSNEntityType.Font.getCode()%>);
      });
    });
  }
</script>

    <div class="tab-toolbar">
      <v:button caption="@Common.New" fa="plus" onclick="asyncDialogEasy('plugin/font_upload_dialog')" enabled="<%=canCreate%>"/>
      <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" onclick="deleteFonts()" enabled="<%=canDelete%>"/>
      <v:pagebox gridId="font-grid"/>
    </div>

	<div class="tab-content">
   		<v:async-grid id="font-grid" jsp="plugin/font_grid.jsp" />
   	</div>
    
</v:page-form>