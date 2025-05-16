<%@page import="com.vgs.cl.JvDateTime"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.cl.document.JvDocument"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pkg" class="com.vgs.snapp.dataobject.DOExtensionPackage" scope="request"/>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
JvDocument cfg = (JvDocument)request.getAttribute("cfg");
%>

<v:widget caption="VMS Settings">
	<v:widget-block>
		<v:form-field caption="Meta Field" hint="Meta Field where imported VMS Types are stored" mandatory="true">
			<snp:dyncombo field="rsw-config-MetaFieldId" entityType="<%=LkSNEntityType.MetaField%>" />
		</v:form-field>
	</v:widget-block>
	<v:widget-block>
		<v:form-field caption="Server URL">
			<v:input-text field="rsw-config-ServerURL" placeholder="ie: https://stagentapi.rwsentosa.com" />
		</v:form-field>
		<v:form-field caption="System ID">
			<v:input-text field="rsw-config-SystemId" />
		</v:form-field>
		<v:form-field caption="User name">
			<v:input-text field="rsw-config-AuthUserName" />
		</v:form-field>
		<v:form-field caption="Pre shared key">
			<v:input-text field="rsw-config-AuthPresharedKey" type="password" />
		</v:form-field>
	</v:widget-block>
</v:widget>

<script>
$(document).ready( function(){
	let doc = <%=pkg.ConfigDoc.getString()%>;
	doc = (doc) ? doc : {};

	$("#rsw-config-ServerURL").val(doc.ServerURL);
	$("#rsw-config-SystemId").val(doc.SystemId);
	$("#rsw-config-AuthUserName").val(doc.AuthUserName);
	$("#rsw-config-AuthPresharedKey").val(doc.AuthPresharedKey);
	$("#rsw-config-MetaFieldId").val(doc.MetaFieldId);
	
});

function getExtensionPackageConfigDoc() {
	let result =  {
		MetaFieldId : $("#rsw-config-MetaFieldId").val(),
		ServerURL : $("#rsw-config-ServerURL").val(),
		SystemId : $("#rsw-config-SystemId").val(),
		AuthUserName : $("#rsw-config-AuthUserName").val(),
		AuthPresharedKey : $("#rsw-config-AuthPresharedKey").val(),
		LastUpdate: "<%=pageBase.getDBTimestamp()%>"
	}
	return result;
}
</script>
