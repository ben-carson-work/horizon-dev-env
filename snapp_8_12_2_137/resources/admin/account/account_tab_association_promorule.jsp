<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<%
FtCRUD rightCRUD = (FtCRUD)request.getAttribute("rightCRUD");
boolean canEdit = rightCRUD.canUpdate(); 
%>

<v:page-form>

<div class="tab-toolbar">
  <% String hRefAdd="javascript:showSearchDialog(" + LkSNEntityType.PromoRule.getCode() + ")";%>
  <v:button caption="@Common.Add" title="@Account.AddPromorule2Association" fa="plus" href="<%=hRefAdd%>" enabled="<%=canEdit%>"/>

  <% String hRefRemove="javascript:deleteProducts()";%>
  <v:button caption="@Common.Remove" fa="minus" title="@Account.RemovePromorulesFromAssociation" href="<%=hRefRemove%>" enabled="<%=canEdit%>"/>
  
  <v:pagebox gridId="product-grid"/>
</div>


<div class="tab-content">    
  <v:last-error/>
  
  <% String params = "AssociationId=" + pageBase.getId() + "&ProductType=" + LkSNProductType.PromoRule.getCode(); %>
  <v:async-grid id="product-grid" jsp="product/product_grid.jsp" params="<%=params%>"/>
</div>

</v:page-form>

<script>

function showSearchDialog(entityType) {
  showLookupDialog({
    EntityType: entityType,
    onPickup: function(item) {
      var reqDO = {
        Command: "AddProduct2Association",
        AddProduct2Association: {
          EntityType: <%=LkSNEntityType.Association.getCode()%>,
          AccountId: <%=account.AccountId.getJsString()%>,
          ProductId: item.ItemId,
          ProductType: <%=LkSNProductType.PromoRule.getCode()%>
        }
      };
      
      console.log(reqDO);
      
      vgsService("Account", reqDO, false, function() {
    	  changeGridPage("#product-grid", 1);
      });
    }
  });
}

function deleteProducts() {
  var ids = $("[name='ProductId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "RemoveProductsFromAssociation",
        RemoveProductsFromAssociation: {
          AccountId: <%=account.AccountId.getJsString()%>,	
          ProductIDs: ids,
          ProductType: <%=LkSNProductType.PromoRule.getCode()%>
        }
      };

      vgsService("Account", reqDO, false, function() {
    	  changeGridPage("#product-grid", 1);
        });
      });
  }
}
</script>

