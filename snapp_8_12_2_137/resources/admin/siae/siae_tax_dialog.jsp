<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
DOSiaeTax tax = null;
if (pageBase.getId() != null) {
  tax = bl.loadTax(pageBase.getId());
} else {
  tax = bl.prepareNewTax();
}
request.setAttribute("tax", tax);
boolean isEnabled = bl.isSiaeEnabled();
%>

<v:dialog id="tax_dialog" icon="siae.png" title="Tax SIAE" width="800" height="600" autofocus="false">
<jsp:include page="/resources/admin/siae/siae_alert.jsp" />
<v:widget caption="@Common.General" icon="profile.png">
    <v:widget-block>
      <v:form-field caption="@Common.Name" mandatory="true" clazz="default-focus">
        <v:input-text field="tax.TaxName" enabled="<%=isEnabled%>"/>
     </v:form-field>
    </v:widget-block>
  </v:widget>

  <v:grid id="tax-rate-grid">
    <thead>
      <v:grid-title caption="@Common.Rates"/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="30%"><v:itl key="@Common.ValidFrom"/></td>
        <td width="30%"><v:itl key="@Common.ValidTo"/></td>
        <td width="40%"><v:itl key="@Common.Value"/> (%)</td>
      </tr>
    </thead>
    <tbody id="tax-rate-tbody"></tbody>
    <tbody class="toolbar">
      <tr>
        <td colspan="100%">
          <v:button caption="@Common.Add" fa="plus" href="javascript:doAddTaxRate()"/>
          <v:button caption="@Common.Remove" fa="minus" href="javascript:doRemoveTaxRates()"/>
        </td>
      </tr>
    </tbody>
  </v:grid>

<script src="<v:config key="resources_url"/>/admin/script/siae.js"></script>
<script>
$(document).ready(function() {
  var dlg = $("#tax_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Save" encode="JS"/>,
        click: doSaveTax,
      }, 
      {
        text: <v:itl key="@Common.Cancel" encode="JS"/>,
        click: doCloseDialog
      }
    ];
    setTimeout(function() {
      $(".default-focus").focus();
    }, 1);
  });
  
  <% for (DOSiaeTax.DOSiaeTaxRate taxRate : tax.TaxRateList) { %>
    doAddTaxRate(<%=JvString.jsString(taxRate.ValidDateFrom.getXMLValue())%>, <%=JvString.jsString(taxRate.ValidDateTo.getXMLValue())%>, <%=taxRate.TaxValue.getFloat()%>);
  <% } %>

});

function doAddTaxRate(validDateFrom, validDateTo, taxValue) {
  var tr = $("<tr/>").appendTo("#tax-rate-tbody");
  var tdCB = $("<td/>").appendTo(tr);
  var tdFrom = $("<td/>").appendTo(tr);
  var tdTo = $("<td/>").appendTo(tr);
  var tdValue = $("<td/>").appendTo(tr);
  
  $("<input type='checkbox' class='cblist'/>").appendTo(tdCB);

  var pickerFrom = $("<input type='text' name='ValidDateFrom'/>").appendTo(tdFrom).datepicker();
  pickerFrom.attr("placeholder", "<v:itl key="@Common.Unlimited" encode="UTF-8"/>");
  pickerFrom.datepicker("setDate", (validDateFrom) ? xmlToDate(validDateFrom) : new Date());

  var pickerTo = $("<input type='text' name='ValidDateTo'/>").appendTo(tdTo).datepicker();
  pickerTo.attr("placeholder", "<v:itl key="@Common.Unlimited" encode="UTF-8"/>");
  if (validDateTo)
    pickerTo.datepicker("setDate", xmlToDate(validDateTo));
  
  $("<input type='number' name='TaxValue' min='0' max='100' step='0.01' />").appendTo(tdValue).val(taxValue);
}

function doRemoveTaxRates() {
  $("#tax-rate-grid tbody .cblist:checked").parents("tr").remove();
}

function doSaveTax() {
  var reqDO = {
    Command: "SaveTax",
    SaveTax: {
      Tax: {
        SiaeTaxId: <%=JvString.jsString(tax.SiaeTaxId.getString())%>,
        TaxName: $("#tax\\.TaxName").val(),
        TaxRateList: []
      }
    }
  };
  
  var trs = $("#tax-rate-tbody tr");
  
  for (var i=0; i<trs.length; i++) {
    var taxRate = {
      ValidDateFrom: $(trs[i]).find("[name='ValidDateFrom']").getXMLDate(),
      ValidDateTo: $(trs[i]).find("[name='ValidDateTo']").getXMLDate(),
      TaxValue: parseFloat($(trs[i]).find("[name='TaxValue']").val().replace(",","."))
    };
    
    if (isNaN(taxRate.TaxValue))
      taxRate.TaxValue = 0;
    
    if (taxRate.TaxValue <0 || taxRate.TaxValue > 100) {  
      showMessage("Il valore del tasso deve essere compreso tra 0% e 100%");  
      return; 
    }
    
    if (taxRate.ValidDateFrom === '') {
      showMessage('Il campo "Valido da" non può essere vuoto');
      return;
    }
    
    reqDO.SaveTax.Tax.TaxRateList.push(taxRate);
  }
  
  if (!checkOverlappingTaxRates(reqDO.SaveTax.Tax.TaxRateList)) {
    showMessage("Gli intervalli di date di validità delle tasse non possono sovrapporsi");
    return;
  }
  
  vgsService("Siae", reqDO, false, function(ansDO) {
    showMessage("<v:itl key="@Common.SaveSuccessMsg"/>", function() {
      triggerEntityChange(<%=LkSNEntityType.SiaeTax.getCode()%>);
      $("#tax_dialog").dialog("close");
    });
  });
}

function checkOverlappingTaxRates(taxRateList) {
  for (var i = 0; i < taxRateList.length; ++i) {
    for (var j = 0; j < taxRateList.length; ++j) {
      if (i !== j) {
        var taxRate1 = taxRateList[i];
        var from1 = new Date(taxRate1.ValidDateFrom);
        var to1 = taxRate1.ValidDateTo;
        to1 = to1 ? new Date(to1) : null;
        var taxRate2 = taxRateList[j];
        var from2 = new Date(taxRate2.ValidDateFrom);
        var to2 = taxRate2.ValidDateTo;
        to2 = to2 ? new Date(to2) : null; 
        if (isOverlappingTaxRate(from1, to1, from2, to2)) {
          return false;
        }
      }
    }
  }
  return true;
};

function isOverlappingTaxRate(from1, to1, from2, to2) {
  if (to1 === null && to2 === null) {
    return true;
  } else if (to1 === null && from2 >= from1) {
    return true;
  } else if (to2 === null && to1 >= from2) {
    return true;
  } else if (to1 !== null && to2 !== null) {
    if (from1 <= from2 && from2 <= to1) {
      return true;
    } else if (from2 <= from1 && from1 <= to2) {
      return true;
    }
  }
  return false;
};
</script>

</v:dialog>