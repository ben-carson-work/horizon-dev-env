<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
%>

<!-- DOPlugin_WDW_FIPay_CommonConf_Settings -->
<v:widget caption="Folio certificates & keys">
	<v:widget-block>
		<v:form-field caption="Trust certificate collection">
			<textarea name="settings.TrustCertCollection"	id="settings.TrustCertCollection" class="form-control" rows="15" cols="10" placeholder="Paste certificate collection here"></textarea>
		</v:form-field>
	</v:widget-block>
	<v:widget-block>
		<v:form-field caption="Client certificate">
			<textarea name="settings.ClientCert" id="settings.ClientCert" class="form-control" rows="15" cols="10" placeholder="Paste certificate here"></textarea>
		</v:form-field>
	</v:widget-block>
	<v:widget-block>
		<v:form-field caption="Private key">
			<textarea name="settings.PrivateKey" id="settings.PrivateKey"	class="form-control" rows="15" cols="10" placeholder="Paste key here"></textarea>
		</v:form-field>
	</v:widget-block>
</v:widget>


<script>
	function getPluginSettings() {
		return {
			TrustCertCollection : $("#settings\\.TrustCertCollection").val(),
			ClientCert : $("#settings\\.ClientCert").val(),
			PrivateKey : $("#settings\\.PrivateKey").val()
		};
	}
	
	$("#settings\\.TrustCertCollection").val(<%=settings.getChildField("TrustCertCollection").getJsString()%>);
	$("#settings\\.ClientCert").val(<%=settings.getChildField("ClientCert").getJsString()%>);
	$("#settings\\.PrivateKey").val(<%=settings.getChildField("PrivateKey").getJsString()%>);
</script>

