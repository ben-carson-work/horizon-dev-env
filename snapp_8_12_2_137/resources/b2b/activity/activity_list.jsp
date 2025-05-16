<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_ActivityList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
int[] defaultStatusFilter = new int[] {LkSNCreditStatus.Opened.getCode(), LkSNCreditStatus.Invoiced.getCode()};
String wpgPluginId = pageBase.getBL(BLBO_Plugin.class).findWebPaymentGatewayPluginId();
String payMethodId = null;
boolean allowDeposit = pageBase.getSession().getOrgAllowDeposit() && rights.B2BAgent_ManageFinance.getBoolean();

List<DOPaymentMethodRef> payMethods = pageBase.getBL(BLBO_PayMethod.class).getRightsPaymentMethods(LkSNTransactionType.Normal);
for (DOPaymentMethodRef payMethod : payMethods) 
  if (payMethod.PaymentType.isLookup(LkSNPaymentType.WebPayment)) {
    payMethodId = payMethod.PaymentMethodId.getString();
    break;
  }

%>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true"> 
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" onclick="search()" />
      <span class="divider"></span>
      <% if (allowDeposit) { %>
        <v:button caption="@Common.Deposit" fa="money-bill" onclick="askAccountDepositAmount()" enabled="<%=wpgPluginId!=null%>"/>
      <% } %>  
      <v:pagebox gridId="activity-grid"/>
    </div>

    <div class="tab-content">
      <div class="profile-pic-div">
        <v:widget caption="@Common.Search">
          <v:widget-block>
            <input type="text" id="SaleCode" class="form-control default-focus" placeholder="<v:itl key="@Sale.PNR"/>"/>
          </v:widget-block>
        </v:widget>

        <v:widget caption="@Common.DateRange">
          <v:widget-block>
            <label for="FromDate"><v:itl key="@Common.From"/></label><br/>
            <v:input-text type="datepicker" field="FromDate"/>
              
            <div class="filter-divider"></div>
              
            <label for="ToDate"><v:itl key="@Common.To"/></label><br/>
            <v:input-text type="datepicker" field="ToDate"/>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <v:async-grid id="activity-grid" jsp="activity/activity_grid.jsp"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<script>

function search() {
  setGridUrlParam("#activity-grid", "SaleCode", $("#SaleCode").val());
  setGridUrlParam("#activity-grid", "FromDate", $("#FromDate-picker").getXMLDate());
  setGridUrlParam("#activity-grid", "ToDate", $("#ToDate-picker").getXMLDate());
  changeGridPage("#activity-grid", "first");
}

function searchOnEnter() {
  if (event.keyCode == KEY_ENTER) {
    search();
    return false;
  }
}

function askAccountDepositAmount() {
	var dlg = $(
			"<div class='form-field'>" +
			"  <div class='form-field-caption v-tooltip-overflow hint-tooltip'>" +
			"    <v:itl key='@Common.Amount'/>" +
			"  </div>" +
			"  <div class='form-field-value'>" +
      "    <input type='text' id='depositAmount' name='depositAmount' class='form-control'>" +
      "  </div>" +
      "</div>");

	var txt = $("#depositAmount")
    
  function btnAmountEditOk() {
  	var amount = parseFloat($("#depositAmount").val().replace(",", "."));
    if (!isNaN(amount) && (amount >= 0)) {
 	    doAccountDeposit(amount);
      dlg.dialog("close");            
    }
  }

  dlg.dialog({
     	width: 400,
      height: 150,
      modal: true,
      title: <v:itl key="@Account.DepositActionHint" encode="JS"/>,
      close: function() {
        dlg.remove();
      },
      buttons: {
        <v:itl key="@Common.Back" encode="JS"/>: doCloseDialog,
        <v:itl key="@Common.Confirm" encode="JS"/>: btnAmountEditOk
      }
  });

}

function doAccountDeposit(amount) {
  asyncDialogEasy("activity/account_deposit_webpayment_dialog", "Amount=" + amount + "&PluginId=<%=wpgPluginId%>&PayMethodId=<%=payMethodId%>");
}

$("#SaleCode").keypress(searchOnEnter);

</script>

<jsp:include page="/resources/common/footer.jsp"/>
