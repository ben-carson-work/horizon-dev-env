<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
	request.setAttribute("cfgftp", settings.getChildNode("FtpConfig"));
%>

<v:widget caption="Settings" icon="settings.png">
  <v:widget-block>

    <v:form-field caption="@Common.URL" mandatory="true">
      <v:input-text field="settings.Endpoint"/>
    </v:form-field>
    <v:form-field caption="Source phone number" mandatory="true">
      <v:input-text field="settings.PhoneNumberFrom"/>
    </v:form-field>
    <v:form-field caption="Authorization Code" mandatory="true">
      <v:input-text field="settings.AuthCode"/>
    </v:form-field>
    <v:form-field caption="Send as QRCODE">
      <v:db-checkbox field="settings.QrCode" caption="QRCODE" hint="Allow to send images as qrcode instead of plan barcode" value="true"/>
    </v:form-field>
    
  </v:widget-block>
</v:widget>
<v:widget caption="FTP Image Server Configuration">
<v:widget-block>
    <jsp:include page="/resources/admin/common/ftp_config_widget.jsp"></jsp:include>
  </v:widget-block>
</v:widget>
 
<script>

function getPluginSettings() {
  return {
    	Endpoint: $("#settings\\.Endpoint").val(),
      PhoneNumberFrom: $("#settings\\.PhoneNumberFrom").val(),
      AuthCode: $("#settings\\.AuthCode").val(),
      QrCode: $("#settings\\.QrCode").isChecked(),
      FtpConfig: getFtpConfig()
  };
}

</script>