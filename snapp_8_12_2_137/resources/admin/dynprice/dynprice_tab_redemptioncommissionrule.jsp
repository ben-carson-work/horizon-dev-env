<%@page import="com.vgs.cl.JvArray"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_DynamicPricing" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%LookupItem entityType = LkSNEntityType.RedemptionCommissionRule;%>

<div class="tab-toolbar">
  <v:button id="search-btn" caption="@Common.Search" fa="search"/>
  <span class="divider"></span>
  <% String hrefNew = "javascript:asyncDialogEasy('dynprice/redemptioncommissionrule_dialog', 'id=new')";%>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
  <%String hrefMultiEdit = "showMultiEditDialog(" + entityType.getCode() + ", '#redemptioncommissionrule-grid', '[name=\\'RedemptionCommissionRuleId\\']')";%>
  <v:button caption="@Common.Edit" fa="pencil" onclick="<%=hrefMultiEdit%>" bindGrid="redemptioncommissionrule-grid" enabled="<%=rights.SettingsRedemptionCommissionRule.getBoolean()%>"/>
  <v:button caption="@Common.Delete" fa="trash" href="javascript:deleteRedemptionCommissionRules()"/>
  <v:pagebox gridId="redemptioncommissionrule-grid"/>
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <div class="v-filter-container">
      <v:widget>
        <v:widget-block>
          <v:itl key="@Product.MembershipPoint"/><br/>
          <snp:dyncombo field="MembershipPointId" entityType="<%=LkSNEntityType.RewardPoint%>"/>
        </v:widget-block>
      </v:widget>
       
      <v:widget caption="@Common.Status">
         <v:widget-block>
           <v:db-checkbox field="CommissionRuleStatus" caption="@Common.Active" value="<%=LkSNRedemptionCommissionRuleStatus.Enabled.getCode()%>"/><br/>
           <v:db-checkbox field="CommissionRuleStatus" caption="@Common.Inactive" value="<%=LkSNRedemptionCommissionRuleStatus.Disabled.getCode()%>"/><br/>          
        </v:widget-block>
      </v:widget>
      
      <v:widget caption="@RedemptionCommissionRule.Formula">
        <v:widget-block>
         <% 
         for (LookupItem formula : LkSN.CommissionRuleFormulaType.getItems()) { %>
            <v:db-checkbox field="CommissionRuleFormula" caption="<%=formula.getRawDescription()%>" value="<%=String.valueOf(formula.getCode())%>"/><br/>
         <% } %>
         </v:widget-block>
      </v:widget>
      
       <v:widget caption="@RedemptionCommissionRule.CalculationAmountType">
        <v:widget-block>
         <% 
         for (LookupItem amountType : LkSN.CalculationAmountType.getItems()) { %>
            <v:db-checkbox field="CalculationAmountType" caption="<%=amountType.getRawDescription()%>" value="<%=String.valueOf(amountType.getCode())%>"/><br/>
         <% } %>
         </v:widget-block>
      </v:widget>
              
     <v:widget caption="@Common.Restrictions">
       <v:widget-block>
         <v:itl key="@Account.Location"/><br/>
         <snp:dyncombo field="LocationId" entityType="<%=LkSNEntityType.Location%>"/>
         
         <div class="filter-divider"></div>
         
         <v:itl key="@Account.OpArea"/><br/>
         <snp:dyncombo field="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" parentComboId="LocationId"/>
          
         <div class="filter-divider"></div>
         
         <v:itl key="@AccessPoint.AccessPoint"/><br/>
         <snp:dyncombo field="AccessPointId" entityType="<%=LkSNEntityType.AccessPoint%>" parentComboId="OpAreaId"/>
          
         <div class="filter-divider"></div>
         
         <v:itl key="@Event.Event"/><br/>
           <% JvDataSet dsEvent = pageBase.getBL(BLBO_Event.class).getEventDS(); %>
           <v:multibox field="EventIDs" lookupDataSet="<%=dsEvent%>" idFieldName="EventId" captionFieldName="EventName" allowNull="true" />
         </v>         
       </v:widget-block>
       
       <v:widget-block>
         <v:itl key="@SaleChannel.SaleChannels"/><br/>
           <% JvDataSet dsSaleChannels = pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null); %>
           <v:multibox field="SaleChannelIDs" lookupDataSet="<%=dsSaleChannels%>" idFieldName="SaleChannelId" captionFieldName="SaleChannelName" allowNull="true" />
         </v> 
         <v:itl key="@Product.ProductTypes"/><br/>
           <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
           <v:multibox field="ProductTagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" allowNull="true" />
         </v>
       </v:widget-block>         
     </v:widget>       
    </div>
  </div>
  
  <div class="profile-cont-div">
    <v:last-error/>
    <%String params = "EntityType=" + entityType.getCode();%>
    <v:async-grid id="redemptioncommissionrule-grid" jsp="dynprice/redemptioncommissionrule_grid.jsp" params="<%=params%>"/>
  </div>
</div> 
<script>
$(document).ready(function() {
  $("#search-btn").click(search);

  function search() {
    try {
	    setGridUrlParam("#redemptioncommissionrule-grid", "MembershipPointId", $("#MembershipPointId").val() || "");
      setGridUrlParam("#redemptioncommissionrule-grid", "CommissionRuleStatus", $("[name='CommissionRuleStatus']").getCheckedValues());
      setGridUrlParam("#redemptioncommissionrule-grid", "CommissionRuleFormula", $("[name='CommissionRuleFormula']").getCheckedValues());
      setGridUrlParam("#redemptioncommissionrule-grid", "CalculationAmountType", $("[name='CalculationAmountType']").getCheckedValues());
  
      setGridUrlParam("#redemptioncommissionrule-grid", "LocationId", $("#LocationId").val() || "");
      setGridUrlParam("#redemptioncommissionrule-grid", "OpAreaId", $("#OpAreaId").val() || "");
      setGridUrlParam("#redemptioncommissionrule-grid", "AccessPointId", $("#AccessPointId").val() || "");
      
      setGridUrlParam("#redemptioncommissionrule-grid", "EventIDs", $("#EventIDs").val().join(","));
      setGridUrlParam("#redemptioncommissionrule-grid", "SaleChannelIDs", $("#SaleChannelIDs").val().join(","));
      setGridUrlParam("#redemptioncommissionrule-grid", "ProductTagIDs", $("#ProductTagIDs").val().join(","));
  
      changeGridPage("#redemptioncommissionrule-grid", "first");
    }
    catch (err) {
      showMessage(err);
    }
  }
});

function deleteRedemptionCommissionRules() {
  var ids = $("[name='RedemptionCommissionRuleId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "Delete",
        Delete: {
            RedemptionCommissionRuleIDs: ids
        }
      };
      
      showWaitGlass();
      vgsService("RedemptionCommissionRule", reqDO, false, function(ansDO) {
        hideWaitGlass();
        changeGridPage("#redemptioncommissionrule-grid", 1);
      });
    });
  }
} 
</script>