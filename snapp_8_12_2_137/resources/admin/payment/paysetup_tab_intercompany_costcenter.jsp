<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePaymentSetup" scope="request"/>

<v:tab-toolbar>
  <% String hrefNew = "javascript:asyncDialogEasy('payment/intercompany_costcenter_dialog', 'id=new&pluginId=" + pageBase.getId() + "')"; %>
  <v:button-group>
    <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
    <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:deleteCostCenters()"/>
  </v:button-group>

  <v:button-group>
    <v:button id="status-btn" caption="@Common.Status" fa="flag" dropdown="true"/>
	  <v:popup-menu bootstrap="true">
	    <v:popup-item caption="@Common.Enable" href="javascript:updateIntercompanyCostCenter(true)"/>
	    <v:popup-item caption="@Common.Disable" href="javascript:updateIntercompanyCostCenter(false)"/>
	  </v:popup-menu>
  </v:button-group>
  
  <v:button-group>
    <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
    <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="IntercompanyCostCenter-grid"  onclick="exportCostCenter()"/>
  </v:button-group>
</v:tab-toolbar>

<v:tab-content>
	<div id="main-container">
		 <% String params = "PluginId=" + pageBase.getId() ; %>
    <v:async-grid id="IntercompanyCostCenter-grid" jsp="payment/intercompany_costcenter_grid.jsp" params="<%=params%>" />
	</div>
</v:tab-content>

<script>
function deleteCostCenters() {

  var ids = $("[name='IntercompanyCostCenterId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
   else {
     confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteIntercompanyCostCenter",
        DeleteIntercompanyCostCenter: {
          IntercompanyCostCenterIDs: ids
        }
      };
      
      vgsService("IntercompanyCostCenter", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.IntercompanyCostCenter.getCode()%>);
      });
    });
  }
}

 function updateIntercompanyCostCenter(status) {
  var ids = $("[name='IntercompanyCostCenterId']").getCheckedValues();
  
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
     else {
    var reqDO = {
        Command: "UpdateIntercompanyCostCenterStatus",
        UpdateIntercompanyCostCenterStatus: {
          IntercompanyCostCenterIDs: ids,
          IntercompanyCostCenterActive: status
        }
      };
      vgsService("IntercompanyCostCenter", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.IntercompanyCostCenter.getCode()%>);
      });
  }   
} 

function showImportDialog() {
	asyncDialogEasy("payment/intercompany_costcenter_snapp_import_dialog", "");
}
	    
function exportCostCenter() {
  var bean = getGridSelectionBean("#IntercompanyCostCenter-grid-table", "[name='IntercompanyCostCenterId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.IntercompanyCostCenter.getCode()%> + &QueryBase64=" + bean.queryBase64;
}


</script>