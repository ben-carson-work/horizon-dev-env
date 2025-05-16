<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTax" scope="request"/>
<jsp:useBean id="tax" class="com.vgs.snapp.dataobject.DOTax" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canEdit = rights.SettingsTaxes.getBoolean(); %>

<v:tab-toolbar>
  <v:button id="btn-save-tax" fa="save" caption="@Common.Save" enabled="<%=canEdit%>"/>
  <span class="divider"></span>
  <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=export&EntityIDs=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Tax.getCode(); %> 
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
  <span class="divider"></span> 
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Tax%>"/>
</v:tab-toolbar>

<v:tab-content>
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code"><v:input-text field="tax.TaxCode" enabled="<%=canEdit%>"/></v:form-field>
      <v:form-field caption="@Common.Name"><v:input-text field="tax.TaxName" enabled="<%=canEdit%>"/></v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="@Common.Type"><v:lk-combobox field="tax.TaxType" allowNull="false" lookup="<%=LkSN.TaxType%>" enabled="<%=canEdit%>"/></v:form-field>
      <v:form-field caption="@Common.Rounding"><v:lk-combobox field="tax.RoundingType" allowNull="false" lookup="<%=LkSN.RoundingType%>" enabled="<%=canEdit%>"/></v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="@Common.TaxPOSPlugin">
        <v:combobox field="tax.PosPluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.TaxPosCalc)%>" captionFieldName="PluginDisplayName" idFieldName="PluginId" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.TaxServerPlugin">
        <v:combobox field="tax.WebPluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.TaxWebCalc)%>" captionFieldName="PluginDisplayName" idFieldName="PluginId" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="@Product.TaxExemptible">
        <v:radio name="tax-exemptible" value="NO" caption="@Common.No" hint="@Product.TaxNotExemptibleHint"/>&nbsp;&nbsp;&nbsp;
        <v:radio name="tax-exemptible" value="YES" caption="@Common.Yes" hint="@Product.TaxExemptibleHint"/>&nbsp;&nbsp;&nbsp;
        <v:radio name="tax-exemptible" value="EXP" caption="@Product.TaxExemptibleExplicit" hint="@Product.TaxExemptibleExplicitHint"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:db-checkbox field="tax.Remboursable" caption="@Product.TaxRemboursable" value="true" enabled="<%=canEdit%>"/><br/>
      <v:db-checkbox field="tax.BearedTax" caption="@Product.BearedTax" hint="@Product.BearedTaxHint" value="true" enabled="<%=canEdit%>"/><br/>
    </v:widget-block>
    
    <v:widget-block>
      <v:db-checkbox caption="@Product.TaxRestrictLocations" field="cbRestrictLocations" value="true" enabled="<%=canEdit%>" checked="<%=!tax.LocationIDs.isEmpty()%>" />   
      <div id="locations-container" class="v-hidden" style="margin-top:5px">
        <v:multibox 
            field="tax.LocationIDs" 
            lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" 
            idFieldName="AccountId" 
            captionFieldName="DisplayName" 
            enabled="<%=canEdit%>"/>
      </div>
    </v:widget-block>
  </v:widget>

  <v:grid id="tax-rate-grid">
    <thead>
      <v:grid-title caption="@Common.Rates"/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="30%"><v:itl key="@Common.ValidFrom"/></td>
        <td width="30%"><v:itl key="@Common.ValidTo"/></td>
        <td width="40%"><v:itl key="@Common.Value"/></td>
      </tr>
    </thead>
    <tbody id="tax-rate-tbody"></tbody>
    <tbody class="toolbar">
      <tr>
        <td colspan="100%">
		      <v:button id="btn-add-taxrate" caption="@Common.Add" fa="plus"/>
		      <v:button id="btn-del-taxrate" caption="@Common.Remove" fa="minus"/>
		    </td>
		  </tr>
    </tbody>
  </v:grid>
</v:tab-content>

<script>

$(document).ready(function() {
  $("#cbRestrictLocations").click(_refreshVisibility);
  $("#btn-save-tax").click(_saveTax);
  $("#btn-add-taxrate").click(_addTaxRate);
  $("#btn-del-taxrate").click(_removeTaxRates);

  <% for (DOTax.DOTaxRate taxRate : tax.TaxRateList) { %>
    _addTaxRate(<%=JvString.jsString(taxRate.ValidDateFrom.getXMLValue())%>, <%=JvString.jsString(taxRate.ValidDateTo.getXMLValue())%>, <%=taxRate.TaxValue.getString()%>);
  <% } %>
  
  var taxExemptible = <%=tax.ExemptibleExplicit.getBoolean()%> ? "EXP" : <%=tax.Exemptible.getBoolean()%> ? "YES" : "NO";
  $("[name='tax-exemptible'][value='" + taxExemptible + "']").setChecked(true);

  _refreshVisibility();
  
  function _refreshVisibility() {
    $("#locations-container").setClass("v-hidden", !$("#cbRestrictLocations").isChecked());
  }

  function _getLocations() {
    if ($("#cbRestrictLocations").isChecked())
      return $("#tax\\.LocationIDs")[0].selectize.getValue();
    else
      return [];
  }

  function _addTaxRate(validDateFrom, validDateTo, taxValue) {
    var tr = $("<tr/>").appendTo("#tax-rate-tbody");
    var tdCB = $("<td/>").appendTo(tr); 
    var tdFrom = $("<td/>").appendTo(tr); 
    var tdTo = $("<td/>").appendTo(tr); 
    var tdValue = $("<td/>").appendTo(tr);
    
    $("<input type='checkbox' class='cblist'/>").appendTo(tdCB);

    var pickerFrom = $("<input type='text' class='form-control' name='ValidDateFrom'/>").appendTo(tdFrom).datepicker();
    pickerFrom.attr("placeholder", itl("@Common.Unlimited"));
    pickerFrom.datepicker("setDate", (validDateFrom) ? xmlToDate(validDateFrom) : new Date());

    var pickerTo = $("<input type='text' class='form-control' name='ValidDateTo'/>").appendTo(tdTo).datepicker();
    pickerTo.attr("placeholder", itl("@Common.Unlimited"));
    if (validDateTo)
      pickerTo.datepicker("setDate", xmlToDate(validDateTo));
    
    $("<input type='text' name='TaxValue' class='form-control'/>").appendTo(tdValue).val(taxValue);
  }

  function _removeTaxRates() {
    $("#tax-rate-grid tbody .cblist:checked").parents("tr").remove();
  }

  function _saveTax() {
    var reqDO = {
      Tax: {
        TaxId: <%=JvString.jsString(tax.TaxId.getString())%>,
        TaxCode: $("#tax\\.TaxCode").val(),
        TaxName: $("#tax\\.TaxName").val(),
        TaxType: $("#tax\\.TaxType").val(),
        RoundingType: $("#tax\\.RoundingType").val(),
        PosPluginId: $("#tax\\.PosPluginId").val(),
        WebPluginId: $("#tax\\.WebPluginId").val(),
        Remboursable: $("#tax\\.Remboursable").isChecked(),
        BearedTax: $("#tax\\.BearedTax").isChecked(),
        Exemptible: $("[name='tax-exemptible'][value='YES']").isChecked(),
        ExemptibleExplicit: $("[name='tax-exemptible'][value='EXP']").isChecked(),
        ExemptTagIDs: $("#tax\\.ExemptTagIDs").val(),
        LocationIDs: _getLocations(),
        TaxRateList: []
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
      
      reqDO.Tax.TaxRateList.push(taxRate);
    }
    
    snpAPI.cmd("Product", "SaveTax", reqDO).then(ansDO => entitySaveNotification(<%=LkSNEntityType.Tax.getCode()%>, ansDO.TaxId));
  }
  
});


</script>