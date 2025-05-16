<%@page import="com.vgs.web.library.BLBO_Currency"%>
<%@page import="com.vgs.snapp.dataobject.DOCurrency.DOCurrencyDetail"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageCurrency" scope="request"/>
<jsp:useBean id="currency" class="com.vgs.snapp.dataobject.DOCurrency" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
 
<v:page-form id="currency-form">
<v:input-text type="hidden" field="currency.CurrencyId"/>
<v:input-text type="hidden" field="currency.CurrencyType"/>

<div class="tab-toolbar">
  <v:button id="btn-save-currency" caption="@Common.Save" fa="save" enabled="<%=rights.SettingsPayments.getBoolean()%>"/>
  <span class="divider"></span>
  <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=export&EntityIDs=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Currency.getCode(); %> 
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Currency%>"/>
</div>
 
<div class="tab-content">
  <v:last-error/>

  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="currency.ISOCode"/>
      </v:form-field>
      <v:form-field caption="@Currency.ISONumeric" mandatory="true">
        <v:input-text field="currency.ISOCodeNumeric"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="currency.CurrencyName"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Currency.Symbol" mandatory="true">
        <v:input-text field="currency.Symbol"/>
      </v:form-field>
      <v:form-field caption="@Currency.Format" mandatory="true">
        <v:lk-combobox field="currency.CurrencyFormat" lookup="<%=LkSN.CurrencyFormat%>" allowNull="false" />
      </v:form-field>
      <v:form-field caption="@Currency.Decimals" mandatory="true">
        <v:input-text field="currency.RoundDecimals"/>
      </v:form-field>
    </v:widget-block>
    <% if (!currency.CurrencyType.isLookup(LkCurrencyType.Main)) { %>
    <v:widget-block>
      <v:form-field caption="@Currency.ExchangeRate" hint="@Currency.ExchangeRateHint" mandatory="true">
       	<v:input-text field="currency.ExchangeRate"/>
      </v:form-field>
      <v:form-field caption="@Currency.ReverseExchangeRate" mandatory="true">
       	<v:input-text field="currency.ReverseExchangeRate"/>
      </v:form-field>
    </v:widget-block>
    <% } %>
  <v:widget-block>
    <div><v:db-checkbox field="CurrencyStatus" caption="@Common.Enabled" value="true" enabled="<%=!currency.CurrencyType.isLookup(LkCurrencyType.Main)%>"/></div>
  </v:widget-block>
  </v:widget>
  <v:widget caption="@Rounding">
    <v:widget-block>
      <v:form-field caption="@Currency.RoundingType">
        <v:lk-combobox field="currency.RoundingType" lookup="<%=LkSN.RoundingType%>" allowNull="false" hideItems="<%=Arrays.asList(LkSNRoundingType.AlgebraicThird)%>" />
      </v:form-field>
      <v:form-field caption="@Currency.SmallestDenomination" mandatory="true">
        <v:input-text field="currency.SmallestDenomination"/>
      </v:form-field>
      <v:form-field caption="@Currency.AlgebraicThreshold" mandatory="true">
        <v:input-text field="currency.AlgebraicThreshold"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

  <% if (!pageBase.isNewItem()) { %>
	  <v:grid id="currency-details-grid">
	    <thead>
	      <v:grid-title caption="@Common.Details"/>
	      <tr>
          <td><v:grid-checkbox header="true"/></td>
          <td align="right"><v:itl key="@Common.Amount"/></td>
          <td width="100%"></td>
        </tr>
	    </thead>
	    <% for (LookupItem item : LkSN.FundCategory.getItems()) { %>
	      <tbody>
	        <tr class="group"><td colspan="100%"><span class="ab-icon" style="background-image:url('<v:image-link name="<%=BLBO_Currency.findIconNameByFundCategory(item)%>" size="16"/>'); margin-right:4px">&nbsp;</span><%=item.getHtmlDescription(pageBase.getLang()) %></td></tr>
	      </tbody>
	      <tbody data-fundcategory="<%=item.getCode()%>">
	      </tbody>
	    <% } %>
	    
	    <tbody>
	      <tr>
	        <td colspan="100%">
	        <v:button id="btn-add-detail" caption="@Common.New" fa="plus"/>
          <v:button id="btn-del-detail" caption="@Common.Delete" fa="trash"/>
	        </td>
	      </tr>
	    </tbody>
    </v:grid>
  <% } %>
</div>

<div id="currency-detail-dialog" title="<v:itl key="@Common.New"/>" class="v-hidden">
  <table class="form-table">
    <tr>
      <th width="50%"><label for="NewFundCategory"><v:itl key="@Currency.FundCategory"/></label></th>
      <td width="50%"><v:lk-combobox field="NewFundCategory" lookup="<%=LkSN.FundCategory%>" allowNull="false"/></td>
    </tr>
    <tr>
      <th><label for="NewAmount"><v:itl key="@Common.Amount"/></label></th>
      <td><input class="form-control" type="text" id="NewAmount"/></td>
    </tr>
  </table>
  <br/>
</div>

</v:page-form>


<script>

$(document).ready(function() {
  $("#btn-add-detail").click(showAddDetailDialog);
  $("#btn-del-detail").click(doDeleteDetail);
  $("#btn-save-currency").click(doSaveCurrency);
  $("#currency\\.ReverseExchangeRate, #currency\\.ExchangeRate").keyup(function(){
	doCalcOtherExchangeRate(this);
  });
	
  $("#currency-detail-dialog").keypress(function() {
    if (event.keyCode == KEY_ENTER)
	  doAddDetail();
  });

  <% if (currency.CurrencyStatus.isLookup(LkSNCurrencyStatus.Active)) { %>
    $("#CurrencyStatus").prop('checked', true);
  <% } %>

  <% if (!pageBase.isNewItem()) { %>
	<% for (DOCurrencyDetail detail : currency.CurrencyDetailList) { %>
	  addDetail(<%=JvString.jsString(detail.FundCategory.getString())%>, <%=JvString.sqlMoney(detail.Amount.getMoney())%>);
	<% } %>
  <% } %>
	
  function findDetailInsertRow($tbody, amount) {
	var $trs = $tbody.find("tr");
	for (var i=0; i<$trs.length; i++) {
	  var $tr = $($trs[i]);
	  var xamount = parseFloat($tr.attr("data-amount"));
	  if (xamount >= amount) 
		return $tr;
	}
	
    return null;
  }
	
  function addDetail(fundCategory, amount) {
    var $tbody = $("#currency-details-grid tbody[data-fundcategory='" + fundCategory + "']");
		
	if ($tbody.find("tr[data-amount='" + amount + "']").length == 0) {
	  var $trInsert = findDetailInsertRow($tbody, amount);
			
      var $tr = $("<tr class='grid-row' data-amount='" + amount + "'/>");
      if ($trInsert == null)
    	$tbody.append($tr);
      else
		$trInsert.before($tr);
      
		var $tdCB = $("<td/>").appendTo($tr);
		var $tdDetail = $("<td align='right' nowrap></td>").appendTo($tr);
		var $tdFill = $("<td/>").appendTo($tr);
		$tdCB.append("<input name='CurrencyDetailId' type='checkbox' class='cblist'>");
		$tdDetail.text(formatCurr(amount));
	} 
	else
	  showMessage(<v:itl key="@Currency.DetailAlreadyExists" encode="JS"/>);
  }

  function doDeleteDetail() {
	$("[name='CurrencyDetailId']:checked").closest("tr").remove();
  }

  function showAddDetailDialog() {
    var dlg = $("#currency-detail-dialog");
	dlg.dialog({
	  modal: true,
	  width: 300,
	  height: 200,
	  buttons: {
	    <v:itl key="@Common.Ok" encode="JS"/>: doAddDetail,
	    <v:itl key="@Common.Cancel" encode="JS"/>: function() {
	      dlg.dialog("close");
	    }
	  }
	});
	  
	$("#NewAmount").val("").focus();
  }
	
  function doAddDetail() {
	var amountTxt = $("#NewAmount").val();
	amountTxt.replace(",", ".");
	var amount = parseInt(amountTxt * 10000);
	var decimals = parseInt((1 / Math.pow(10, $("#currency\\.RoundDecimals").val())) * 10000);
		
	if ((amount % decimals) != 0) {
      $("#currency-detail-dialog").dialog("close");
	    showMessage(<v:itl key="@Currency.InvalidDecimalsError" encode="JS"/>);
	}
	else {
      if (amount > 0)
	    addDetail($("#NewFundCategory").val(), amountTxt);
	  $("#currency-detail-dialog").dialog("close");
	}
  }
	
  function doSaveCurrency() {
    var currencyStatus = $("#CurrencyStatus").isChecked() ? <%=LkSNCurrencyStatus.Active.getCode()%> : <%=LkSNCurrencyStatus.Disabled.getCode()%>;
	checkRequired("#currency-form", function () {
	  var currencyId = <%=JvString.jsString(pageBase.getId())%>;
	  if (currencyId === "new")
		currencyId = null;
		var isoCurrencyCode = parseInt($("#currency\\.ISOCodeNumeric").val());
		if (isNaN(isoCurrencyCode)) {
		  showMessage(itl("@Currency.InvalidISONumericCode"), function() {
		    $("#currency\\.ISOCodeNumeric").focus();
		  });
		}
		else {
		  var reqDO = {
			Command: "SaveCurrency",
			SaveCurrency: {
			  Currency: {
				CurrencyId: currencyId,
				ISOCode: $("#currency\\.ISOCode").val(),		
				ISOCodeNumeric: isoCurrencyCode,
				CurrencyName: $("#currency\\.CurrencyName").val(),
				Symbol: $("#currency\\.Symbol").val(),
				RoundDecimals: $("#currency\\.RoundDecimals").val(),
				ExchangeRate: $("#currency\\.ExchangeRate").val(),
				ReverseExchangeRate: $("#currency\\.ReverseExchangeRate").val(),
				SmallestDenomination: $("#currency\\.SmallestDenomination").val(),
				RoundingType: $("#currency\\.RoundingType").val(),
				AlgebraicThreshold: $("#currency\\.AlgebraicThreshold").val(),
				CurrencyType: $("#currency\\.CurrencyType").val(),
				CurrencyStatus: currencyStatus,
				CurrencyFormat: $("#currency\\.CurrencyFormat").val(),
				CurrencyDetailList: []
			  }
			}
		};
				
		<% for (LookupItem item : LkSN.FundCategory.getItems()) { %>
		  var $tbody = $("#currency-details-grid tbody[data-fundcategory='" + <%=item.getCode()%> + "']");
		  var $trs = $tbody.find("tr");
		  for (var i=0; i<$trs.length; i++) {
		    var $tr = $($trs[i]);
	 		reqDO.SaveCurrency.Currency.CurrencyDetailList.push({
			  FundCategory: <%=item.getCode()%>,
	 		  Amount: $tr.attr("data-amount")
	 		});
		  }
		<% } %>
				
	 	showWaitGlass();
	 	vgsService("PayMethod", reqDO, false, function(ansDO) {
	 	  hideWaitGlass();
	 	  entitySaveNotification(<%=LkSNEntityType.Currency.getCode()%>, ansDO.Answer.SaveCurrency.CurrencyId);
	 	});  
	  }
	});  
  }
	
  // If exchange rate is defined the method will calculate the reverse exchange rate, otherwise will calculate the exchange rate based on the reverse
  function doCalcOtherExchangeRate(obj) {
    var exchangeRate = $("#currency\\.ExchangeRate").val();
    var reverseExchangeRate = $("#currency\\.ReverseExchangeRate").val();
    
    if ($(obj).is("#currency\\.ExchangeRate"))
      $("#currency\\.ReverseExchangeRate").val(1/exchangeRate);
    else
      $("#currency\\.ExchangeRate").val(1/reverseExchangeRate);
  }
});


</script>