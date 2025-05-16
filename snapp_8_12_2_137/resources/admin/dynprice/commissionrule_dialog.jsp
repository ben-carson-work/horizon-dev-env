<%@page import="com.sun.mail.imap.Rights"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  DOCommissionRule commission = pageBase.isNewItem() ? new DOCommissionRule() : pageBase.getBL(BLBO_CommissionRule.class).loadCommissionRule(pageBase.getId());
  if (pageBase.isNewItem())
    commission.Enabled.setBoolean(true);
  request.setAttribute("commission", commission);
%>

<v:dialog id="commissionrule-dialog" width="900" height="700" title="@Commission.CommissionRule" tabsView="true" autofocus="false">

  <style>
    .quantity-columns,
    .amount-columns {
      display: none;
    }
    
    #commission-detail-grid[data-IsQuantity='true'] .quantity-columns {
      display: table-cell;
    }
    
    #commission-detail-grid[data-IsQuantity='false'] .amount-columns {
      display: table-cell;
    }
  </style>

	<div class="v-hidden">
	  <snp:tag-combobtn field="financeGroupTagId" entityType="<%=LkSNEntityType.FinanceGroup%>" id="finance-tagid-template"/>
	</div>
	
	<v:tab-group name="tab" main="true">
	  <v:tab-item-embedded tab="commissionrule-tab-profile" caption="@Common.Profile" default="true">
	    <div class="tab-content">
			  <v:widget caption="@Common.General">
			    <v:widget-block>
			      <v:form-field caption="@Common.Code" mandatory="true">
			        <v:input-text field="commission.CommissionCode"/>
			      </v:form-field>
			      <v:form-field caption="@Common.Name" mandatory="true">
			        <v:input-text field="commission.CommissionName"/>
			      </v:form-field>
			      <v:form-field caption="@Commission.PeriodType">
			        <v:lk-combobox field="commission.PeriodType" lookup="<%=LkSN.PeriodType%>" allowNull="false"/>
			      </v:form-field>
			      <v:form-field caption="@Common.Type">
			        <div id="commission.IsQuantity">
                      <v:radio id="quantity-radio" name="Quantity-Amount" value="true" caption="@Common.Quantity"/>
                      &nbsp;
                      <v:radio id="amount-radio" name="Quantity-Amount" value="false" caption="@Common.Amount"/>
			        </div>
			      </v:form-field>
			      <v:form-field caption="@Commission.CommissionAmountType">
			        <v:lk-radio lookup="<%=LkSN.CommissionAmountType%>" field="commission.CommissionAmountType" allowNull="false" inline="true"/>
			      </v:form-field>
                  <v:form-field>
                    <v:db-checkbox field="commission.CalculateOnGrossPrice" caption="@Commission.CalculateOnGrossPrice" hint="@Commission.CalculateOnGrossPriceHint" value="true"/>
                  </v:form-field>
                  <v:form-field caption="@Product.TaxProfile" hint="@Commission.TaxProfileHint">
                    <v:combobox field="commission.TaxProfileId" lookupDataSet="<%=pageBase.getBL(BLBO_Tax.class).getTaxProfileDS()%>" idFieldName="TaxProfileId" captionFieldName="TaxProfileName" linkEntityType="<%=LkSNEntityType.TaxProfile.getCode()%>"/>
                  </v:form-field>
                  <v:form-field caption="@Common.Rounding" hint="@Commission.RoundingHint">
                    <v:lk-combobox field="commission.RoundingType" allowNull="false" lookup="<%=LkSN.RoundingType%>"/>
                  </v:form-field>
			    </v:widget-block>
			    <v:widget-block>
			      <v:form-field>
			        <v:db-checkbox field="commission.Enabled" caption="@Common.Active" value="true"/>
			      </v:form-field>
			    </v:widget-block>
			  </v:widget>
			  <v:grid id="commission-detail-grid">
			    <thead>
			      <tr>
			        <td><v:grid-checkbox header="true"/></td>
			        <td width="35%"><v:itl key="@Product.FinanceGroup"/></td>
			        <td class="quantity-columns" width="25%"><v:itl key="@Commission.QuantityFrom"/></td>
			        <td class="quantity-columns" width="25%"><v:itl key="@Commission.QuantityTo"/></td>
			        <td class="amount-columns" width="25%"><v:itl key="@Commission.AmountFrom"/></td>
			        <td class="amount-columns" width="25%"><v:itl key="@Commission.AmountTo"/></td>
			        <td width="25%"><v:itl key="@Common.Percentage"/></td>
			      </tr>
			    </thead>
			    <tbody id="commission-detail-body">
			    </tbody>
			    <tbody>
			      <tr>
			        <td colspan="100%">
			          <% String href="javascript:addDetail(true)"; %>
			          <v:button caption="@Common.Add" fa="plus" href="<%=href%>"/>
			          <v:button caption="@Common.Remove" fa="minus" href="javascript:removeDetail()"/>
			        </td>
			      </tr>
			    </tbody>
			  </v:grid>
			</div>  
		</v:tab-item-embedded>  
		
	<% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
      <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
        <jsp:include page="../common/page_tab_historydetail.jsp"/>
      </v:tab-item-embedded>
  <% } %>
		
</v:tab-group>	  
  
<script>
  var commission = <%=commission.getJSONString()%>;
  
  $("#commission\\.IsQuantity").find("[name='Quantity-Amount']").change(refreshVisibility);
  
  var dlg = $("#commissionrule-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Save" encode="JS"/>: doSave,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
  if ((commission) && (commission.DetailList)) {
    for (var i=0; i<commission.DetailList.length; i++) {
      addDetail(false,
        commission.DetailList[i].FinanceGroupTagId,  
        commission.DetailList[i].FinanceGroupTagCode,
        commission.DetailList[i].FinanceGroupTagName,
        commission.DetailList[i].QuantityFrom, 
        commission.DetailList[i].QuantityTo,
        commission.DetailList[i].AmountFrom,
        commission.DetailList[i].AmountTo,
        commission.DetailList[i].Percentage);
    }
  }

  $(document).ready(function() {
    $("#quantity-radio").prop('checked', <%=commission.IsQuantity.getBoolean()%>);
    $("#amount-radio").prop('checked', <%=!commission.IsQuantity.getBoolean()%>);
    
    refreshVisibility();
  });
  
  function refreshVisibility() {
    $("#commission-detail-grid").attr("data-IsQuantity", $("#commission\\.IsQuantity").find("[name='Quantity-Amount']:checked").val());
  }
  
  function doSave() {
    checkRequired("#commissionrule-dialog", function() {
      doSaveCommission();
    }) ;
  }
  
  function removeDetail() {
    $("#commissionrule-dialog .cblist:checked").not(".header").closest("tr").remove();
  }
  
  function addDetail(autoOpen, financeGroupTagId, financeGroupTagCode, financeGroupTagName, qtyFrom, qtyTo, amountFrom, amountTo, percentage) {
    
    var trs = $("#commission-detail-body tr");
    var id = trs.length + 1;
    
    var tr = $("<tr class='grid-row' data-CommissionId='" + id + "'/>").appendTo("#commission-detail-body");
    var tdCB = $("<td valign='top'/>").appendTo(tr);  
    var tdCombo = $("<td valign='top'/>").appendTo(tr);
    var combo = $("#finance-tagid-template").clone().appendTo(tdCombo);
    var tdQtyFrom = $("<td valign='top' class='quantity-columns'/>").appendTo(tr);
    var tdQtyTo = $("<td valign='top' class='quantity-columns'/>").appendTo(tr);
    var tdAmountFrom = $("<td valign='top' class='amount-columns'/>").appendTo(tr);
    var tdAmountTo = $("<td valign='top' class='amount-columns'/>").appendTo(tr);
    var tdPercentage = $("<td valign='top'/>").appendTo(tr);
    
    tdCB.append("<input value='" + id + "' type='checkbox' class='cblist'>");
    
    tdCombo.find(".v-combobtn").vcombobtn_SetValue(financeGroupTagId, financeGroupTagCode, financeGroupTagName);
    
    tdQtyFrom.append("<input type='text' class='form-control' name='qtyFrom'/>"); 
    tdQtyFrom.find("input").attr("placeholder", "0");
    tdQtyFrom.find("input").val(qtyFrom);
    
    tdQtyTo.append("<input type='text' class='form-control' name='qtyTo'/>"); 
    tdQtyTo.find("input").attr("placeholder", <v:itl key="@Common.Unlimited" encode="JS"/>);
    tdQtyTo.find("input").val(qtyTo);
    
    tdAmountFrom.append("<input type='text' class='form-control' name='amountFrom'/>"); 
    tdAmountFrom.find("input").attr("placeholder", "0");
    tdAmountFrom.find("input").val(amountFrom);
    
    tdAmountTo.append("<input type='text' class='form-control' name='amountTo'/>"); 
    tdAmountTo.find("input").attr("placeholder", <v:itl key="@Common.Unlimited" encode="JS"/>);
    tdAmountTo.find("input").val(amountTo);
    
    tdPercentage.append("<input type='text' class='form-control' name='percentage'/>"); 
    tdPercentage.find("input").val(percentage);
    
    if (autoOpen)
      tdCombo.find(".v-combobtn").click();
  }
  
  function getDetailList() {
   
    var list = [];
    var trs = $("#commission-detail-body tr");

    for (var i=0; i<trs.length; i++) {
      var tr = $(trs[i]);

      var amountFrom = convertPriceValue(tr.find("[name='amountFrom']").val());
      var amountTo = convertPriceValue(tr.find("[name='amountTo']").val());
      var percentage = convertPriceValue(tr.find("[name='percentage']").val());
      list.push({
        FinanceGroupTagId: tr.find("[name='financeGroupTagId']").val(),
        QuantityFrom: (tr.find("[name='qtyFrom']").val())? tr.find("[name='qtyFrom']").val() : 0,
        QuantityTo: tr.find("[name='qtyTo']").val(),
        AmountFrom: (amountFrom)? amountFrom : 0,
        AmountTo: amountTo,
        Percentage: percentage
      });
    }

    return list;
  }
  
  function doSaveCommission() {
    var reqDO = {
        Command: "SaveCommissionRule",
        SaveCommissionRule: {
           Commission: {
             CommissionId: (<%=!pageBase.isNewItem()%>)? <%=JvString.jsString(pageBase.getId())%> : null,
             CommissionCode: $("#commission\\.CommissionCode").val(),
             CommissionName: $("#commission\\.CommissionName").val(),
             PeriodType: $("#commission\\.PeriodType").val(),
             Enabled: $("#commission\\.Enabled").isChecked(),
             IsQuantity: $("#quantity-radio").isChecked(),
             CommissionAmountType: $("[name='commission.CommissionAmountType']:checked").val(),
             DetailList: getDetailList(),
             RoundingType: $("#commission\\.RoundingType").val(),
             TaxProfileId: $("#commission\\.TaxProfileId").val(),
             CalculateOnGrossPrice: $("#commission\\.CalculateOnGrossPrice").is(":checked")
           }
        }
      };
    
    vgsService("Product", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.CommissionRule.getCode()%>);
      $("#commissionrule-dialog").dialog("close");
    }); 
    
  }
  
</script>

</v:dialog>