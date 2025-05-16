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
    <v:form-field caption="Payment method" hint="Used as a main filter over transaction's payments to produce the export" mandatory="true">
      <snp:dyncombo field="cfg.PaymentMethodId" entityType="<%=LkSNEntityType.PaymentMethod%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="AR_CODE" hint="Reservation owner's Meta Field mapped to AR_CODE column" mandatory="true">
      <snp:dyncombo field="cfg.MetaFieldId_ARCODE" entityType="<%=LkSNEntityType.MetaField%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="CUSTOMER_PO_NUM" hint="Order survey's Meta Field mapped to CUSTOMER_PO_NUM column" mandatory="true">
      <snp:dyncombo field="cfg.MetaFieldId_CUSTPO" entityType="<%=LkSNEntityType.MetaField%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="BME_ORDER_NUMBER" hint="Order's Code Alias Type mapped to BME_ORDER_NUMBER column" mandatory="true">
      <snp:dyncombo field="cfg.CodeAliasTypeId_BME" entityType="<%=LkSNEntityType.CodeAliasType%>" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="LINKORD" hint="Order's Code Alias Type mapped to NOTES_254 column" mandatory="true">
      <snp:dyncombo field="cfg.CodeAliasTypeId_LINKORD" entityType="<%=LkSNEntityType.CodeAliasType%>" clazz="rws-field"/>
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

