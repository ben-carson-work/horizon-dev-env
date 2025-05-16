<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.web.library.BLBO_Resource"%>
<%@page import="com.vgs.web.library.BLBO_Repository"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>


<v:widget caption="Mobile wallet Apple Settings">
  <v:widget-block>
    <v:db-checkbox caption="Default Configuration" hint="When enabled uses VGS embedded settings. Unflag it to use custom provider settings." field="settings.UseDefaultConfiguration" enabled="true" value="true"/>
	  <div id="cfg-parameters-body">
			<v:form-field caption="Apple Team Id" hint = "Apple Team Id as defined in your Apple developer account">
			  <v:input-text field="settings.TeamId"/>
			</v:form-field>		   
			<v:form-field caption="Pass type identifier" hint = "Apple pass type identifier as defined in your Apple developer account.">
				<v:input-text field="settings.PassTypeIdentifier"/>
			</v:form-field>
			<v:form-field caption="WWDRCA certificate" hint = "Drag & drop or select Apple WWDRCAG4 certificate. (.cer file)">
		      <v:input-upload-item field="settings.WWDRCACertFileBase64"/>
			</v:form-field>
			<v:form-field caption="Mobile wallet certificate" hint = "Drag & drop or selectApple pass certificate as defined in your Apple developer account. (.p12 file)" >
		      <v:input-upload-item field="settings.ETicketCertificateFileBase64"/>
			</v:form-field>
			<v:form-field caption="Keystore password" hint = "Password for Mobile wallet certificate keystore">
			  <v:input-text field="settings.KeyStorePassword" type="password"/>
			</v:form-field>				  
			<v:form-field caption=" VAS Public key" hint = "Drag & drop or select Apple VAS (NFC) public key in compressed format as defined in your Apple developer account. (.pem file)" clazz = 'nevermandatory'>
		      <v:input-upload-item field="settings.VasCertificateFileBase64"/>
			</v:form-field>    				       
	  </div>
   </v:widget-block>
 </v:widget>
      
<script>
$(document).ready(function() {
  
  function refreshVisibility() {
    var isChecked = $('#settings\\.UseDefaultConfiguration').prop('checked');
    
    $('#cfg-parameters-body').toggleClass('v-hidden', isChecked);
    $('#cfg-parameters-body .form-field').not('.nevermandatory').each(function() {
      let $this = $(this);
      $this.attr('data-required', !isChecked);
      $this.find('.form-field-caption').toggleClass('mandatory-field', !isChecked);
    });
  }
  
  refreshVisibility();
  clearCustomFieldsIfNeeded();
  
  $("#settings\\.UseDefaultConfiguration").click(refreshVisibility);
  
  function clearCustomFieldsIfNeeded() {
    //Avoid to show VGS default parameter
    var isChecked = $("#settings\\.UseDefaultConfiguration").isChecked();
    if (isChecked) {
      $("#settings\\.TeamId").val(null);
      $("#settings\\.PassTypeIdentifier").val(null);
      $("#settings\\.KeyStorePassword").val(null);
      $("#settings\\.WWDRCACertFileBase64").val(null);
      $("#settings\\.ETicketCertificateFileBase64").valObject(null);
      $("#settings\\.VasCertificateFileBase64").valObject(null);
    }
  }
});




function getPluginSettings() {
  var ret;
  if ($("#settings\\.UseDefaultConfiguration").isChecked()) {
    ret = {
      UseDefaultConfiguration :  $("#settings\\.UseDefaultConfiguration").isChecked()
      };
  } else {
    ret = {
	    UseDefaultConfiguration :  $("#settings\\.UseDefaultConfiguration").isChecked(),
	    TeamId : $("#settings\\.TeamId").val(),
	    PassTypeIdentifier :  $("#settings\\.PassTypeIdentifier").val(),
	    WWDRCACertFileBase64 : $("#settings\\.WWDRCACertFileBase64").valObject(),
	    KeyStorePassword:  $("#settings\\.KeyStorePassword").val(),
	    ETicketCertificateFileBase64 : $("#settings\\.ETicketCertificateFileBase64").valObject(),
	    VasCertificateFileBase64 : $("#settings\\.VasCertificateFileBase64").valObject()
      };
  }
  return ret;
}
</script>