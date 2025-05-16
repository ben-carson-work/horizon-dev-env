<%@ page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.BLBO_Tag"%>
<%@page import="com.vgs.cl.document.JvDocument"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>

<v:widget caption="@Common.Configuration">
  <v:widget-block>
    <v:alert-box type="info">The purpose of this task is to load Horizon transactions into Eraad system</v:alert-box>
  </v:widget-block>
  <v:widget-block>
  <v:form-field caption="Transaction date" hint="Identify the fiscal date to be processed, if valued only the transaction done at that date will be processed otherwise the today transactions will be processed">
      <v:input-text type="datepicker" field="cfg.ProcessingDate"/>
    </v:form-field>
	</v:widget-block>
  <v:widget-block>
		<v:form-field caption="Api Key" hint="Security communication API key"  mandatory="true">
	  	<v:input-text field="cfg.ApiKey"/>
	  </v:form-field>
  </v:widget-block>
	<v:widget-block>
 		<v:form-field caption="Voucher EndPoint Url"  mandatory="true">
	    <v:input-text field="cfg.VoucherEndPoint"/>
	  </v:form-field>
		<v:form-field caption="Receipt EndPoint Url"  mandatory="true">
	    <v:input-text field="cfg.ReceiptEndPoint"/>
	  </v:form-field>
	  <v:form-field caption="Entity Type" hint="Entity Type code to identify the service provider initating the acquisition process"  mandatory="true">
	  	<v:input-text field="cfg.EPayEntityTypeCode"/>
	  </v:form-field>
	  <v:form-field caption="Source Code" hint="Service Provider source system requesting the this process"  mandatory="true">
	  	<v:input-text field="cfg.EpayMsgSourceCode"/>
	  </v:form-field>
	  <v:form-field caption="Service Code" mandatory="true">
	  	<v:input-text field="cfg.EPayServiceCode"/>
	  </v:form-field>
	  <v:form-field caption="Entry ledger Alias" hint="Entry ticket ledger Alias as required by Erad message"  mandatory="true">
	  	<v:input-text field="cfg.LedgerAliasEntry"/>
	  </v:form-field>
	  <v:form-field caption="Addons ledger Alias" hint="Addons ledger Alias as required by Erad message"  mandatory="true">
	  	<v:input-text field="cfg.LedgerAliasAddOns"/>
	  </v:form-field>
	  <v:form-field caption="Others ledger Alias" hint="Other ticket ledger Alias as required by Erad message"  mandatory="true">
	  	<v:input-text field="cfg.LedgerAliasOthers"/>
	  </v:form-field>
	  <v:form-field caption="Taxes ledger Alias" hint="Taxes ledger Alias as required by Erad message"  mandatory="true">
	  	<v:input-text field="cfg.LedgerAliasTax"/>
	  </v:form-field>
		<v:form-field caption="Secret code" mandatory="true">
	  	<v:input-text field="cfg.SecretCode"/>
	  </v:form-field>
	  <v:form-field caption="Entry product tags" mandatory="true" hint="tags used to identify entry products">
	 		<v:multibox field="cfg.EntryTags" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType)%>" idFieldName="TagId" captionFieldName="TagName"/>
	 	</v:form-field>
	  <v:form-field caption="Add on tags" hint="tags used to identify add on products">
	 		<v:multibox field="cfg.AddOnTags" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType)%>" idFieldName="TagId" captionFieldName="TagName"/>
	 	</v:form-field>
  </v:widget-block>
</v:widget>
<script>

function saveTaskConfig(reqDO) {
  var config ={
      ProcessingDate				:  getNull($("#cfg\\.ProcessingDate-picker").getXMLDate()),
      ApiKey      					: $("#cfg\\.ApiKey").val(),
      VoucherEndPoint 			: $("#cfg\\.VoucherEndPoint").val(),
      ReceiptEndPoint 			: $("#cfg\\.ReceiptEndPoint").val(),
      EPayEntityTypeCode 		: $("#cfg\\.EPayEntityTypeCode").val(),
      EpayMsgSourceCode 		: $("#cfg\\.EpayMsgSourceCode").val(),
      EPayServiceCode 			: $("#cfg\\.EPayServiceCode").val(),
      LedgerAliasEntry 			: $("#cfg\\.LedgerAliasEntry").val(),
      LedgerAliasAddOns 		: $("#cfg\\.LedgerAliasAddOns").val(),
      LedgerAliasOthers 		: $("#cfg\\.LedgerAliasOthers").val(),
      LedgerAliasTax 				: $("#cfg\\.LedgerAliasTax").val(),
      SecretCode						: $("#cfg\\.SecretCode").val(),
      EntryTags							: $("#cfg\\.EntryTags").val(),
      AddOnTags							: $("#cfg\\.AddOnTags").val(),
  };
  
  reqDO.TaskConfig = JSON.stringify(config);
}
</script>
