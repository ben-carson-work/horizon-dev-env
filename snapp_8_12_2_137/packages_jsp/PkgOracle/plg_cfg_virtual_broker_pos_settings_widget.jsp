<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.LkCharset"%>
<%@page import="com.vgs.cl.document.JvDocument"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>
	<div id="opera-settings-virtual-pos">
		<v:widget id="api-settings-pos" caption="API Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
			<v:widget-block>
			  <v:form-field caption="@Common.IPAddress">
			  	<v:input-text field="BindingAddress" placeholder="0.0.0.0 (all addresses)"/>
			  </v:form-field>
			  <v:form-field caption="@Common.HostPort">
			  	<v:input-text field="BindingPort" type="number" placeholder="8443"/>
			  </v:form-field>
			</v:widget-block>
			<v:widget-block>
				<v:db-checkbox field="APISsl" caption="Ssl communication " hint="If checked communication with Opera is secured using ssl" value="true"/>
				<div class="v-hidden upload-file-drop" id="api-ssl-config">
					<v:form-field caption="Certificate file" hint="Drag & drop or select the certificate file to be used to communicate with Opera">
						<v:input-upload-item field="APICertificateFile"/>
	      	</v:form-field>
	    	</div>
			</v:widget-block>
		</v:widget>
		<jsp:include page="opera_client_list_settings.jsp"></jsp:include>
	</div>

<script>
$(document).ready(function() {
  var $cfg = $("#opera-settings-virtual-pos");
  $cfg.find("#APISsl").change(enableDisableSslConfig);
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    
    $cfg.find("#BindingAddress").val(params.settings.BindingAddress);
    $cfg.find("#BindingPort").val(params.settings.BindingPort);
    $cfg.find("#APISsl").prop('checked', params.settings.APISsl);
    if (params.settings.APICertificateFile)
    	$cfg.find("#APICertificateFile").valObject(JSON.stringify(params.settings.APICertificateFile));
    
    doInitializeClientGrid(params);

    enableDisableSslConfig();
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
  	    BindingAddress: $cfg.find("#BindingAddress").val(),
  	    BindingPort: $cfg.find("#BindingPort").val(),
  	    APISsl: $cfg.find("#APISsl").isChecked(),
  	    APICertificateFile: $cfg.find("#APICertificateFile").valObject(),
  	    ClientList: getClientListSettings()
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
  
	function enableDisableSslConfig() {
	  var apiEnable = $cfg.find("#APISsl").isChecked();
	  $("#api-ssl-config").setClass("v-hidden", !apiEnable);
	}
});
</script>
