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
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_Pay_CreditCard" scope="request"/>

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
    <table class="form-table" >
      <tr>
        <v:form-field field="settings.Authorizer">
          <v:lk-combobox field="settings.Authorizer" lookup="<%=LkSN.AuthorizerType%>" allowNull="false"/>
        </v:form-field>
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block id="authorizer-internal-external" clazz="v-hidden">
    <div id="authorizer-internal" class="v-hidden">
      <v:form-field field="settings.InputMode">
        <v:lk-combobox field="settings.InputMode" lookup="<%=LkSN.CreditCardInputMode%>" allowNull="false"/>
      </v:form-field>
      <v:form-field field="settings.SignatureInputMode">
        <v:lk-combobox field="settings.SignatureInputMode" lookup="<%=LkSN.SignatureInputMode%>" allowNull="true"/>
      </v:form-field>
    </div>
    <v:form-field field="settings.ReceiptTemplateId">
      <v:combobox field="settings.ReceiptTemplateId" lookupDataSetName="dsDocTemplates" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

 
<script>

$(document).ready(function() {
  $("#settings\\.Authorizer").val(<%=settings.Authorizer.getInt()%>);
  enableDisable();
});
  
$("#settings\\.Authorizer").change(enableDisable);

function enableDisable() {
  var inter = $("#settings\\.Authorizer").val();
  $("#authorizer-internal").setClass("v-hidden", inter != 3); 
  $("#authorizer-internal-external").setClass("v-hidden", inter == 1);
}

function getPluginSettings() {
  var aut = $("#settings\\.Authorizer").val();
  var receipt = aut == <%=LkSNAuthorizerType.Manual.getCode()%> ? null : $("#settings\\.ReceiptTemplateId").val();
  var sign = aut == <%=LkSNAuthorizerType.Internal.getCode()%> ? $("#settings\\.SignatureInputMode").val() : null;
  var input = aut == <%=LkSNAuthorizerType.Internal.getCode()%> ? $("#settings\\.InputMode").val() : null;
	
  return {
    Authorizer: aut,
    InputMode: input,
    SignatureInputMode: sign,
    ReceiptTemplateId: receipt
  };
}

</script>
