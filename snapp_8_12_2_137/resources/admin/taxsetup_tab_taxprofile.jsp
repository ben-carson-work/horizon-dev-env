<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTaxSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<div class="tab-toolbar">
  <% String hrefNew = "javascript:asyncDialogEasy('taxprofile_dialog', 'id=new')";%>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
  <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:deleteTaxProfiles()"/>
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="taxprofile-grid"  onclick="exportTax()"/>
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.TaxProfile.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
      
  <v:pagebox gridId="taxprofile-grid"/>
</div>

<v:last-error/>

<div class="tab-content">
  <v:async-grid id="taxprofile-grid" jsp="taxprofile_grid.jsp" />
</div>

<script>
function deleteTaxProfiles() {
  var ids = $("[name='TaxProfileId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteTaxProfile",
        DeleteTaxProfile: {
          TaxProfileIDs: ids
        }
      };
      
      vgsService("Product", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.TaxProfile.getCode()%>);
      });
    });
  }
}

function showImportDialog() {
  asyncDialogEasy("taxprofile_snapp_import_dialog", "");
}
	          
function exportTax() {
  var bean = getGridSelectionBean("#taxprofile-grid-table", "[name='TaxProfileId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.TaxProfile.getCode()%> + &QueryBase64=" + bean.queryBase64;
}
</script>
