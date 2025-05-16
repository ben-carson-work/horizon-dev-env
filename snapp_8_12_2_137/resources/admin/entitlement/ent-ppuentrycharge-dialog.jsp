<%@page import="com.vgs.web.library.BLBO_RewardPoint"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
  JvDataSet dsRewardPoints = pageBase.getBL(BLBO_RewardPoint.class).getRewardPointDS(true);
  request.setAttribute("dsRewardPoints", dsRewardPoints);
%>

<div id="ent-ppuentrycharge-dialog" class="ent-dialog" title="<v:itl key="@Entitlement.PayPerUseEntryCharge"/>">
  <v:widget>
    <v:widget-block>
      <label class="checkbox-label"><input type="radio" id="ppu-entry-charge-radio" name="ppu-entry-charge-radio" value="1"/> <v:itl key="@Product.PPURules"/> <v:hint-handle hint="@Entitlement.PPUChargeRuleHint"/></label>
      &nbsp;&nbsp;&nbsp;           
      <label class="checkbox-label"><input type="radio" id="ppu-entry-charge-radio" name="ppu-entry-charge-radio" value="2"/> <v:itl key="@Common.Amount"/> <v:hint-handle hint="@Entitlement.PPUChargeAmountHint"/></label>           
    </v:widget-block>
    <v:widget-block id="ppu-entry-charge-amount">
      <v:form-field caption="@Common.Name">
        <select name="field-value" class="form-control" id="ppu-entry-rewardpoints-id" data-entitytype="<%=LkSNEntityType.RewardPoint.getCode()%>">
          <v:ds-loop dataset="<%=dsRewardPoints%>">
            <option value='<%=dsRewardPoints.getField("MembershipPointId").getHtmlString()%>'><%=dsRewardPoints.getField("MembershipPointName").getHtmlString()%></option>
          </v:ds-loop>
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Amount" >
        <v:input-text type="text" field="ppu-entry-charge-edit"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>
