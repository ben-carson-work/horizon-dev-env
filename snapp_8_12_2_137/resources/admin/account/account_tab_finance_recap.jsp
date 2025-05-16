<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageAccount"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<jsp:useBean id="accountFinance" scope="request" class="com.vgs.snapp.dataobject.DOAccountFinance"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>

<% 
boolean xpiAccount = account.EntityType.isLookup(LkSNEntityType.CrossPlatform);
boolean canEdit = rights.CreditLine.canUpdate() || rights.SalesTerms.canUpdate();
boolean canReadSales = rights.SalesTerms.canRead();
boolean canEditSales = rights.SalesTerms.canUpdate();
boolean canReadFinance = rights.CreditLine.canRead();
boolean canEditFinance = rights.CreditLine.canUpdate();
boolean canDeleteFinance = rights.CreditLine.canDelete() && !xpiAccount;
List <DOAccountFinance.DOAccountUserLimit> userLimitList = pageBase.getBL(BLBO_Account.class).getAccountUserLimitList(pageBase.getId()).getItems();
String[] webPaymentIDs = pageBase.getBL(BLBO_PayMethod.class).getWebPaymentPaymentMethodIDs(); 
%>

<v:page-form page="account" id="account-form" trackChanges="true"> 
<v:input-text field="account.AccountId" type="hidden" />

<v:tab-toolbar>
  <v:button caption="@Common.Save" fa="save" onclick="saveFinance()" enabled="<%=canEdit%>" bindSave="true"/>
  <v:button caption="@Common.Remove" fa="trash" onclick="disableFinance()" enabled="<%=canDeleteFinance%>" include="<%=account.HasFinance.getBoolean()%>"/>
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
    <v:widget caption="@Account.Credit.OverallActivity" include="<%=canReadFinance%>">
      <v:widget-block style="color:var(--base-red-color);font-weight:bold" include="<%=accountFinance.OutstandingDebt.getBoolean() || (accountFinance.TotalOutstanding.getMoney() > 0)%>">
        <v:recap-item caption="@Common.Outstanding"><v:label field="<%=accountFinance.TotalOutstanding%>"/></v:recap-item> 
      </v:widget-block>
  
      <v:widget-block>
        <v:recap-item caption="@Account.Credit.TotalCredit"><v:label field="<%=accountFinance.TotalCredit%>"/></v:recap-item> 
      </v:widget-block>
  
      <v:widget-block>
        <v:recap-item caption="@Account.Credit.Unsettled" valueColor="<%=(accountFinance.TotalOpen.getMoney() > 0) ? \"red\" : null%>"><v:label field="<%=accountFinance.TotalOpen%>"/></v:recap-item>
        <v:recap-item caption="@Account.Credit.DepositBalance"><v:label field="<%=accountFinance.AdvDeposit%>"/></v:recap-item>
        <v:recap-item caption="@Account.Credit.OpenOrders" valueColor="<%=(accountFinance.OpenOrderBalance.getMoney() > 0) ? \"red\" : null%>">
          <v:hint-handle hint="@Account.Credit.OpenOrderNotUsedHint" include="<%=!accountFinance.OpenOrderAffectCredit.getBoolean()%>" />
          <v:label field="<%=accountFinance.OpenOrderBalance%>"/>
        </v:recap-item>
        <v:recap-item caption="@Account.Credit.TotalAvailable" valueColor="<%=accountFinance.TotalAvailable.getMoney()<0 ? \"red\" : null%>"><v:label field="<%=accountFinance.TotalAvailable%>"/></v:recap-item>
      </v:widget-block>
      
      <v:widget-block>
        <v:recap-item caption="@Account.Credit.TotalActivity"><v:label field="<%=accountFinance.TotalActivity%>"/></v:recap-item>
        <v:recap-item caption="@Account.Credit.TotalPaid"><v:label field="<%=accountFinance.TotalPaid%>"/></v:recap-item>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  <v:profile-main>
    <v:widget caption="@Account.Credit.SalesTitle" include="<%=canReadSales%>">
      <v:widget-block>
        <v:form-field caption="@SaleChannel.SaleChannel" hint="@Account.OrgSaleChannelHint">
          <v:combobox 
              field="accountFinance.SaleChannelId" 
              lookupDataSet="<%=pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS(LkSNSaleChannelType.External)%>" 
              idFieldName="SaleChannelId" 
              captionFieldName="SaleChannelName"
              linkEntityType="<%=LkSNEntityType.SaleChannel%>"
              enabled="<%=canEditSales%>" 
          />
        </v:form-field>
        <v:form-field caption="@Commission.CommissionRule">
          <v:combobox 
              field="accountFinance.CommissionId" 
              lookupDataSet="<%=pageBase.getBL(BLBO_CommissionRule.class).getCommissionRuleLookupDS()%>" 
              idFieldName="CommissionId" 
              captionFieldName="CommissionName" 
              linkEntityType="<%=LkSNEntityType.CommissionRule%>"
              enabled="<%=canEditSales%>" 
          />
        </v:form-field>
        <v:form-field caption="@Account.Agent" id="agent-account-id-field">
          <snp:dyncombo field="accountFinance.AgentAccountId" entityType="<%=LkSNEntityType.Person%>" enabled="<%=canEditSales%>"/>
        </v:form-field>
        <v:form-field caption="@Account.B2B_Workstation" id="B2B-workstation-field">
          <v:combobox 
              field="accountFinance.B2BWorkstationId" 
              lookupDataSet="<%=pageBase.getBLDef().getB2BWorkstationDS()%>" 
              idFieldName="WorkstationId" 
              captionFieldName="WorkstationName"
              linkEntityType="<%=LkSNEntityType.Workstation%>"
              enabled="<%=canEditSales%>" 
          />
        </v:form-field>
        <v:form-field caption="@Product.Catalogs">
          <v:multibox 
                field="accountFinance.MainCatalogIDs" 
                lookupDataSet="<%=pageBase.getBL(BLBO_Catalog.class).getCatalogDS()%>" 
                idFieldName="CatalogId" 
                captionFieldName="CatalogName" 
                linkEntityType="<%=LkSNEntityType.Catalog%>" 
                enabled="<%=canEditSales%>"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <v:form-field caption="@Account.CommissionAccrual">
          <div id="accountFinance.CommissionOnRedemption">
            <label><input type="radio" name="commission-acrual" id="commission-on-sale-radio" value="false" checked>&nbsp;<v:itl key="@Account.CommissionOnSale"/></label>
            &nbsp;
            <label><input type="radio" name="commission-acrual" id="commission-on-redemption-radio" value="true">&nbsp;<v:itl key="@Account.CommissionOnRedemption"/></label>
          </div>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <v:db-checkbox caption="@Account.Credit.ResPurgeLock" field="accountFinance.ResPurgeLock" value="true" enabled="<%=canEditSales%>" />
        <br/>
        <v:db-checkbox caption="@Account.AllowInventory" field="accountFinance.AllowInventory" value="true" enabled="<%=canEditSales%>" />
        <br/>
        <v:db-checkbox caption="@Account.CreditCommissionToDeposit" hint="@Account.CreditCommissionToDepositHint" field="accountFinance.CreditCommissionToDeposit" value="true" enabled="<%=canEditSales%>" />        
        <br/>
        <v:db-checkbox caption="@Account.Credit.B2BPreventTicketEncoding" hint="@Account.Credit.B2BPreventTicketEncodingHint" field="accountFinance.B2BPreventTicketEncoding" value="true" enabled="<%=canEditSales%>" />        
        <br/>
        <div id="user-limit-list" class="hidden">
          <v:db-checkbox caption="@Account.Credit.RestrictB2BUsers" field="cbRestrictB2BUsers" value="true" enabled="<%=canEditSales%>" checked="<%=!userLimitList.isEmpty()%>" />
          <div id="user-limit-body">
            <% JvDataSet dsRole = pageBase.getBL(BLBO_Role.class).getRolesDS(LkSNRoleType.B2BAgent); %>
            <v:grid style="margin-top:5px">
              <v:grid-row dataset="<%=dsRole%>">
                <% 
                String roleId = dsRole.getField(QryBO_Role.Sel.RoleId).getString();
                Integer qty = null;
                for (DOAccountFinance.DOAccountUserLimit userLimit : userLimitList) {
                  if (JvString.isSameString(userLimit.RoleId.getString(), dsRole.getField(QryBO_Role.Sel.RoleId).getString()))
                    qty = userLimit.Quantity.getInt();
                }
                int actUsers = (pageBase.getBL(BLBO_Account.class).getB2BUserQty(pageBase.getId(), roleId));
                %>
                <td><v:grid-icon name="<%=dsRole.getField(QryBO_Role.Sel.IconName).getString()%>"/></td>
                <td width="40%">
                  <%=dsRole.getField(QryBO_Role.Sel.RoleName).getHtmlString()%><br/>
                  <span class="list-subtitle"><%=dsRole.getField(QryBO_Role.Sel.RoleCode).getHtmlString()%></span>
                </td>
                <td width="30%">
                  <% String key = (actUsers == 1) ? "@Account.Credit.AssignedUser" : "@Account.Credit.AssignedUsers"; %>
                  <span class="list-subtitle"><%=actUsers%> <v:itl key="<%=key%>"/></span>
                </td>
                <td width="30%">
                  <input type="text" id="<%=roleId%>" class="userLimitQty form-control" placeholder="<v:itl key="@Common.Unlimited"/>" value="<%=(qty != null) ? qty : ""%>" <%=canEditSales ? "" : "readonly='readonly' disabled='disabled'"%>/>
                </td>
              </v:grid-row>
            </v:grid>
          </div>
        </div>
        <v:db-checkbox caption="@Account.Credit.AllowPayByToken" hint="@Account.Credit.AllowPayByTokenHint" field="accountFinance.AllowPayByToken" value="true" enabled="<%=canEditSales%>" />
      </v:widget-block>
      
      <v:widget-block>
        <v:db-checkbox caption="@Account.Credit.AutopayOpenRes" hint="@Account.Credit.AutopayOpenResHint" field="cbAutopayOpenRes" value="true" enabled="<%=canEditSales%>" checked="<%=!accountFinance.AutoPaymentMethodId.isNull()%>" />
        <div id="autopay-openres-body">
          <v:form-field caption="@Account.Credit.DaysBeforeVisit" hint="@Account.Credit.DaysBeforeVisitHint" mandatory="true">
            <v:input-text field="accountFinance.AutoDaysBeforeVisit" enabled="<%=canEditFinance%>"/>
          </v:form-field>
          <v:form-field caption="@Payment.PaymentMethod">
            <v:combobox 
                field="accountFinance.AutoPaymentMethodId" 
                lookupDataSet="<%=pageBase.getBL(BLBO_PayMethod.class).getPaymentMethodByDriverTypeDS(LkSNDriverType.Credit.getCode(), LkSNDriverType.WebPayment.getCode())%>" 
                idFieldName="PluginId" 
                captionFieldName="PluginDisplayName"
                linkEntityType="<%=LkSNEntityType.PaymentMethod%>"
                enabled="<%=canEditSales%>" 
                allowNull="false"
            />
          </v:form-field>
          <div id="autopay-tokenid-body">
            <v:form-field caption="@Account.Credit.PaymentToken" hint="@Account.Credit.PaymentTokenHint">
              <v:combobox 
                  field="accountFinance.AutoPaymentTokenId" 
                  lookupDataSet="<%=pageBase.getBL(BLBO_PaymentToken.class).getPaymentTokenByAccountDS(account.AccountId.getString(), LkSNPaymentTokenType.PayByToken)%>" 
                  idFieldName="PaymentTokenId" 
                  captionFieldName="CommonDesc"
                  linkEntityType="<%=LkSNEntityType.PaymentToken%>"
                  enabled="<%=canEditSales%>"
                  allowNull="false" 
              />
            </v:form-field>
          </div>
          <div id="autopay-altpayment-body">
            <v:form-field caption="@Account.Credit.AlternativePaymentMethod" hint="@Account.Credit.AlternativePaymentMethodHint">
              <v:combobox 
                  field="accountFinance.AutoAltPaymentMethodId" 
                  lookupDataSet="<%=pageBase.getBL(BLBO_PayMethod.class).getPaymentMethodByDriverTypeDS(LkSNDriverType.Credit.getCode(), LkSNDriverType.WebPayment.getCode())%>" 
                  idFieldName="PluginId" 
                  captionFieldName="PluginDisplayName"
                  linkEntityType="<%=LkSNEntityType.PaymentMethod%>"
                  enabled="<%=canEditSales%>" 
              />
            </v:form-field>
          </div>
          <div id="autopay-alttokenid-body">
            <v:form-field caption="@Account.Credit.AltPaymentToken" hint="@Account.Credit.PaymentTokenHint">
              <v:combobox 
                  field="accountFinance.AutoAltPaymentTokenId" 
                  lookupDataSet="<%=pageBase.getBL(BLBO_PaymentToken.class).getPaymentTokenByAccountDS(account.AccountId.getString(), LkSNPaymentTokenType.PayByToken)%>" 
                  idFieldName="PaymentTokenId" 
                  captionFieldName="CommonDesc"
                  linkEntityType="<%=LkSNEntityType.PaymentToken%>"
                  enabled="<%=canEditSales%>"
                  allowNull="false" 
              />
            </v:form-field>
          </div>
        </div>
      </v:widget-block>
      
      <v:widget-block>
        <v:db-checkbox caption="@Account.Credit.ChannelManager" hint="@Account.Credit.ChannelManagerHint" field="cbChannelManager" value="true" enabled="<%=canEditSales%>" checked="<%=!accountFinance.ChannelManagerPluginId.isNull()%>" />
        <div id="channelmanager-body">
          <v:form-field caption="@Plugin.Plugin" hint="@Account.Credit.ChannelManagerPluginHint">
            <snp:dyncombo
                field="accountFinance.ChannelManagerPluginId" 
                entityType="<%=LkSNEntityType.Plugin_ChannelManager%>"
                enabled="<%=canEditSales%>"
            />
          </v:form-field>
          <v:form-field caption="@Common.Workstation" hint="@Account.Credit.ChannelManagerWorkstationHint">
            <% 
            DOFullTextLookupFilters chmWksFilters = new DOFullTextLookupFilters();
            chmWksFilters.Workstation.WorkstationTypes.setLkArray(LkSNWorkstationType.CHM);
            %>
            <snp:dyncombo
                field="accountFinance.ChannelManagerWorkstationId"
                entityType="<%=LkSNEntityType.Workstation%>"
                auditLocationFilter="true"
                filters="<%=chmWksFilters%>"
                enabled="<%=canEditSales%>"
            />
          </v:form-field>
          <v:form-field caption="@Common.CodeAliasType" hint="@Account.Credit.ChannelManagerCodeAliasTypeHint">
            <v:combobox 
                field="accountFinance.ChannelManagerCodeAliasTypeId" 
                lookupDataSet="<%=pageBase.getBL(BLBO_CodeAlias.class).getCodeAliasTypeDS()%>" 
                idFieldName="CodeAliasTypeId" 
                captionFieldName="CodeAliasTypeName"
                linkEntityType="<%=LkSNEntityType.CodeAliasType%>"
                enabled="<%=canEditSales%>" 
            />
          </v:form-field>
          <v:form-field caption="@Account.Credit.ChannelManagerReseller" hint="@Account.Credit.ChannelManagerResellerHint">
            <snp:dyncombo
                field="accountFinance.ChannelManagerResellerCode" 
                entityType="<%=LkSNEntityType.Reseller%>"
                parentComboId="accountFinance.ChannelManagerPluginId"
                enabled="<%=canEditSales%>"
            />
          </v:form-field>
          <v:form-field caption="@Product.Catalogs">
            <v:multibox 
                  field="accountFinance.ChannelManagerCatalogIDs" 
                  lookupDataSet="<%=pageBase.getBL(BLBO_Catalog.class).getCatalogDS()%>" 
                  idFieldName="CatalogId" 
                  captionFieldName="CatalogName" 
                  linkEntityType="<%=LkSNEntityType.Catalog%>" 
                  enabled="<%=canEditSales%>"/>
          </v:form-field>
          <v:form-field caption="@Payment.Payment">
            <v:lk-radio lookup="<%=LkSN.AccountChannelManagerPay%>" field="accountFinance.ChannelManagerPay" allowNull="false" inline="true" enabled="<%=canEditSales%>"/>
          </v:form-field>
          <v:form-field>
            <v:db-checkbox caption="@Account.Credit.ChannelManagerEncode" hint="@Account.Credit.ChannelManagerEncodeHint" field="accountFinance.ChannelManagerEncode" value="true" enabled="<%=canEditSales%>" />
          </v:form-field>
        </div>
      </v:widget-block>
            
    </v:widget>

    <v:widget caption="@Account.Credit.FinanceTitle" include="<%=canReadFinance%>">
      <v:widget-block>
        <v:form-field caption="@Account.Credit.TotalCredit">
          <v:input-text field="accountFinance.TotalCredit" enabled="<%=canEditFinance%>"/>
        </v:form-field>
        <v:form-field caption="@Account.Credit.CreditDays">
          <v:input-text field="accountFinance.CreditDays" enabled="<%=canEditFinance%>"/>
        </v:form-field>
        <v:form-field caption="@Account.Credit.GracePeriodDays" hint="@Account.Credit.GracePeriodDaysHint">
          <v:input-text field="accountFinance.GracePeriodDays" enabled="<%=canEditFinance%>"/>
        </v:form-field>
        <v:form-field caption="@Account.Credit.VoidWindowDays" hint="@Account.Credit.VoidWindowDaysHint">
          <v:input-text field="accountFinance.VoidWindowDays" placeholder="@Common.Always" enabled="<%=canEditFinance%>"/>
        </v:form-field>
        <v:form-field caption="@Account.Credit.CreditPerTrans">
          <v:input-text field="accountFinance.CreditPerTransaction" placeholder="@Common.Unlimited" enabled="<%=canEditFinance%>"/>
        </v:form-field>
        <v:form-field caption="@Account.Credit.ItemsPerTrans">
          <v:input-text field="accountFinance.ItemsPerTransaction" placeholder="@Common.Unlimited" enabled="<%=canEditFinance%>"/>
        </v:form-field>
        <v:form-field caption="@Account.Credit.ConsignmentPaymentMethod" hint="@Account.Credit.ConsignmentPaymentMethodHint" clazz="hidden">
          <v:combobox 
              field="accountFinance.ConsignmentPaymentMethodId" 
              lookupDataSet="<%=pageBase.getBL(BLBO_PayMethod.class).getPaymentMethodDS()%>" 
              idFieldName="PluginId" 
              captionFieldName="PluginDisplayName"
              enabled="<%=canEditFinance%>" 
          />
        </v:form-field>
        <v:form-field caption="@Payment.PaymentMethods" hint="@Account.Credit.RestrictPayMethodsHint" checkBoxField="cbRestrictPayMethods" enabled="<%=canEditFinance%>">
          <v:multibox 
              field="accountFinance.PaymentMethodIDs" 
              lookupDataSet="<%=pageBase.getBL(BLBO_PayMethod.class).getPaymentMethodDS()%>" 
              idFieldName="PluginId" 
              captionFieldName="PluginDisplayName" 
              enabled="<%=canEditFinance%>"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <div><v:db-checkbox caption="@Account.Credit.OpenOrders" hint="@Account.Credit.OpenOrdersHint" field="accountFinance.AllowOpenOrder" value="true" enabled="<%=canEditFinance%>"/></div>
        <div data-visibilitycontroller="#accountFinance\.AllowOpenOrder">
          <v:db-checkbox caption="@Account.Credit.OpenOrderAffectCredit" hint="@Account.Credit.OpenOrderAffectCreditHint" field="accountFinance.OpenOrderAffectCredit" value="true" enabled="<%=canEditFinance%>"/>
        </div>
        
        <div><v:db-checkbox caption="@Account.Credit.AllowDeposit" hint="@Account.Credit.AllowDepositHint" field="accountFinance.AllowDeposit" value="true" enabled="<%=canEditFinance%>"/></div>
        <div><v:db-checkbox caption="@Account.Credit.AutoPayCredits" field="accountFinance.AutoPayCredits" value="true" enabled="<%=canEditFinance%>"/></div>
<%-- 
        <div><v:db-checkbox caption="@Account.Credit.RestrictPayMethods" field="cbRestrictPayMethods" value="true" enabled="<%=canEditFinance%>" checked="<%=!accountFinance.PaymentMethodIDs.isEmpty()%>" /></div>
        <div id="paymethod-container" class="hidden" style="margin-top:5px">
          <v:multibox 
              field="accountFinance.PaymentMethodIDs" 
              lookupDataSet="<%=pageBase.getBL(BLBO_PayMethod.class).getPaymentMethodDS()%>" 
              idFieldName="PluginId" 
              captionFieldName="PluginDisplayName" 
              enabled="<%=canEditFinance%>"/>
        </div>
--%>
        <div><v:db-checkbox caption="@Account.Credit.AutoSettleOnInvoice" hint="@Account.Credit.AutoSettleOnInvoiceHint" field="accountFinance.CreditAutoSettleOnInvoice" value="true" enabled="<%=canEditFinance%>"/></div>
        <div data-visibilitycontroller="#accountFinance\.CreditAutoSettleOnInvoice">
          <div><v:db-checkbox caption="@Account.Credit.AutoSettleAdjustLimit" hint="@Account.Credit.AutoSettleAdjustLimitHint" field="accountFinance.CreditAutoSettleAdjustLimit" value="true" enabled="<%=canEditFinance%>" /></div>
        </div>
      </v:widget-block>
    </v:widget>
  </v:profile-main>
  
<script>

$(document).ready(function() {
  $("#commission-on-sale-radio").prop('checked', <%=!account.AccountFinance.CommissionOnRedemption.getBoolean()%>);
  $("#commission-on-redemption-radio").prop('checked', <%=account.AccountFinance.CommissionOnRedemption.getBoolean()%>);
  $("[name='cbRestrictPayMethods']").setChecked(<%=!account.AccountFinance.PaymentMethodIDs.isEmpty()%>);
  
  refreshVisibility();
  $("#accountFinance\\.B2BWorkstationId").change(refreshVisibility);
  $("#cbRestrictB2BUsers").click(refreshVisibility);
  $("#cbAutopayOpenRes").click(refreshVisibility);
  $("#accountFinance\\.AutoPaymentMethodId").change(refreshVisibility);
  $("#accountFinance\\.AutoAltPaymentMethodId").change(refreshVisibility);
  $("#cbChannelManager").click(refreshVisibility);
});


function refreshVisibility() {
  var B2BWorkstationId = $("#accountFinance\\.B2BWorkstationId").val();
  var autoPaymentMethodId = $("#accountFinance\\.AutoPaymentMethodId").val();
  var autoAltPaymentMethodId = $("#accountFinance\\.AutoAltPaymentMethodId").val();
  var webPaymentIDs = <%=JvString.jsString(JvArray.arrayToString(webPaymentIDs, ","))%>;
  
  $("#user-limit-list").setClass("hidden", B2BWorkstationId == "")
  $("#user-limit-body").setClass("hidden", !$("#cbRestrictB2BUsers").isChecked());
  $("#agent-account-id-field").setClass("hidden", <%=xpiAccount%>);
  $("#B2B-workstation-field").setClass("hidden", <%=xpiAccount%>);
  $("#autopay-openres-body").setClass("hidden", !$("#cbAutopayOpenRes").isChecked());
  $("#autopay-tokenid-body").setClass("hidden", !webPaymentIDs.includes(autoPaymentMethodId));
  $("#autopay-altpayment-body").setClass("hidden", !$("#cbAutopayOpenRes").isChecked());
  $("#autopay-alttokenid-body").setClass("hidden", (autoAltPaymentMethodId.trim().length === 0) || !webPaymentIDs.includes(autoAltPaymentMethodId));
  $("#channelmanager-body").setClass("hidden", !$("#cbChannelManager").isChecked());
}

function convertValue(value, defValue) {
  var result = null;
  if (value) {
    value = value.replace(",", ".");
    if (value != "")
      result = strToFloatDef(value, defValue);
  }
  return result;
}

function getPaymentMethods() {
  if ($("[name='cbRestrictPayMethods']").isChecked())
    return $("#accountFinance\\.PaymentMethodIDs")[0].selectize.getValue();
  else
    return [];
}

function getAccountUserLimitList() {
  var list = [];
  if ($("#cbRestrictB2BUsers").isChecked()) {
    $(".userLimitQty").each(function() {
      var qty = strToIntDef($(this).val(), null);
      if (qty != null) {
        list.push({
          RoleId: $(this).attr("id"),
          Quantity: qty
        });
      }
    });
  }
  return list;
}

function saveFinance() {
  var autoDaysBeforeVisit = parseInt($("#accountFinance\\.AutoDaysBeforeVisit").val());
  var autoPaymentMethodId = $("#accountFinance\\.AutoPaymentMethodId").val();
  var autoAltPaymentMethodId = $("#accountFinance\\.AutoAltPaymentMethodId").val();
  
  var webPaymentIDs = <%=JvString.jsString(JvArray.arrayToString(webPaymentIDs, ","))%>;
  
  var autoPaymentTokenIdAllowed = webPaymentIDs.includes(autoPaymentMethodId);
  var autoAltPaymentTokenIdAllowed = webPaymentIDs.includes(autoAltPaymentMethodId);
  
  var channelManagerChecked = $("#cbChannelManager").isChecked();
  
  if ($("#cbAutopayOpenRes").isChecked() && (autoDaysBeforeVisit < 0))
    showIconMessage("warning", "Invalid parameter value [" + itl("@Account.Credit.DaysBeforeVisit") + "]");
  else {
    var reqDO = {
      AccountId  : <%=JvString.jsString(pageBase.getId())%>,
      EntityType : <%=account.EntityType.getInteger()%>,
      AccountFinance: {
        Active                        : true,
        SaleChannelId                 : $("#accountFinance\\.SaleChannelId").val(),
        CommissionId                  : $("#accountFinance\\.CommissionId").val(),
        AgentAccountId                : $("#accountFinance\\.AgentAccountId").val(),
        B2BWorkstationId              : $("#accountFinance\\.B2BWorkstationId").val(),
        MainCatalogIDs                : $("#accountFinance\\.MainCatalogIDs").val(),
        TotalCredit                   : (convertValue($("#accountFinance\\.TotalCredit").val(), 0) == null)? 0 : convertValue($("#accountFinance\\.TotalCredit").val(), 0),
        CreditDays                    : strToIntDef($("#accountFinance\\.CreditDays").val(), 0),
        GracePeriodDays               : strToIntDef($("#accountFinance\\.GracePeriodDays").val(), 0),
        VoidWindowDays                : $("#accountFinance\\.VoidWindowDays").val(),
        CreditPerTransaction          : convertValue($("#accountFinance\\.CreditPerTransaction").val(), 0),
        ItemsPerTransaction           : strToIntDef($("#accountFinance\\.ItemsPerTransaction").val(), null),
        AllowOpenOrder                : $("#accountFinance\\.AllowOpenOrder").isChecked(),
        OpenOrderAffectCredit         : $("#accountFinance\\.OpenOrderAffectCredit").isChecked(),
        AutoPayCredits                : $("#accountFinance\\.AutoPayCredits").isChecked(),
        CreditAutoSettleOnInvoice     : $("#accountFinance\\.CreditAutoSettleOnInvoice").isChecked(),
        CreditAutoSettleAdjustLimit   : $("#accountFinance\\.CreditAutoSettleAdjustLimit").isChecked(),
        ResPurgeLock                  : $("#accountFinance\\.ResPurgeLock").isChecked(),
        AllowInventory                : $("#accountFinance\\.AllowInventory").isChecked(),
        AllowDeposit                  : $("#accountFinance\\.AllowDeposit").isChecked(),
        AllowPayByToken               : $("#accountFinance\\.AllowPayByToken").isChecked(),
        CreditCommissionToDeposit     : $("#accountFinance\\.CreditCommissionToDeposit").isChecked(),
        CommissionOnRedemption        : $("#commission-on-redemption-radio").isChecked(),
        B2BPreventTicketEncoding      : $("#accountFinance\\.B2BPreventTicketEncoding").isChecked(),
        PaymentMethodIDs              : getPaymentMethods(),
        B2BUserLimitList              : getAccountUserLimitList(),
        ConsignmentPaymentMethodId    : $("#accountFinance\\.ConsignmentPaymentMethodId").val(),
        AutoDaysBeforeVisit           : $("#cbAutopayOpenRes").isChecked() ? $("#accountFinance\\.AutoDaysBeforeVisit").val() : null,
        AutoPaymentMethodId           : $("#cbAutopayOpenRes").isChecked() ? $("#accountFinance\\.AutoPaymentMethodId").val() : null,
        AutoPaymentTokenId            : $("#cbAutopayOpenRes").isChecked() && autoPaymentTokenIdAllowed ? $("#accountFinance\\.AutoPaymentTokenId").val() : null,
        AutoAltPaymentMethodId        : $("#cbAutopayOpenRes").isChecked() ? $("#accountFinance\\.AutoAltPaymentMethodId").val() : null,
        AutoAltPaymentTokenId         : $("#cbAutopayOpenRes").isChecked() && autoAltPaymentTokenIdAllowed ? $("#accountFinance\\.AutoAltPaymentTokenId").val() : null,
        ChannelManagerPluginId        : channelManagerChecked ? $("#accountFinance\\.ChannelManagerPluginId").val() : null,
        ChannelManagerWorkstationId   : channelManagerChecked ? $("#accountFinance\\.ChannelManagerWorkstationId").val() : null,
        ChannelManagerCodeAliasTypeId : channelManagerChecked ? $("#accountFinance\\.ChannelManagerCodeAliasTypeId").val() : null,
        ChannelManagerResellerCode    : channelManagerChecked ? $("#accountFinance\\.ChannelManagerResellerCode").val() : null,
        ChannelManagerResellerCode    : channelManagerChecked ? $("#accountFinance\\.ChannelManagerResellerCode").val() : null,
        ChannelManagerPay             : channelManagerChecked ? $("[name='accountFinance.ChannelManagerPay']:checked").val() : null,
        ChannelManagerEncode          : channelManagerChecked && $("#accountFinance\\.ChannelManagerEncode").isChecked(),
        ChannelManagerCatalogIDs      : channelManagerChecked ? $("#accountFinance\\.ChannelManagerCatalogIDs").val() : null
      }
    };
    
    snpAPI.cmd("Account", "SaveAccount", reqDO).then(ansDO => entitySaveNotification(<%=account.EntityType.getInt()%>, <%=account.AccountId.getJsString()%>, "tab=finance"));
  }
}

function disableFinance() {
  confirmDialog(itl("@Account.Credit.RemoveFinanceSettings"), function() {
    var reqDO = {
        Command: "DisableFinance",
        DisableFinance: {
          AccountId: <%=JvString.jsString(pageBase.getId())%>
        } 
    }
    
    vgsService("Account", reqDO, false, function(ansDO) {
        window.location = "<v:config key="site_url"/>/admin?page=account&id=<%=pageBase.getId()%>";
    });
  });
};
  
</script>

</v:tab-content>

</v:page-form>