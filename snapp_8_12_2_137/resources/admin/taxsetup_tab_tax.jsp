<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTaxSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<div class="tab-toolbar">
  
  <% String hrefNew = ConfigTag.getValue("site_url") + "/admin?page=tax&id=new"; %>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
  <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:deleteTaxes()"/>
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="tax-grid"  onclick="exportTax()"/>
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Tax.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
      
  <v:pagebox gridId="tax-grid"/>
</div>

<v:last-error/>

<div class="tab-content">
  <v:async-grid id="tax-grid" jsp="tax_grid.jsp" />
</div>

<script>
function deleteTaxes() {
  var ids = $("[name='TaxId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteTax",
        DeleteTax: {
          TaxIDs: ids
        }
      };
      
      vgsService("Product", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.Tax.getCode()%>);
      });
    });
  }
}

function showImportDialog() {
  asyncDialogEasy("tax_snapp_import_dialog", "");
}
	        
function exportTax() {
  var bean = getGridSelectionBean("#tax-grid-table", "[name='TaxId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.Tax.getCode()%> + &QueryBase64=" + bean.queryBase64;
}
</script>
