<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="pay-adyen-pay-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
	<v:widget-block>
	  <v:alert-box type="info"><b>*QR Paymen method configuration*</b></br></br>
			QR Payment methods have to be configured with an "Alias".</br>
				Alias configured must be reflect the Adyen QR available payment (check values on <a href="https://docs.adyen.com/point-of-sale/qr-code-wallets/#page-introduction">Adyen site</a></br>
				Example of accepted alias are:</br>
				<ul>
					<li>affirm_pos</li>
		    	<li>alipay</li>
		    	<li>alipay_hk</li>
		    	<li>atome_pos</li>
		    	<li>duitnow_pos</li>
		    	<li>paynow_pos</li>
		    	<li>...</li>
	    	</ul>
		</v:alert-box>
		<v:alert-box type="info"><b>*Card brands field configuration*</b></br></br>
				Please refer to (<a href="https://docs.adyen.com/development-resources/paymentmethodvariant">card brands</a>) for the list of possible values 
		</v:alert-box>
  </v:widget-block>
  <v:widget-block>
  	<v:form-field caption="Terminal ip" hint="Payment terminal IP and port to communicate with "  mandatory="true">
      <v:input-text field="EndPoint" placeholder="https://10.1.0.147:8443" />
    </v:form-field>
    <v:form-field caption="Terminal Id" hint="Adyen terminal POIID"  mandatory="true">
      <v:input-text field="TerminalId"  />
    </v:form-field>
		<v:form-field caption="System Id" hint="Your unique ID for the POS system component to send this request from"  mandatory="true">
      <v:input-text field="AdyenSaleId"  />
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
  	<v:db-checkbox field="Encrypting" caption="Encrypted communication " hint="If checked communication with Adyne is secured and encrypted" value="true"/>
		<div class="v-hidden upload-file-drop" id="encrypt-config">
			<v:form-field caption="Certificate file" hint="Drag & drop or select the certificate file to be used to communicate with Adyen">
				<v:input-upload-item field="CertificateFile"/>
     	</v:form-field>
     	<v:form-field caption="Shared key" hint="Shared key configured on Adyen system to manage message encrypting">
      	<v:input-text field="SharedKey" />
    	</v:form-field>
     	<v:form-field caption="Key version">
      	<v:input-text field="KeyVersion" type="number"/>
    	</v:form-field>
     	<v:form-field caption="Key identifier">
      	<v:input-text field="KeyIdentifier"/>
    	</v:form-field>
   	</div>  
	</v:widget-block>
	<v:widget-block>
		<v:form-field caption="@Receipt.ReceiptWidth">
      <v:input-text field="ReceiptWidth" placeholder="42" type="number"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
  	<v:form-field caption="Card brands" hint="List of Adyen card brand separed by comma used to restric accepted card brands.This list will be used only if no alias is specified at payment method level. Due to current issue on Adyen side, at least two values must be inserted">
      <v:input-text field="RestrictCardBrands" placeholder="mc,amex,visa,.."/>
    </v:form-field>
  </v:widget-block>
	<v:widget-block>
		<v:form-field caption="Test" >
      <v:db-checkbox field="TestEnv" caption="Test environment" hint="Select only if Adyen test enviroment is used" value="true"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#pay-adyen-pay-settings");  
  $cfg.find("#Encrypting").change(enableDisableEncryptingConfig);

  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#EndPoint").val(params.settings.EndPoint);
    $cfg.find("#TerminalId").val(params.settings.TerminalId);
    $cfg.find("#AdyenSaleId").val(params.settings.AdyenSaleId);
    $cfg.find("#ReceiptWidth").val(params.settings.ReceiptWidth);
    $cfg.find("#SharedKey").val(params.settings.SharedKey);
    $cfg.find("#KeyVersion").val(params.settings.KeyVersion);
    $cfg.find("#KeyIdentifier").val(params.settings.KeyIdentifier);
    $cfg.find("#RestrictCardBrands").val(params.settings.RestrictCardBrands);
    $cfg.find("#TestEnv").prop('checked', params.settings.TestEnv);
    $cfg.find("#Encrypting").prop('checked', params.settings.Encrypting);
    if (params.settings.CertificateFile)
	    $cfg.find("#CertificateFile").valObject(JSON.stringify(params.settings.CertificateFile));

    enableDisableEncryptingConfig();
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        EndPoint :     		$("#EndPoint").val(),
        TerminalId : 			$("#TerminalId").val(),
        AdyenSaleId : 		$("#AdyenSaleId").val(),
        ReceiptWidth:     $("#ReceiptWidth").val(),
        SharedKey:				$("#SharedKey").val(),
        KeyVersion:				$("#KeyVersion").val(),
        KeyIdentifier:		$("#KeyIdentifier").val(),
        Encrypting: 			$cfg.find("#Encrypting").isChecked(),
  	    CertificateFile: 	$cfg.find("#CertificateFile").valObject(),
        TestEnv:          $("#TestEnv").isChecked(),
        RestrictCardBrands:$("#RestrictCardBrands").val()
      };
    });
  
	function enableDisableEncryptingConfig() {
	  var enabled = $cfg.find("#Encrypting").isChecked();
	  $("#encrypt-config").setClass("v-hidden", !enabled);
	}
  
});
</script>