<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageRewardPoint" scope="request"/>
<jsp:useBean id="rewardPoint" class="com.vgs.snapp.dataobject.DORewardPoint" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
boolean canEdit = !rewardPoint.SystemCode.getBoolean(); 
String sReadOnly = canEdit ? "" : " readonly=\"readonly\"";
%>

<v:page-form id="rewardpoint-form">
<v:input-text type="hidden" field="rewardPoint.MembershipPointId"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" onclick="doSaveRewardPoint()"/>
</div>

<div class="tab-content">
<v:last-error/>
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="rewardPoint.MembershipPointCode" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="rewardPoint.MembershipPointName" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Common.ValidFrom">
          <v:input-text type="datepicker" field="rewardPoint.ValidDateFrom" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
          <v:itl key="@Common.To" transform="lowercase"/>
          <v:input-text type="datepicker" field="rewardPoint.ValidDateTo" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@MembershipPoint.ValidityType">
        <v:lk-combobox field="rewardPoint.ValidityType" lookup="<%=LkSN.MemPointValidityType%>" allowNull="true" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@MembershipPoint.ExpirationType">
        <v:lk-combobox field="rewardPoint.ExpirationType" lookup="<%=LkSN.MemPointExpirationType%>" allowNull="false" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field id="ExpirationDays-field" caption="@MembershipPoint.Expiration" hint="@MembershipPoint.ExpirationHint">
        <v:input-text field="rewardPoint.ExpirationDays" enabled="<%=canEdit%>" />
      </v:form-field><br/>
      <v:form-field caption="@Product.GateCategory" hint='@MembershipPoint.RewardPointGateCategoryHint'>
        <snp:dyncombo field="rewardPoint.GateCategoryId" entityType="<%=LkSNEntityType.GateCategory%>"/>
      </v:form-field>
      <v:db-checkbox caption="@MembershipPoint.AllowTopup" value="true" field="rewardPoint.AllowTopup" hint="@MembershipPoint.AllowTopupHint" enabled="<%=canEdit%>"/><br/>
      <v:db-checkbox caption="@MembershipPoint.ExpirationManualChange" value="true" field="rewardPoint.ExpirationManualChange" hint="@MembershipPoint.ExpirationManualChangeHint"/>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox caption="@Common.Active" value="true" field="rewardPoint.Active" enabled="<%=canEdit%>"/>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="@AccessPoint.Redemption" hint="@MembershipPoint.ExchangeRateHint" id="payment-widget">
    <jsp:include page="rewardpoint_tab_main_exchangerate_widget.jsp"><jsp:param value="<%=canEdit%>" name="Editable"/></jsp:include>
  </v:widget>
  
  <v:widget caption="@Common.Rounding" id="rounding-widget">
    <v:widget-block>
      <v:form-field caption="@Currency.Decimals" mandatory="true">
        <v:input-text field="rewardPoint.RoundDecimals" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Currency.RoundingType">
        <v:lk-combobox field="rewardPoint.RoundingType" lookup="<%=LkSN.RoundingType%>" allowNull="false" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Currency.SmallestDenomination" mandatory="true">
        <v:input-text field="rewardPoint.SmallestDenomination" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Currency.AlgebraicThreshold" mandatory="true">
        <v:input-text field="rewardPoint.AlgebraicThreshold" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>
</v:page-form>

<script>

$(document).ready(function() {
	$("#rewardPoint\\.ExpirationType").change(expirationTypeRefreshVisibility);
	expirationTypeRefreshVisibility();
});
  
function doSaveRewardPoint() {
  checkRequired("#rewardpoint-form", function() {
    var reqDO = {
     Command: "SaveMembershipPoint",
     SaveMembershipPoint: {
       MembershipPoint: {
         MembershipPointId: <%=pageBase.isNewItem() ? null : "\"" + rewardPoint.MembershipPointId.getHtmlString() + "\""%>,
         MembershipPointCode: $("#rewardPoint\\.MembershipPointCode").val(),
         MembershipPointName: $("#rewardPoint\\.MembershipPointName").val(),
         ValidDateFrom:$("#rewardPoint\\.ValidDateFrom-picker").getXMLDateTime(),
         ValidDateTo:$("#rewardPoint\\.ValidDateTo-picker").getXMLDateTime(),
         ExchangeRate: $("#rewardPoint\\.ExchangeRate").val(),
         RoundDecimals:$("#rewardPoint\\.RoundDecimals").val(),
         SmallestDenomination:$("#rewardPoint\\.SmallestDenomination").val(),
         RoundingType:$("#rewardPoint\\.RoundingType").val(),
         AlgebraicThreshold:$("#rewardPoint\\.AlgebraicThreshold").val(),
         Active: $("#rewardPoint\\.Active").isChecked(),
         ValidityType: $("#rewardPoint\\.ValidityType").val(),
         ExpirationType: $("#rewardPoint\\.ExpirationType").val(),
         ExpirationDays: $("#rewardPoint\\.ExpirationDays").val(),
         GateCategoryId: $("#rewardPoint\\.GateCategoryId").val(),
         AllowTopup: $("#rewardPoint\\.AllowTopup").isChecked(),
         ExpirationManualChange: $("#rewardPoint\\.ExpirationManualChange").isChecked()
       }
     }
   };
    
   $(document).trigger("rewardpoint-save", {MembershipPoint: reqDO.SaveMembershipPoint.MembershipPoint}); 
    
   showWaitGlass();
   vgsService("Product", reqDO, false, function(ansDO) {
     hideWaitGlass();
     entitySaveNotification(<%=LkSNEntityType.RewardPoint.getCode()%>, ansDO.Answer.SaveMembershipPoint.MembershipPointId);
   });
  });
}

function expirationTypeRefreshVisibility() {
  if ($("#rewardPoint\\.ExpirationType").val() == <%=LkSNMemPointExpirationType.Never.getCode()%>) {
    setVisible("#ExpirationDays-field", false);
    $("#rewardPoint\\.ExpirationDays").val(null);
  }
  else    
    setVisible("#ExpirationDays-field", true);
}

</script>