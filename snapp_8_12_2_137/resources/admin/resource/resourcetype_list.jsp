<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageResourceTypeList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%boolean canCreate=rights.ResourceManagement.canCreate(); %>
<%boolean canDelete=rights.ResourceManagement.canDelete(); %>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<v:last-error/>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <% String hrefNew = ConfigTag.getValue("site_url") + "/admin?page=resourcetype&id=new"; %>
      <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>" enabled="<%=canCreate%>"/>
      <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:doDeleteResourceTypes()" enabled="<%=canDelete%>"/>
      
      <span class="divider"></span>
      <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.ResourceType.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
      <v:pagebox gridId="resourcetype-grid"/>
    </div>
    
    <div class="tab-content">
      <v:async-grid id="resourcetype-grid" jsp="resource/resourcetype_grid.jsp" />
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<script>
function doDeleteResourceTypes() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteResourceType",
      DeleteResourceType: {
        ResourceTypeIDs: $("[name='ResourceTypeId']").getCheckedValues()
      }
    };
    
    vgsService("Resource", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.ResourceType.getCode()%>);
    });
  });
}
</script>
 
<jsp:include page="/resources/common/footer.jsp"/>
