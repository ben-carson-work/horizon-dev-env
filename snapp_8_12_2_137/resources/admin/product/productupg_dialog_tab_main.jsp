<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType")); %>
<% boolean canEdit = !pageBase.getParameter("ReadOnly").equals("true");%>
<% boolean isProduct = entityType.isLookup(LkSNEntityType.ProductType); %>

<div class="tab-content">
  <v:widget caption="@Common.General">
    <v:widget-block id="details-Main" clazz="v-hidden">
      <v:db-checkbox field="upgradeFlags.Upgradable" caption="@Product.Upgradable" value="true" enabled="<%=canEdit%>"/><br/>
      <v:db-checkbox field="upgradeFlags.Downgradable" caption="@Product.Downgradable" value="true" enabled="<%=canEdit%>"/>
    </v:widget-block>
  </v:widget>
  
  
  <v:widget id="upgrade-options" caption="@Common.Options">
    <v:widget-block id="details-Inherit" clazz="v-hidden">
      <v:db-checkbox field="upgradeFlags.InheritFromCat" caption="@Product.InheritFromCat" value="true" enabled="<%=canEdit%>"/>
    </v:widget-block>

    <v:widget-block id="details-Other" clazz="v-hidden">
      <v:form-field caption="@Product.UsedProducts" hint="@Product.UsedProductsHint">
        <v:input-text field="upgradeFlags.FirstUsageUpgradeDays" placeholder="@Common.Unlimited" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Product.ExpirationUpgradeDays" hint="@Product.ExpirationUpgradeDaysHint">
        <v:input-text field="upgradeFlags.ExpirationUpgradeDays" placeholder="@Common.Unlimited" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Product.FromVisitUpgradeDays" hint="@Product.FromVisitUpgradeDaysHint">
        <v:input-text field="upgradeFlags.FromVisitUpgradeDays" placeholder="@Common.Unlimited" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Product.FromVisitUpgradePerfDays" hint="@Product.FromVisitUpgradePerfDaysHint">
        <v:input-text field="upgradeFlags.FromVisitUpgradePerfDays" placeholder="@Common.Unlimited" enabled="<%=canEdit%>" />
      </v:form-field>
    </v:widget-block>

    <v:widget-block>
      <v:form-field caption="@Product.ChangeVisitDateFee" hint="@Product.ChangeVisitDateFeeHint" multiCol="true">
        <v:multi-col caption="@Common.Fee">
          <snp:dyncombo field="product.ChangeVisitDateFeeProductId" entityType="<%=LkSNEntityType.ProductType%>" enabled="false"/>
        </v:multi-col>
        <v:multi-col caption="@Common.Days">
          <v:input-text field="product.ChangeVisitDateFeeDays" placeholder="@Common.Unlimited" enabled="false"/>
        </v:multi-col>
      </v:form-field>
    </v:widget-block>

    <v:widget-block id="details-Other" clazz="v-hidden">
      <div><v:db-checkbox field="upgradeFlags.PreventChangePerformance" caption="@Product.UpgradePreventChangePerformance" hint="@Product.UpgradePreventChangePerformanceHint" value="true" enabled="<%=canEdit%>"/></div>
      <div><v:db-checkbox field="upgradeFlags.LimitUpgradeMaxTimes" caption="@Product.LimitUpgradeMaxTimes" hint="@Product.LimitUpgradeMaxTimesHint" value="true" enabled="<%=canEdit%>"/></div>
      <div><v:db-checkbox field="upgradeFlags.AllowCrossLocationUpg" caption="@Product.AllowCrossLocationUpg" hint="@Product.AllowCrossLocationUpgHint" value="true" enabled="<%=canEdit%>"/></div>
    </v:widget-block>
  </v:widget>
</div>

<script>

function refreshDetailsAndTabs() {
  var upg = $("#upgradeFlags\\.Upgradable").isChecked();    
  var dwg = $("#upgradeFlags\\.Downgradable").isChecked();  
  var inh = $("#upgradeFlags\\.InheritFromCat").isChecked();              
  var acl = $("#upgradeFlags\\.AllowCrossLocationUpg").isChecked();       
  var isProduct = <%=isProduct%>;                   
  
  $("#upgrade-options").setClass("v-hidden", !isProduct || (!upg && !dwg));
  $("#details-Main").setClass("v-hidden", !isProduct);                             
  $("#details-Inherit").setClass("v-hidden", !isProduct || (!upg && !dwg));        
  $("#details-Other,#details-Other2").setClass("v-hidden", isProduct && ((!upg && !dwg) || inh));
  
  $("[data-tabcode='tabs-quickupg']").closest("li").setClass("v-hidden", isProduct && ((!upg && !dwg) || inh));
  $("[data-tabcode='tabs-crossloc']").closest("li").setClass("v-hidden", (isProduct && ((!upg && !dwg) || inh || !acl)) || !acl)
}

$("[name='upgradeFlags.Upgradable']").change(refreshDetailsAndTabs);
$("[name='upgradeFlags.Downgradable']").change(refreshDetailsAndTabs);
$("[name='upgradeFlags.InheritFromCat']").change(refreshDetailsAndTabs);
$("[name='upgradeFlags.AllowCrossLocationUpg']").change(refreshDetailsAndTabs);

function initMain() {
  refreshDetailsAndTabs();
}

</script>