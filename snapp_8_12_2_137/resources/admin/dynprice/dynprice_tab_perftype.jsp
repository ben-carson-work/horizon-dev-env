<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
String parentEntityType = pageBase.getEmptyParameter("ParentEntityType");
String parentEntityId = pageBase.getEmptyParameter("ParentEntityId");
%>

<div class="tab-toolbar">
  <% String hrefNew = "admin?page=performancetype&id=new&ParentEntityType=" + parentEntityType + "&ParentEntityId=" + parentEntityId; %>
  <v:button caption="@Common.New" title="@Performance.NewPerformanceType" fa="plus" href="<%=hrefNew%>" />
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:doDeletePerfTypes()"/>
  <v:copy-paste-buttonset entityType="<%=LkSNEntityType.PerformanceType%>" />
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="perftype-grid"  onclick="exportPerfType()"/>
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.PerformanceType.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  <v:pagebox gridId="perftype-grid"/>
</div>

<div class="tab-content">
  <% String params = "ParentEntityId=" + parentEntityId; %>
  <v:async-grid id="perftype-grid" jsp="performance/performancetype_grid.jsp" params="<%=params%>"/>
</div>


<script>
function doDeletePerfTypes() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeletePerformanceType",
      DeletePerformanceType: {
        PerformanceTypeIDs: $("[name='perfType\\.PerformanceTypeId']").getCheckedValues()
      }
    };
    
    vgsService("Performance", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.PerformanceType.getCode()%>);
    });
  });
}

function showImportDialog() {
  asyncDialogEasy("performance/perftype_snapp_import_dialog", "");
}
    
function exportPerfType() {
  var bean = getGridSelectionBean("#perftype-grid-table", "[name='perfType\\.PerformanceTypeId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.PerformanceType.getCode()%> + &QueryBase64=" + bean.queryBase64;
}
  
</script>
