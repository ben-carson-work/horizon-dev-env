<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageRewardPointList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canEdit = rights.GenericSetup.getBoolean(); %>


	<div class="tab-toolbar">
	  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
	  <span class="divider"></span>
		<v:button caption="@Common.New" fa="plus" href="admin?page=membershippoint&id=new" enabled="<%=canEdit%>"/>
		<v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:doDeleteRewardPoint()" enabled="<%=canEdit%>"/>
    <span class="divider"></span>
    <%
    String hRef="javascript:showHistoryLog(" + LkSNEntityType.RewardPoint.getCode() + ")";
    %>
    <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
		<v:pagebox gridId="rewardpoint-grid"/>
	</div>
	
	<div class="tab-content">
	  <div class="profile-pic-div">
	    <v:widget caption="@Common.Search">
	       <v:widget-block>
	         <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
	       </v:widget-block>
	     </v:widget>
	  </div>
		 <div class="profile-cont-div">
	     <v:async-grid id="rewardpoint-grid" jsp="product/rewardpoint/rewardpoint_grid.jsp" />
	   </div>
	</div>

<script>

function search() {
  setGridUrlParam("#rewardpoint-grid", "FullText", $("#full-text-search").val(), true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
    event.preventDefault(); 
  }
}

$("#full-text-search").keypress(function(e) {
  if (e.keyCode == KEY_ENTER) {
    search();
    return false;
  }
});

function doDeleteRewardPoint() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteMembershipPoint",
      DeleteMembershipPoint: {
    	  MembershipPointIDs: $("[name='MembershipPointId']").getCheckedValues()
      }
    };
    
    vgsService("Product", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.RewardPoint.getCode()%>);
    });
  });
}

</script>
