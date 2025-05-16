<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePayMethod" scope="request"/>
<jsp:useBean id="pay" class="com.vgs.snapp.dataobject.DOPaymentMethod" scope="request"/>

<%
PluginSettingsBase plgSettings = pageBase.getBL(BLBO_Plugin.class).getPluginSettings(pay.DriverClassAlias.getString());
request.setAttribute("settings", plgSettings.getPluginConfigDataObject(pay.PluginSettings.getString()));
%>

<style>

.pay-option {
  padding: 4px;
  cursor: pointer;
  border-radius: 5px;
  border: 1px rgba(0,0,0,0) solid;
}

.pay-option.selected {
  background-color: var(--base-blue-color);
}

.pay-option:not(.selected):hover {
  background-color: var(--highlight-color);
}

</style>

<v:input-text field="pay.PluginId" type="hidden"/>
<v:input-text field="pay.CustomIconName" type="hidden"/>

<v:tab-toolbar>
  <v:button caption="@Common.Save" fa="save" href="javascript:doSavePaymentMethod()"/>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.PaymentMethod%>"/>
  <span class="divider"></span>
  <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=export&EntityIDs=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.PaymentMethod.getCode(); %> 
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
</v:tab-toolbar>

<v:tab-content>

  <v:profile-recap>
    <jsp:include page="../common/icon-alias-widget.jsp">
      <jsp:param name="iconAlias-Field" value="pay.IconAlias"/>
      <jsp:param name="iconAlias-ForegroundField" value="pay.ForegroundColor"/>
      <jsp:param name="iconAlias-BackgroundField" value="pay.BackgroundColor"/>
      <jsp:param name="iconAlias-CanEdit" value="true"/>
    </jsp:include>

    <v:widget caption="@Common.Icon">
      <v:widget-block>
        <% 
        String[] icons = new String[] {
            "pay_cash.png", "pay_creditcard.png", "pay_credit.png", "pay_consignment.png", "pay_foreigncurr.png", "pay_voucher.png", 
            "paymethod.png", "box.png", "coins.png", "coinsroll.png", "calendar.png", "lock.png", "moneybag.png", "bank.png", "moneypig.png", 
            "paypal.png", "card_visa.png", "card_mastercard.png", "card_maestro.png", "card_amex.png", "giftcard.png", "advpayment.png"
        }; 
        %>
    
        <% for (String icon : icons) { %>
          <% String sel = pay.CustomIconName.isSameString(icon) ? "selected" : ""; %>
          <img class="pay-option <%=sel%>" data-IconName="<%=icon%>" src="<v:image-link name="<%=icon%>" size="48"/>"/>
        <% } %>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  <v:profile-main>
    <v:widget caption="@Common.General">
      <v:widget-block>
        <v:form-field caption="@Common.Type">
          <input type="text" class='form-control' readonly="readonly" value="<%=pay.DriverType.getHtmlString()%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Name">
          <v:input-text field="pay.PluginName" placeholder="<%=pay.DriverName.getHtmlString()%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Code">
          <v:input-text field="pay.PaymentMethodCode"/>
        </v:form-field>
        <v:form-field caption="@Common.Alias" hint="@Payment.DeviceAliasHint">
          <v:input-text field="pay.DeviceAlias"/>
        </v:form-field>
        <v:form-field caption="@Common.PriorityOrder">
          <v:input-text field="pay.PriorityOrder"/>
        </v:form-field>
        <v:form-field caption="@Payment.PaymentMethodMasks">
          <% JvDataSet dsMasks = pageBase.getBL(BLBO_Mask.class).getMaskDS(LkSNEntityType.Finance); %>
          <v:multibox field="pay.MaskIDs" lookupDataSet="<%=dsMasks%>" idFieldName="MaskId" captionFieldName="MaskName" linkEntityType="<%=LkSNEntityType.Mask%>"/>
        </v:form-field>
        
        <% if (pay.DriverType.isLookup(LkSNDriverType.Intercompany)) { %>
          <v:form-field caption="@Payment.IntercompanyCostCenter" >
            <% JvDataSet dsCostCenters = pageBase.getBL(BLBO_IntercompanyCostCenter.class).getIntercompanyCostCenterDS(); %>
            <v:multibox field="pay.IntercompanyCostCenterIDs" lookupDataSet="<%=dsCostCenters%>" idFieldName="IntercompanyCostCenterId" captionFieldName="IntercompanyCostCenterName" linkEntityType="<%=LkSNEntityType.IntercompanyCostCenter%>"/>
          </v:form-field>
        <% } else if (pay.DriverType.isLookup(LkSNDriverType.Credit)) { %>
          <v:form-field caption="@Payment.TargetPaymentMethod" hint="@Payment.TargetPaymentMethodHint" >
            <snp:dyncombo field="pay.TargetPaymentMethodId" entityType="<%=LkSNEntityType.PaymentMethod%>" filtersJSON="{\"PaymentMethod\":{\"DriverTypes\":\"1019\"}}"/>
          </v:form-field>
        <% } %>
        
      </v:widget-block>
      <v:widget-block>
        <div><v:db-checkbox field="pay.PluginEnabled" caption="@Common.Enabled" value="true"/></div>
        <div><v:db-checkbox field="pay.PluginDefault" caption="@Common.Default" value="true"/></div>
      </v:widget-block>
    </v:widget>
  
    <v:widget caption="@Common.Options">
      <v:widget-block>
        <v:form-field caption="@Plugin.MaxChangeAmount">
          <v:input-text field="pay.MaxChangeAmount" placeholder="@Common.Unlimited"/>
        </v:form-field>
        <v:form-field caption="@Plugin.PaymentGroup">
          <snp:tag-combobtn field="pay.PaymentGroupTagId" entityType="<%=LkSNEntityType.PaymentGroup%>"/>
        </v:form-field>
        <v:form-field caption="@Payment.FeeProducts" hint="@Payment.FeeProductsHint">
          <v:multibox field="pay.FeeProductIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Product.class).getFeeLookupDS(pay.FeeProductIDs.getArray())%>" idFieldName="ProductId" codeFieldName="ProductCode" captionFieldName="ProductName" linkEntityType="<%=LkSNEntityType.ProductType%>"/>
        </v:form-field>
        <v:form-field caption="@Payment.PaymentMethodOnlineStatus" hint="@Payment.PaymentMethodOnlineStatusHint">
          <v:lk-radio field="pay.OnlineStatus" lookup="<%=LkSN.PaymentMethodOnlineStatus%>" allowNull="true" inline="true"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <div><v:db-checkbox field="pay.AutoFill" caption="@Payment.AutoFill" value="true"/></div>
        <div><v:db-checkbox field="pay.EnabledOnSale" caption="@Payment.EnabledOnSale" hint="@Payment.EnabledOnSale_Hint" value="true"/></div>
        <div><v:db-checkbox field="pay.Refundable" caption="@Payment.EnabledOnRefund" hint="@Payment.EnabledOnRefund_Hint" value="true"/></div>
        <div><v:db-checkbox field="pay.StraightSale" caption="@Payment.StraightSale" hint="@Payment.StraightSaleHint" value="true"/></div>
        <div><v:db-checkbox field="pay.OpenCashDrawer" caption="@Payment.OpenCashDrawer" hint="@Payment.OpenCashDrawerHint" value="true"/></div>
        <div><v:db-checkbox field="pay.PaymentAbort" caption="@Payment.PaymentAbort" hint="@Payment.PaymentAbortHint" value="true"/></div>
        <% if (pay.DriverType.isLookup(LkSNDriverType.Cash)) { %>
          <div><v:db-checkbox field="pay.CashPayment" caption="@Payment.Cash" hint="@Payment.CashPaymentHint" value="true"/></div>
        <% } %>
      </v:widget-block>
    </v:widget>
    
    <v:widget caption="@Ledger.LedgerRule">
      <v:widget-block>
        <v:form-field caption="@Ledger.RuleSource">
          <snp:dyncombo field="pay.DebitLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" allowNull="true" showItemCode="true"/>
        </v:form-field>
        <v:form-field caption="@Ledger.RuleTarget">
          <snp:dyncombo field="pay.CreditLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" allowNull="true" showItemCode="true"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    
    <% if (plgSettings.getPluginConfigPageName() != null) { %>
      <jsp:include page="<%=plgSettings.getPluginConfigPageName()%>"/>
    <%} %>
    
    <v:widget caption="@Common.Other">
      <v:widget-block>
        <v:form-field caption="@Payment.PaymentCountMessage">
          <v:input-text field="pay.PaymentCountMessage"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
  </v:profile-main>

</v:tab-content>

<script>
$(".pay-option").click(function() {
  $(".pay-option").removeClass("selected");
  $(this).addClass("selected");
  $("#pay\\.CustomIconName").val($(this).attr("data-IconName"));
});

function doSavePaymentMethod() {
  var maxChangeAmount = parseFloat($("#pay\\.MaxChangeAmount").val());
  var reqDO = {
    Command: "SavePaymentMethod",
    SavePaymentMethod: {
      PaymentMethod: {
        PluginId: <%=pay.PluginId.getSqlString()%>,
        DriverClassAlias: <%=pay.DriverClassAlias.getSqlString()%>,
        PluginName: $("#pay\\.PluginName").val(),
        PluginEnabled: $("#pay\\.PluginEnabled").isChecked(),
        PriorityOrder: $("#pay\\.PriorityOrder").val(),
        PluginDefault: $("#pay\\.PluginDefault").isChecked(),
        PaymentGroupTagId: $("[name='pay\\.PaymentGroupTagId']").val(),
        AutoFill: $("#pay\\.AutoFill").isChecked(),
        EnabledOnSale: $("#pay\\.EnabledOnSale").isChecked(),
        Refundable: $("#pay\\.Refundable").isChecked(),
        CashPayment: $("#pay\\.CashPayment").isChecked(),
        PaymentMethodCode: $("#pay\\.PaymentMethodCode").val(),
        PaymentCountMessage: ($("#pay\\.PaymentCountMessage").val() == '') ? null : $("#pay\\.PaymentCountMessage").val(),
        CustomIconName: ($("#pay\\.CustomIconName").val() == '') ? null : $("#pay\\.CustomIconName").val(),
        IconAlias: getNull($("#pay\\.IconAlias").attr("data-alias")),
        BackgroundColor: getNull($("[name='pay\\.BackgroundColor']").val()),
        ForegroundColor: getNull($("[name='pay\\.ForegroundColor']").val()),
        DebitLedgerAccountId: $("#pay\\.DebitLedgerAccountId").val(),
        CreditLedgerAccountId: $("#pay\\.CreditLedgerAccountId").val(),
        MaskIDs: $("#pay\\.MaskIDs").val(),
        IntercompanyCostCenterIDs: $("#pay\\.IntercompanyCostCenterIDs").val(),
        FeeProductIDs: $("#pay\\.FeeProductIDs").val(),
        TargetPaymentMethodId: $("#pay\\.TargetPaymentMethodId").val(),
        MaxChangeAmount: isNaN(maxChangeAmount) ? null : maxChangeAmount, 
        PluginSettings: functionExists("getPluginSettings") ? JSON.stringify(getPluginSettings()) : null,
        StraightSale: $("#pay\\.StraightSale").isChecked(),
        OpenCashDrawer: $("#pay\\.OpenCashDrawer").isChecked(),
        OnlineStatus: $("#pay\\.OnlineStatus").val(),
        DeviceAlias: $("#pay\\.DeviceAlias").val(),
        PaymentAbort: $("#pay\\.PaymentAbort").isChecked()
      }
    }
  };
  
  showWaitGlass();
  vgsService("PayMethod", reqDO, false, function(ansDO) {
    hideWaitGlass();
    entitySaveNotification(<%=LkSNEntityType.PaymentMethod.getCode()%>, ansDO.Answer.SavePaymentMethod.PluginId);
  });
}

</script>