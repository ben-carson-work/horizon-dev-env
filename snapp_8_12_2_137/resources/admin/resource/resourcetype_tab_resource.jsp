<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageResourceType" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%boolean canCreate=rights.ResourceManagement.canCreate(); %>
<%boolean canDelete=rights.ResourceManagement.canDelete(); %>

<v:page-form>
<v:input-text type="hidden" field="restype.ResourceTypeId"/>

<div class="tab-toolbar">
  <% String hrefNew = ConfigTag.getValue("site_url") + "/admin?page=account&id=new&EntityType=" + LkSNEntityType.Resource.getCode() + "&ResourceTypeId=" + pageBase.getId(); %>
  <v:button fa="plus" caption="@Common.New" href="<%=hrefNew%>" enabled="<%=canCreate%>"/>
  <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:doDeleteResources()" enabled="<%=canDelete%>"/>
   <span class="divider"></span>
   <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Resource.getCode() + ")";%>
   <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  
  <v:pagebox gridId="resource-grid"/>
</div>

<div class="tab-content">
  <% String params = "ResourceTypeId=" + pageBase.getId(); %>
  <v:async-grid id="resource-grid" jsp="resource/resource_grid.jsp" params="<%=params%>"></v:async-grid>
</div>

</v:page-form>

<script>
function doDeleteResources() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteResource",
      DeleteResource: {
        ResourceIDs: $("[name='AccountId']").getCheckedValues()
      }
    };
    
    vgsService("Resource", reqDO, false, function(ansDO) {
    	window.location.reload();
    });
  });
}
</script>