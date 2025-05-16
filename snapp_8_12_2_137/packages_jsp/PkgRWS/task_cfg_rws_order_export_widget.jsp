<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>

<%
JvDocument cfg = (JvDocument)request.getAttribute("cfg");
request.setAttribute("cfgftp", cfg.getChildNode("FtpConfig"));
%>

<v:widget caption="@Common.Configuration" id="rws-order-export">
  <v:widget-block>
    <v:form-field caption="Fiscal date" hint="When set, it's the fiscal date the report will be ran on. When not set, \"Fiscal date rule\" will be used. Field will be automatically emptied at each task execution." mandatory="false">
      <v:input-text field="cfg.FixedFiscalDate" type="datepicker" placeholder="Default" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="Fiscal date rule" hint="The Fiscal Date that this report will be run on" mandatory="false">
      <v:lk-combobox field="cfg.FiscalDate" lookup="<%=LkSN.LedgerRegDateTimeRule%>" clazz="rws-field" allowNull="false"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="ENTITY">
      <v:input-text field="cfg.ENTITY" placeholder="RWSPL" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="Payment group" mandatory="true">
      <snp:dyncombo field="cfg.PaymentGroupId" entityType="<%=LkSNEntityType.PaymentGroup%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="BUSINESS_UNIT" hint="Chart of Accounts' Meta Field mapped to BUSINESS_UNIT column" mandatory="true">
      <snp:dyncombo field="cfg.MetaFieldId_BUSINESS_UNIT" entityType="<%=LkSNEntityType.MetaField%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="COST_CENTER" hint="Chart of Accounts' Meta Field mapped to COST_CENTER column" mandatory="true">
      <snp:dyncombo field="cfg.MetaFieldId_COST_CENTER" entityType="<%=LkSNEntityType.MetaField%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="OPERATING_UNIT" hint="Chart of Accounts' Meta Field mapped to OPERATING_UNIT column" mandatory="true">
      <snp:dyncombo field="cfg.MetaFieldId_OPERATING_UNIT" entityType="<%=LkSNEntityType.MetaField%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="SUBCODE" hint="Chart of Accounts' Meta Field mapped to SUBCODE column" mandatory="true">
      <snp:dyncombo field="cfg.MetaFieldId_SUBCODE" entityType="<%=LkSNEntityType.MetaField%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="CASHIER_NAME" hint="User Account's Meta Field mapped to CASHIER_NAME column" mandatory="true">
      <snp:dyncombo field="cfg.MetaFieldId_CASHIER_NAME" entityType="<%=LkSNEntityType.MetaField%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="ACCOUNT_ID" hint="Chart of Accounts' Meta Field mapped to ACCOUNT_ID column" mandatory="true">
      <snp:dyncombo field="cfg.MetaFieldId_ACCOUNT_ID" entityType="<%=LkSNEntityType.MetaField%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="ORDER_ID" hint="Order's Code Alias Type mapped to ORDER_ID column" mandatory="true">
      <snp:dyncombo field="cfg.CodeAliasTypeId_ORDER_ID" entityType="<%=LkSNEntityType.CodeAliasType%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="TRANS_REF_NUM" hint="PaymentData's Param Name mapped to TRANS_REF_NUM column" mandatory="true">
      <v:input-text field="cfg.PaymentDataParam_TRANS_REF_NUM" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="PAYMENT_MERCHANT_ID" hint="PaymentData's Param Name mapped to PAYMENT_MERCHANT_ID column" mandatory="true">
      <v:input-text field="cfg.PaymentDataParam_MERCHANT_ID" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="BANK_PROCESSING_DATE" hint="PaymentData's Param Name mapped to BANK_PROCESSING_DATE column" mandatory="true">
      <v:input-text field="cfg.PaymentDataParam_BANK_DATE" clazz="rws-field"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="FTP Settings">
  <v:widget-block>
    <jsp:include page="/resources/admin/common/ftp_config_widget.jsp"></jsp:include>
  </v:widget-block>
</v:widget>  
  
<script>

function saveTaskConfig(reqDO) {
  var config = $("#rws-order-export").find(".rws-field").viewToDoc();
  config.FtpConfig = getFtpConfig(),
  reqDO.TaskConfig = JSON.stringify(config); 
}

</script>

