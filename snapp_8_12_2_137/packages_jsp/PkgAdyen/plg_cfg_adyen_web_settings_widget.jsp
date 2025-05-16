<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="java.util.Locale"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="wpg-adyen-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
  	<v:form-field caption="Api key" mandatory="true">
      <v:input-text field="ApiKey"/>
    </v:form-field>
  	<v:form-field caption="Client key" mandatory="true">
      <v:input-text field="ClientKey" />
    </v:form-field>
  	<v:form-field caption="Url prefix" mandatory="true">
      <v:input-text field="UrlPrefix"/>
    </v:form-field>
		<v:form-field caption="Redirect Url" mandatory="true">
      <v:input-text field="RedirectURL"/>
    </v:form-field>
    <v:form-field caption="Merchant account" mandatory="true">
      <v:input-text field="MerchantAccount"/>
    </v:form-field>
    <v:form-field caption="Country code" hint="The shopper's country code. This is used to filter the list of available payment methods to your shopper.\n Used to set the  shopper's language and country">
			<select id="CountryCode" class="form-control">
			<% for (String country : Locale.getISOCountries()) { %>
				<option value="<%=country%>"><%=new Locale("", country).getDisplayCountry()%></option>
			<% } %>
			</select>
		</v:form-field>
		<v:form-field caption="Test environment" hint="Flag to use Adyen test environment ">
			<v:db-checkbox field="TestEnvironment" caption="@Common.Enable" value="true"/>
	  </v:form-field>
		<v:db-checkbox field="HmacCheck" caption="HMAC signature" hint="Verify the integrity of webhook events using HMAC signatures." value="true"/>
				<div class="v-hidden hmac-check-div" id="hmac-check">
					<v:form-field caption="HMAC key" hint="HMAC key configured on Adyen system">
						<v:input-text field="HMACKey"/>
    			</v:form-field>
	    	</div>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#wpg-adyen-settings");
  $cfg.find("#HmacCheck").change(enableDisableHMAC);

  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#ApiKey").val(params.settings.ApiKey);
    $cfg.find("#ClientKey").val(params.settings.ClientKey);
    $cfg.find("#UrlPrefix").val(params.settings.UrlPrefix);
    $cfg.find("#RedirectURL").val(params.settings.RedirectURL);
    $cfg.find("#MerchantAccount").val(params.settings.MerchantAccount);
    $cfg.find("#CountryCode").val(params.settings.CountryCode);
    $cfg.find("#TestEnvironment").prop('checked', params.settings.TestEnvironment);
    $cfg.find("#HmacCheck").prop('checked', params.settings.HmacCheck);
    $cfg.find("#HMACKey").val(params.settings.HMACKey);

    enableDisableHMAC();
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        ApiKey : 					$cfg.find("#ApiKey").val(),
  			ClientKey : 			$cfg.find("#ClientKey").val(),
  			UrlPrefix : 			$cfg.find("#UrlPrefix").val(),
  			RedirectURL :			$cfg.find("#RedirectURL").val(),
  			MerchantAccount : $cfg.find("#MerchantAccount").val(),
  			CountryCode : 		$cfg.find("#CountryCode").val(),
  			TestEnvironment: 	$cfg.find("#TestEnvironment").isChecked(),
  			HmacCheck: 				$cfg.find("#HmacCheck").isChecked(),
  			HMACKey: 					$cfg.find("#HMACKey").val()
      };
    });
  
  function enableDisableHMAC() {
	  var enabled = $cfg.find("#HmacCheck").isChecked();
	  $("#hmac-check").setClass("v-hidden", !enabled);
	}
  });
</script>