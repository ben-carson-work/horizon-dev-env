<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
  PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
	boolean canEdit = rights.Products.getOverallCRUD().canUpdate();
	String productId = pageBase.getNullParameter("ProductId");
	String membershipPointId = pageBase.getNullParameter("MembershipPointId");
  String params = "";
 	if (productId != null)
 	  params = "ProductId=" + productId;
 	else if (membershipPointId != null)
 	  params = "MembershipPointId=" + membershipPointId; 
%>

<v:tab-toolbar>
  <v:button-group>
    <v:button id="btn-add-rule" caption="@Common.Add" fa="plus" enabled="<%=canEdit%>"/> 
    <v:button id="btn-del-rule" caption="@Common.Delete" fa="trash" enabled="<%=canEdit%>"/>
  </v:button-group>
   
  <v:pagebox gridId="rewardpoint-accrualrule-grid"/>
</v:tab-toolbar>

<v:tab-content> 
  <v:async-grid id="rewardpoint-accrualrule-grid" jsp="product/rewardpoint/rewardpoint_accrualrule_grid.jsp" params="<%=params%>"/>
</v:tab-content>

<script>

$(document).ready(function() {
  $("#btn-add-rule").click(_addRule);
  $("#btn-del-rule").click(_delRule);
  
  function _addRule() {
    asyncDialogEasy("product/rewardpoint/rewardpoint_accrualrule_dialog", "<%=params%>");
  }

  function _delRule() {
    var ids = $("[name='RewardPointAccrualRuleId']").getCheckedValues();
    if (ids == "")
      showMessage(itl("@Common.NoElementWasSelected"));
    else {
      confirmDialog(null, function() {
        snpAPI.cmd("RewardPointAccrualRule", "Delete", {RewardPointAccrualRuleIDs: ids}).then(ansDO => triggerEntityChange(<%=LkSNEntityType.RewardPointAccrualRule.getCode()%>));
      });  
    }
  }
});

</script>