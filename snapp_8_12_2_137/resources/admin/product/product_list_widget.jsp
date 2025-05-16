<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProductList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canCreate = rights.PromotionRules.canCreate(); %>
<%!
private String buildNewProdHREF(PageProductList pageBase, LookupItem productType) {
  return pageBase.getContextURL() + "?page=product&id=new&ProductType=" + productType.getCode() + "&ParentEntityType=" + pageBase.getEmptyParameter("ParentEntityType") + "&ParentEntityId=" + pageBase.getEmptyParameter("ParentEntityId");
}
%>

<v:page-form>

<div class="tab-toolbar">
  <% String hrefNewProductWizard = "javascript:asyncDialogEasy('product/product_create_dialog', 'ParentEntityType=" + pageBase.getEmptyParameter("ParentEntityType") + "&ParentEntityId=" + pageBase.getEmptyParameter("ParentEntityId") + "')"; %>
  <div class="btn-group">
    <v:button caption="@Common.New" title="@Product.NewProductType" fa="plus" href="<%=hrefNewProductWizard%>" enabled="<%=canCreate%>"/>
    <% if (canCreate) { %>
      <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
  		<v:popup-menu bootstrap="true">
	  	  <v:popup-item caption="@Common.Wizard" fa="magic" href="<%=hrefNewProductWizard%>"/>
	  	  <% for (LookupItem productType : LookupManager.getArray(LkSNProductType.Product, LkSNProductType.Package, LkSNProductType.Fee, LkSNProductType.Material)) { %>
          <v:popup-item caption="<%=productType.getRawDescription()%>" icon="<%=BLBO_Product.getIconName(productType)%>" href="<%=buildNewProdHREF(pageBase, productType)%>"/>
        <% } %>
		  </v:popup-menu>
		<% } %>
  </div>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:deleteProducts()" enabled="<%=rights.ProductTypes.getOverallCRUD().canDelete()%>"/>
  <span class="divider"></span>
  <v:button caption="@Common.Edit" fa="pencil" title="@Product.ProductsMultiEdit" href="javascript:showProductMultiEditDialog()" enabled="<%=rights.ProductTypes.getOverallCRUD().canUpdate()%>"/>
  <v:pagebox gridId="product-grid"/>
</div>


<div class="tab-content">    
  <v:last-error/>
  
  <% String params = "ParentEntityType=" + pageBase.getParameter("ParentEntityType") + "&ParentEntityId=" + pageBase.getParameter("ParentEntityId"); %>
  <v:async-grid id="product-grid" jsp="product/product_grid.jsp" params="<%=params%>"/>
</div>

</v:page-form>

<script>
function deleteProducts() {
  
  var ids = $("[name='ProductId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteProducts",
        DeleteProducts: {
          ProductIDs: ids
        }
      };
      
      if ($("#prod-grid-table").hasClass("multipage-selected")) {
        reqDO.DeleteProducts.PerformanceIDs = null;            
        reqDO.DeleteProducts.QueryBase64 = $("#prod-grid-table").attr("data-QueryBase64");            
      }

      vgsService("Product", reqDO, false, function(ansDO) {
        showAsyncProcessDialog(ansDO.Answer.DeleteProducts.AsyncProcessId, function() {
          triggerEntityChange(<%=LkSNEntityType.ProductType.getCode()%>);
        });
      });
    });  
  }
}
</script>

