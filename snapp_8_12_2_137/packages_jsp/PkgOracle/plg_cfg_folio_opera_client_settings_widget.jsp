<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.web.library.BLBO_Tag"%>
<%@page import="com.vgs.cl.document.JvDocument"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="opera-settings-client" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
	<v:widget-block>
		<v:form-field caption="Endpoint URL">
			<v:input-text field="EndPointUrl" placeholder="http://127.0.0.1:8443"/>
		</v:form-field>
		<v:form-field caption="Client ID">
			<v:input-text field="ClientId"/>
		</v:form-field>
		<v:form-field caption="Client Secret">
			<v:input-text field="ClientSecret"/>
		</v:form-field>
		
		<v:form-field caption="Connection timeout (secs)">
		  <v:input-text field="ConnectionTimeout" placeholder="5"/>
		</v:form-field>
		<v:form-field caption="Read timeout (secs)">
		  <v:input-text field="ReadTimeout" placeholder="5"/>
		</v:form-field>
		<v:form-field caption="Local installation">
		  <v:db-checkbox field="Local" caption="Local instance" hint="Identify local installation for Opera communication plugin" value="true"/>
		</v:form-field>
		<v:form-field caption="Unify totals">
		  <v:db-checkbox field="UnifyTaxAndDisc" caption="Unify net total, taxes and discounts" hint="If flag totals are sent to Opera as a unique value: taxes and discounts will be added to the net total itself. Normal beahvior, when not flag, is to send net total, taxes and discount separeted" value="true"/>
		</v:form-field>
		<v:form-field caption="Default total" hint="Defaul total will keep all the products not matching any below tag configuration " >
      <select id="DefaultTotalIdx" class="form-control" onchange="refreshView();">
        <option value=1>Total 1</option>
        <option value=2>Total 2</option>
        <option value=3>Total 3</option>
        <option value=4>Total 4</option>
        <option value=5>Total 5</option>
        <option value=6>Total 6</option>
        <option value=7>Total 7</option>
        <option value=8>Total 8</option>
        <option value=9>Total 9</option>
      </select>        
    </v:form-field>
		<v:form-field caption="Total 1 tags" checkBoxField="Total1Active">
			<% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	 		<v:multibox field="Total1TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
	 	</v:form-field>
		<v:form-field caption="Total 2 tags" checkBoxField="Total2Active">
			<% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	 		<v:multibox field="Total2TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
	 	</v:form-field>
		<v:form-field caption="Total 3 tags" checkBoxField="Total3Active">
			<% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	 		<v:multibox field="Total3TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
	 	</v:form-field>
		<v:form-field caption="Total 4 tags" checkBoxField="Total4Active">
			<% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	 		<v:multibox field="Total4TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
	 	</v:form-field>
		<v:form-field caption="Total 5 tags" checkBoxField="Total5Active">
			<% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	 		<v:multibox field="Total5TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
	 	</v:form-field>
	  <v:form-field caption="Total 6 tags" checkBoxField="Total6Active">
			<% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	 		<v:multibox field="Total6TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
	 	</v:form-field>
		<v:form-field caption="Total 7 tags" checkBoxField="Total7Active">
			<% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	 		<v:multibox field="Total7TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
	 	</v:form-field>
		<v:form-field caption="Total 8 tags" checkBoxField="Total8Active">
			<% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	 		<v:multibox field="Total8TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
	 	</v:form-field>
		<v:form-field caption="Total 9 tags" checkBoxField="Total9Active">
			<% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	 		<v:multibox field="Total9TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
		</v:form-field>
	</v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#opera-settings-client");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#EndPointUrl").val(params.settings.EndPointUrl);
    $cfg.find("#ConnectionTimeout").val(params.settings.ConnectionTimeout);
    $cfg.find("#ReadTimeout").val(params.settings.ReadTimeout);
    $cfg.find("#ClientId").val(params.settings.ClientId);
    $cfg.find("#ClientSecret").val(params.settings.ClientSecret);
    setMultibxoVal($("#Total1TagIDs"), params.settings.Total1TagIDs)
    setMultibxoVal($("#Total2TagIDs"), params.settings.Total2TagIDs)
    setMultibxoVal($("#Total3TagIDs"), params.settings.Total3TagIDs)
    setMultibxoVal($("#Total4TagIDs"), params.settings.Total4TagIDs)
    setMultibxoVal($("#Total5TagIDs"), params.settings.Total5TagIDs)
    setMultibxoVal($("#Total6TagIDs"), params.settings.Total6TagIDs)
    setMultibxoVal($("#Total7TagIDs"), params.settings.Total7TagIDs)
    setMultibxoVal($("#Total8TagIDs"), params.settings.Total8TagIDs)
    setMultibxoVal($("#Total9TagIDs"), params.settings.Total9TagIDs)
    if (params.settings.Total1Active)
      $cfg.find("[name='Total1Active']").click()
    if (params.settings.Total2Active)
      $cfg.find("[name='Total2Active']").click()
    if (params.settings.Total3Active)
      $cfg.find("[name='Total3Active']").click()
    if (params.settings.Total4Active)
      $cfg.find("[name='Total4Active']").click()
    if (params.settings.Total5Active)
      $cfg.find("[name='Total5Active']").click()
    if (params.settings.Total6Active)
      $cfg.find("[name='Total6Active']").click()
    if (params.settings.Total7Active)
      $cfg.find("[name='Total7Active']").click()
    if (params.settings.Total8Active)
      $cfg.find("[name='Total8Active']").click()
    if (params.settings.Total9Active)
      $cfg.find("[name='Total9Active']").click()
    $cfg.find("#Local").prop('checked',params.settings.Local);
    $cfg.find("#UnifyTaxAndDisc").prop('checked',params.settings.UnifyTaxAndDisc);
    $("#DefaultTotalIdx").val(params.settings.DefaultTotalIdx);
    
    refreshView();
  });
  
  function setMultibxoVal($sel, value){
    $sel.attr('data-html', $sel.html());
    $sel.selectize({
      dropdownParent:"body",
      plugins: ['remove_button','drag_drop']
    })[0].selectize.setValue(value, true);
  }
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
      EndPointUrl:            $cfg.find("#EndPointUrl").val(),
      ConnectionTimeout:      _parseInt($cfg.find("#ConnectionTimeout")),
      ReadTimeout:            _parseInt($cfg.find("#ReadTimeout")),
      Local:		              $cfg.find("#Local").isChecked(),
      UnifyTaxAndDisc:		    $cfg.find("#UnifyTaxAndDisc").isChecked(),
      ClientId:		            $cfg.find("#ClientId").val(),
      ClientSecret:		        $cfg.find("#ClientSecret").val(),
	    Total1TagIDs: 					$("#Total1TagIDs").val(),
	    Total2TagIDs: 					$("#Total2TagIDs").val(),
	    Total3TagIDs: 					$("#Total3TagIDs").val(),
	    Total4TagIDs: 					$("#Total4TagIDs").val(),
	    Total5TagIDs: 					$("#Total5TagIDs").val(),
	    Total6TagIDs: 					$("#Total6TagIDs").val(),
	    Total7TagIDs: 					$("#Total7TagIDs").val(),
	    Total8TagIDs: 					$("#Total8TagIDs").val(),
	    Total9TagIDs: 					$("#Total9TagIDs").val(),
      Total1Active:						$cfg.find("[name='Total1Active']").isChecked(),
      Total2Active:						$cfg.find("[name='Total2Active']").isChecked(),
      Total3Active:						$cfg.find("[name='Total3Active']").isChecked(),
      Total4Active:						$cfg.find("[name='Total4Active']").isChecked(),
      Total5Active:						$cfg.find("[name='Total5Active']").isChecked(),
      Total6Active:						$cfg.find("[name='Total6Active']").isChecked(),
      Total7Active:						$cfg.find("[name='Total7Active']").isChecked(),
      Total8Active:						$cfg.find("[name='Total8Active']").isChecked(),
      Total9Active:						$cfg.find("[name='Total9Active']").isChecked(),
      DefaultTotalIdx:				$("#DefaultTotalIdx").val()
    };
  });
  
  function _parseInt($field) {
    var value = getNull($field.val());
    if (value == null)
      return null;
    else {
      var result = parseInt(value);
      if (isNaN(result)) {
        var fieldName = $field.closest(".form-field").find(".form-field-caption").text();
        throw "Invalid value \"" + value + "\" for field \"" + fieldName + "\""
      }
      return result;
    }
  }
});

function refreshView() {
  var checkBoxName = "Total" + $("#DefaultTotalIdx").val() + "Active";
  if ($("#opera-settings-client").find("[name='" + checkBoxName + "']").isChecked())
    $("#opera-settings-client").find("[name='" + checkBoxName + "']").click()
}
</script>
