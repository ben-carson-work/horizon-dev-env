<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
FtCRUD rightLevel = pageBase.getBL(BLBO_Right.class).getEntityRightCRUD(LkSNEntityType.ProductType, pageBase.getId());
boolean canEdit = rightLevel.canUpdate();
boolean bulkAllowed = rights.BulkEntitlementReplace.getBoolean() && canEdit;
%>

<v:dialog id="entitlement_version_list_dialog" tabsView="true" title="@Entitlement.Versioning" width="800" height="600" autofocus="false">
<div class="tab-content">
  <div class="form-toolbar" style="margin-top:10px">
    <v:itl key="@Common.Help"/> <v:hint-handle hint="@Entitlement.EntitlementVersionHelp"/>
    <v:pagebox gridId="entitlement-version-grid"/>
  </div>
  <% String params = "ProductId=" + pageBase.getId(); %>
  <v:async-grid id="entitlement-version-grid" jsp="product/entitlement_version_grid.jsp" params="<%=params%>" />
</div>

<script>

$(document).ready(function() {
  var $dlg = $("#entitlement_version_list_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
    	<% if (bulkAllowed) { %>
    	{
        text: itl("@Entitlement.SaveNewVersion"),
        click: function() {
        	asyncDialogEasy("product/entitlement_version_create_dialog", "id=" + <%=JvString.jsString(pageBase.getId())%>);
        }
    	},
    	<% } %>
    	{
    		text: itl("@Common.Close"),
    		click: doCloseDialog
    	}
    ]; 
  });
});

</script>

</v:dialog>