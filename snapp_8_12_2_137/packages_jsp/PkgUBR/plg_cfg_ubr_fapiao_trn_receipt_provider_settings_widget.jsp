<%@page import="com.vgs.web.library.BLBO_MetaData"%>
<%@page import="com.vgs.web.library.BLBO_Tag"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="Domain" hint="Externally accessible domain name" mandatory="true">
      <v:input-text field="settings.Domain" placeholder="Ex. http://yourdomain.com:8080"/>
    </v:form-field>
    <v:form-field caption="System channel" hint="Request system channel identification" mandatory="true">
      <v:input-text field="settings.SystemChannel" placeholder="Ex. TKTPOS"/>
    </v:form-field>
    <v:form-field caption="2D Code validity days" hint="Validity days of the 2D code printed on the receipt">
      <v:input-text field="settings.ValidityDays" type="number"/>
    </v:form-field>
    <v:form-field caption="Product tag" hint="Tag used to identify the products that require Fapiao" mandatory="true">
       <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
       <v:combobox field="settings.ProductTagId" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
    </v:form-field>
    <v:form-field caption="Receipt meta field" hint="Meta field used to store the QRCode on the transaction receipt" mandatory="true">
      <% JvDataSet dsMetaField = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:combobox field="settings.ReceiptMetaFieldId" lookupDataSet="<%=dsMetaField%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
  function getPluginSettings() {
    return {
      Domain: $("#settings\\.Domain").val(),
      SystemChannel: $("#settings\\.SystemChannel").val(),
      ValidityDays: $("#settings\\.ValidityDays").val(),
      ProductTagId: $("#settings\\.ProductTagId").val(),
      ReceiptMetaFieldId: $("#settings\\.ReceiptMetaFieldId").val()
    };
  }
</script>