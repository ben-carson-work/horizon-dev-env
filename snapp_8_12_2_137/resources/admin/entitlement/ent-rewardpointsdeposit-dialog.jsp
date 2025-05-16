<%@page import="com.vgs.web.library.BLBO_RewardPoint"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
//JvDataSet dsRewardPoints = pageBase.getBL(BLBO_RewardPoint.class).getRewardPointDS();
//  request.setAttribute("dsRewardPoints", dsRewardPoints);
%>

<div id="ent-rewardpointsdeposit-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.RewardPointsDeposit"/>">
  <v:widget>
    <v:widget-block id="block-rewardpoints-inherit-from-price">
      
	    <v:form-field caption="@Common.Type">
		    <v:combobox 
	                field="rewardpoints-initial-deposit-id"
	                lookupDataSet="<%=pageBase.getBL(BLBO_RewardPoint.class).getRewardPointDS()%>" 
	                idFieldName="MembershipPointId" 
	                captionFieldName="MembershipPointName"
	                enabledFieldName="Enabled"
	                linkEntityType="<%=LkSNEntityType.RewardPoint.getCode()%>" 
	                allowNull="false"/>
	    </v:form-field>

      <v:form-field>
        <v:db-checkbox field="rewardpoints-inherit-from-price" caption="@Entitlement.InheritFromSalePrice" hint="@Entitlement.InheritFromSalePriceHint" value="true"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block id="block-rewardpoints-deposit-amount">
      <v:form-field caption="@Common.Points">
	      <v:input-text field="rewardpoints-initial-deposit-amount"/>
	    </v:form-field>
	    <v:form-field caption="@Entitlement.FaceValue" hint="@Entitlement.FaceValueHint">
	      <v:input-text field="rewardpoints-initial-deposit-face-value" placeholder="@Common.Default"/>
	    </v:form-field>
    </v:widget-block>
  </v:widget>
</div>
