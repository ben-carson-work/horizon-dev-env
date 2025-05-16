<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
  PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
  FtCRUD rightCRUD = pageBase.getRightCRUD();
  boolean canEdit = rightCRUD.canUpdate();
%>

<v:page-form page="sale_capacity_list">

  <div class="tab-toolbar">
    <v:button id="add-cat-button" caption="@Common.Add" fa="plus" href="javascript:addSaleCapacity()" enabled="<%=canEdit%>"/> 
    <v:button caption="@Common.Move" fa="arrows-alt" href="javascript:moveSaleCapacity()" enabled="<%=canEdit%>"/>
    <span class="divider"></span>
    <v:button caption="@Common.Delete" fa="trash" href="javascript:deleteSaleCapacity()" enabled="<%=canEdit%>"/> 
    <v:pagebox gridId="sale-capacity-grid"/>
  </div>
  
  <v:last-error/>
  
  <div class="tab-content">
    <% String params = "ProductId=" + pageBase.getId(); %>
    <v:async-grid id="sale-capacity-grid" jsp="product/salecapacity/sale_capacity_grid.jsp" params="<%=params%>"/>
  </div>

</v:page-form>

<script>

function addSaleCapacity() {
  asyncDialogEasy("product/salecapacity/sale_capacity_dialog", "ProductId=<%=pageBase.getId()%>&Operation=add");
}

function deleteSaleCapacity() {
  var ids = $("[name='SaleCapacityId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteSaleCapacity",
        DeleteSaleCapacity: {
          SaleCapacityIDs: ids
        }
      };
      
       vgsService("SaleCapacity", reqDO, false, function(ansDO) {
         triggerEntityChange(<%=LkSNEntityType.SaleCapacity.getCode()%>);
       });
    });  
  }
}

function moveSaleCapacity() {
  var ids = $("[name='SaleCapacityId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else 
    asyncDialogEasy("product/salecapacity/sale_capacity_dialog", "ProductId=<%=pageBase.getId()%>&Operation=move&SaleCapacityIDs=" + ids);
}

</script>