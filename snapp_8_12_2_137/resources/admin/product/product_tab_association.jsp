<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="product" scope="request" class="com.vgs.snapp.dataobject.DOProduct"/>

<%
FtCRUD rightCRUD = pageBase.getRightCRUD(); 
boolean canEdit = rightCRUD.canUpdate(); 
%>

<v:page-form>

<div class="tab-toolbar">
  <% String hRefAdd="javascript:showSearchDialog(" + LkSNEntityType.Association.getCode() + ")";%>
  <v:button caption="@Common.Add" title="@Account.AddAssociation2Product" fa="plus" href="<%=hRefAdd%>" enabled="<%=canEdit%>"/>

  <% String hRefRemove="javascript:removeAssociations()";%>
  <v:button caption="@Common.Remove" fa="minus" title="@Account.RemoveAssociationsFromProduct" href="<%=hRefRemove%>" enabled="<%=canEdit%>"/>
  
  <v:pagebox gridId="account-grid"/>
</div>


<div class="tab-content">    
  <v:last-error/>
  
  <% String params = "ProductId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Association.getCode(); %>
  <v:async-grid id="account-grid" jsp="account/account_grid.jsp" params="<%=params%>"/>
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
          EntityType: <%=LkSNEntityType.ProductType.getCode()%>, 	
          ProductId: <%=product.ProductId.getJsString()%>,
          AccountId: item.ItemId,
          ProductType: <%=LkSNProductType.Product.getCode()%>
        }
      };
      
      vgsService("Account", reqDO, false, function() {
    	  changeGridPage("#account-grid", 1);
      });
    }
  });
}

function removeAssociations() {
  var ids = $("[name='cbEntityId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "RemoveAssociationsFromProduct",
        RemoveAssociationsFromProduct: {
          ProductId: <%=product.ProductId.getJsString()%>,	
          AccountIDs: ids,
          ProductType: <%=LkSNProductType.Product.getCode()%>
        }
      };

      vgsService("Account", reqDO, false, function() {
    	  changeGridPage("#account-grid", 1);
        });
      });
  }
	}


</script>

