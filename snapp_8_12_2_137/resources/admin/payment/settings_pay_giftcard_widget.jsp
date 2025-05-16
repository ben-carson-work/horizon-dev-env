<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePayMethod" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_Pay_GiftCard" scope="request"/>

<%
  QueryDef qdef = new QueryDef(QryBO_DocTemplate.class);
  // Select
  qdef.addSelect(QryBO_DocTemplate.Sel.IconName);
  qdef.addSelect(QryBO_DocTemplate.Sel.DocTemplateId);
  qdef.addSelect(QryBO_DocTemplate.Sel.DocTemplateName);
  qdef.addSelect(QryBO_DocTemplate.Sel.DriverCount);
  // Where
  qdef.addFilter(QryBO_DocTemplate.Fil.DocTemplateType, LkSNDocTemplateType.CCReceipt.getCode());
  // Sort
  qdef.addSort(QryBO_DocTemplate.Sel.DocTemplateName);
  // Exec
  JvDataSet dsDocTemplates = pageBase.execQuery(qdef);
  pageBase.getReq().setAttribute("dsDocTemplates", dsDocTemplates);
  
%>

<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:form-field caption="@Payment.ReceiptTemplate">
      <v:combobox field="settings.ReceiptTemplateId" lookupDataSetName="dsDocTemplates" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

 
<script>
function getPluginSettings() {
  return {
    ReceiptTemplateId: $("#settings\\.ReceiptTemplateId").val()
  };
}

</script>
