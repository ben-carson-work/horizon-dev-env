<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<div class="tab-toolbar">
  <v:button caption="@Common.New" fa="plus" title="@SaleChannel.NewSaleChannel" href="admin?page=salechannel&id=new"/>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:doDeleteSaleChannels()"/>
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="salechannel-grid"  onclick="exportSaleChannel()"/>  
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.SaleChannel.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  <v:pagebox gridId="salechannel-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <v:async-grid id="salechannel-grid" jsp="dynprice/salechannel_grid.jsp" />
</div>

<script>
function doDeleteSaleChannels() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "Delete",
      Delete: {
        SaleChannelIDs: $("[name='cbSaleChannelId']").getCheckedValues()
      }
    };
    
    vgsService("SaleChannel", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.SaleChannel.getCode()%>);
    });
  });
}

function showImportDialog() {
  asyncDialogEasy("dynprice/salechannel_snapp_import_dialog", "");
}
	      
function exportSaleChannel() {
  var bean = getGridSelectionBean("#salechannel-grid-table", "[name='cbSaleChannelId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.SaleChannel.getCode()%> + &QueryBase64=" + bean.queryBase64;
}
	
</script>
