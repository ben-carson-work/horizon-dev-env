<%@page import="com.vgs.snapp.api.rewardpoint.API_RewardPointAccrualRule_Search"%>
<%@page import="com.vgs.snapp.api.rewardpoint.APIDef_RewardPointAccrualRule_Search"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page import="com.vgs.snapp.dataobject.DORewardPointAccrualRuleRef"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_RewardPointAccrualRule.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
String productId = pageBase.getNullParameter("ProductId");
String membershipPointId = pageBase.getNullParameter("MembershipPointId");
String rewardPonitAccrualRuleId = pageBase.getId();

APIDef_RewardPointAccrualRule_Search.DORequest reqDO = new APIDef_RewardPointAccrualRule_Search.DORequest();

//Paging
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

//Sort
reqDO.SearchRecap.addSortField(Sel.ProductId, true);
reqDO.SearchRecap.addSortField(Sel.MembershipPointId, true);

// Where
if (productId != null) 
  reqDO.LocateProduct.ProductId.setString(productId); 
if (membershipPointId != null) 
  reqDO.LocateRewardPoint.MembershipPointId.setString(membershipPointId); 

// Exec
APIDef_RewardPointAccrualRule_Search.DOResponse ansDO = new APIDef_RewardPointAccrualRule_Search.DOResponse();   
pageBase.getBL(API_RewardPointAccrualRule_Search.class).execute(reqDO, ansDO);
%>

<script>
//# sourceURL=rewardpoint_accrualrule_grid.jsp

$(document).ready(function() {
	$("#RewardPointAccrualRuleTable tr.grid-row td").click(function(event) { 
		if (event.target == this) {
			let $tr = $(this).closest("tr");
			<%
	    String params = "";
	   	if (productId != null)
	   	  params = "ProductId=" + productId;
	   	else if (membershipPointId != null)
	   	  params = "MembershipPointId=" + membershipPointId; 
			%>
		  asyncDialogEasy("product/rewardpoint/rewardpoint_accrualrule_dialog", "id=" + $tr.attr('data-recordid') + "&<%=params%>");
		}
	});
});
</script>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.RewardPointAccrualRule%>" id="RewardPointAccrualRuleTable">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
     	<td width="33%" nowrap="nowrap">
        <v:itl key="@Common.Membership"/>
      </td>
      <td width="33%">
        <v:itl key="@Product.MembershipPoint"/><br/>
        <v:itl key="@Currency.ExchangeRate"/>
      </td>
      <td width="33%">
        <v:itl key="@Common.ValidFrom"/><br/>
        <v:itl key="@Common.ValidTo"/>
      </td>
    </tr>
  </thead>
  <tbody>
  	<v:grid-row search="<%=ansDO%>" idFieldName="RewardPointAccrualRuleId" > 
	    <% DORewardPointAccrualRuleRef rule = ansDO.getRecord(); %>
      <% LookupItem rewardPointAccrualRuleStatus = LkSN.RewardPointAccrualRuleStatus.getItemByCode(rule.RewardPointAccrualRuleStatus.getInt()); %>
      <td style="<v:common-status-style status="<%=rule.CommonStatus%>"/>">
        <v:grid-checkbox name="RewardPointAccrualRuleId" fieldname="RewardPointAccrualRuleId" value="<%=rule.RewardPointAccrualRuleId.getString()%>"/>
      </td>
      <td><v:grid-icon name="<%=rule.IconName.getString()%>"/></td>
      <td>
      	<snp:entity-link entityId="<%=rule.ProductId.getString()%>" entityType="<%=LkSNEntityType.ProductType%>">
        	<%=pageBase.getBL(BLBO_PagePath.class).findEntityDesc(LkSNEntityType.ProductType, rule.ProductId.getString())%>
      	</snp:entity-link><br/>
      </td>
      <td>
      	<snp:entity-link entityId="<%=rule.MembershipPointId.getString()%>" entityType="<%=LkSNEntityType.RewardPoint%>">
        	<%=pageBase.getBL(BLBO_PagePath.class).findEntityDesc(LkSNEntityType.RewardPoint, rule.MembershipPointId.getString())%>
      	</snp:entity-link><br/>
        <span class="list-subtitle"><%=rule.ExchangeRate.getDisplayText()%></span>        
      </td>
      <td>
        <%=rule.ValidDateFrom.formatHtml(pageBase.getShortDateFormat())%><br/>
        <span class="list-subtitle"><%=rule.ValidDateTo.formatHtml(pageBase.getShortDateFormat())%></span>        
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    