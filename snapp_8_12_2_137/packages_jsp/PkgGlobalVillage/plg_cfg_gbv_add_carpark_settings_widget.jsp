<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNDriverType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Operation URL" hint="URL used for methods \"getCardsByWildcardSearch\" and \"getPMstring\" " mandatory="true">
      <v:input-text field="settings.OperationURL"/>
    </v:form-field>
    <v:form-field caption="Cashpoint URL" hint="URL used for method \"getCardInfo\"" mandatory="true">
      <v:input-text field="settings.CashpointURL"/>
    </v:form-field>
    <v:form-field caption="@Common.UserName" mandatory="true">
      <v:input-text field="settings.Username"/>
    </v:form-field>
    <v:form-field caption="@Common.Password" mandatory="true">
      <v:input-text field="settings.Password" type="password"/>
    </v:form-field>
    <v:form-field caption="@Common.TerminalId" mandatory="true">
      <v:input-text field="settings.TerminalId"/>
    </v:form-field>
    <v:form-field caption="Product Tags" hint="All products with the specified product tags will trigger the plugin functionality" mandatory="true">
      <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
      <v:multibox field="settings.ProductTagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
    </v:form-field>          
    
  </v:widget-block>
</v:widget>


<script>

function getPluginSettings() {
  return {
	  OperationURL: $("#settings\\.OperationURL").val(),
	  CashpointURL: $("#settings\\.CashpointURL").val(),
	  Username: $("#settings\\.Username").val(),
	  Password: $("#settings\\.Password").val(),
	  TerminalId: $("#settings\\.TerminalId").val(),
	  ProductTagIDs: $("#settings\\.ProductTagIDs").val()
  };
}

</script>

