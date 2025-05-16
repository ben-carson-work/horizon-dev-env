<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pkg" class="com.vgs.snapp.dataobject.DOExtensionPackage" scope="request"/>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<v:widget caption="VIP outbound message config">
  <v:widget-block>
		<v:form-field caption="VIP pack codes" hint="List of VIP package product codes (comma separated) for the \"VIP Activation Event\" Messages. Messagaes will be sent only for selled product types defined here." mandatory="true">
      <v:input-text field="gbv-config-VipProductCodes"/>
    </v:form-field>
    <v:form-field caption="B2B MetaDataCode" hint="MetaDataCode used to identify B2B order that should be processed by \"B2B Sales Order\" outbout message. Only sales with this MetaData valued will be proessed." mandatory="true">
      <v:input-text field="gbv-config-PaymentMethodMetaFieldCode"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var doc = <%=pkg.ConfigDoc.getString()%>;
  doc = (doc) ? doc : {};
  $("#gbv-config-VipProductCodes").val(doc.VipProductCodes);
  $("#gbv-config-PaymentMethodMetaFieldCode").val(doc.PaymentMethodMetaFieldCode);
});

function getExtensionPackageConfigDoc() {
  return {
    VipProductCodes: $("#gbv-config-VipProductCodes").val(),
    PaymentMethodMetaFieldCode: $("#gbv-config-PaymentMethodMetaFieldCode").val()
  };
}
</script>