<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<div class="tab-toolbar">
  <v:button caption="@Common.New" fa="plus" href="javascript:asyncDialogEasy('dynprice/ratecode_dialog', 'id=new')"/>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:doDelete()"/>
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="ratecode-grid"  onclick="exportRateCode()"/>
  <v:pagebox gridId="ratecode-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <v:async-grid id="ratecode-grid" jsp="dynprice/ratecode_grid.jsp" />
</div>

<script>
function doDelete() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteRateCode",
      DeleteRateCode: {
        RateCodeIDs: $("[name='RateCodeId']").getCheckedValues()
      }
    };
    
    vgsService("Product", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.RateCode.getCode()%>);
    });
  });
}

function showImportDialog() {
	asyncDialogEasy("dynprice/ratecode_snapp_import_dialog", "");
}
    
function exportRateCode() {
  var bean = getGridSelectionBean("#ratecode-grid-table", "[name='RateCodeId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.RateCode.getCode()%> + &QueryBase64=" + bean.queryBase64;
}
	
</script>
