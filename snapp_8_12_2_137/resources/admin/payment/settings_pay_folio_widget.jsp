<%@page import="com.vgs.web.library.*"%>
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
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_Pay_Folio" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_DocTemplate.class)
    .addFilter(QryBO_DocTemplate.Fil.DocTemplateType, LkSNDocTemplateType.PaymentReceipt.getCode())
    .addSort(QryBO_DocTemplate.Sel.DocTemplateName)
    .addSelect(
        QryBO_DocTemplate.Sel.IconName,
        QryBO_DocTemplate.Sel.DocTemplateId,
        QryBO_DocTemplate.Sel.DocTemplateName,
        QryBO_DocTemplate.Sel.DriverCount);

JvDataSet dsDocTemplates = pageBase.execQuery(qdef);
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
     <v:db-checkbox caption="@Payment.RestrictFolioClients" field="cbRestrictPayMethods" value="true" checked="<%=!settings.FolioClientIDs.isEmpty()%>" />
     <div id="paymethod-container" class="hidden" style="margin-top:5px">
          <% JvDataSet dsFolioClients = pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.FolioClient); %>
          <v:multibox 
          		field="settings.FolioClientIDs" 
          		lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.FolioClient)%>" 
          		idFieldName="PluginId" 
          		captionFieldName="PluginDisplayName" 
          		linkEntityType="<%=LkSNEntityType.Plugin%>"/>
     </div>
    <v:form-field field="settings.ReceiptTemplateId">
      <v:combobox field="settings.ReceiptTemplateId" lookupDataSet="<%=dsDocTemplates%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
<script>

$(document).ready(function() {
  $("#cbRestrictPayMethods").click(refreshVisibility);
  refreshVisibility();
});

function refreshVisibility() {
  $("#paymethod-container").setClass("hidden", !$("#cbRestrictPayMethods").isChecked());
 }

function getPluginSettings() {
  return {
    FolioClientIDs: getPaymentMethods(),
    ReceiptTemplateId: $("#settings\\.ReceiptTemplateId").val()
  };
  
  function getPaymentMethods() {
    if ($("#cbRestrictPayMethods").isChecked())
      return $("#settings\\.FolioClientIDs")[0].selectize.getValue();
    else
      return [];
  }
}

</script>
