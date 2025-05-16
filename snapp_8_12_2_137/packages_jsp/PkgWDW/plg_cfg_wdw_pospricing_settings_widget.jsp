<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings");
boolean checkCacheFirst = settings.getChildField("CheckCacheFirst").isUndefined() || settings.getChildField("CheckCacheFirst").isNull() || settings.getChildField("CheckCacheFirst").getBoolean();
boolean simulateRequest = settings.getChildField("SimulateRequest").getBoolean();
        
String simulateRequestHint = 
  "When checked, SnApp will not call Disney's priging plugin</br>" +  
  "and will return a generic $106.50 price (tax included $6.50)</br>" +  
  "for all products and valid for one day";

%>

<v:widget caption="Settings">
  <v:widget-block>
    <v:db-checkbox field="settings.SimulateRequest" caption="Simulate request to pricing plugin" hint="<%=simulateRequestHint%>" value="true" checked="<%=simulateRequest%>" /><br/>
  </v:widget-block>
</v:widget>

<v:widget caption="Refund on downgrades">
  <v:widget-block>
    <v:form-field caption="Allowed roles">
      <v:multibox field="settings.RefundOnDowngradeRoleIDs" linkEntityType="<%=LkSNEntityType.Role%>" filtersJSON="{\"Role\":{\"RoleType\":0,\"ActiveOnly\":true}}"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Service endpoint config">
  <v:widget-block>
    <v:form-field caption="Quote service URL" >
      <v:input-text field="settings.Quote_URL"/>
    </v:form-field>
    <v:form-field caption="Mod service URL" >
      <v:input-text field="settings.Mod_URL"/>
    </v:form-field>
    <v:form-field caption="Decode service URL" >
      <v:input-text field="settings.Decode_URL"/>
    </v:form-field>
    <v:form-field caption="Catalog service URL" >
      <v:input-text field="settings.Catalog_URL"/>
    </v:form-field>
    <v:form-field caption="Connection timeout (secs)" >
      <v:input-text field="settings.ConnectionTimeout" placeholder="5"/>
    </v:form-field>
    <v:form-field caption="Read timeout (secs)" >
      <v:input-text field="settings.ReadTimeout" placeholder="5"/>
    </v:form-field>
    <v:form-field caption="Max messages" >
      <v:input-text field="settings.MaxMessages" placeholder="1"/>
    </v:form-field>
    <v:form-field caption="Max connections" >
      <v:input-text field="settings.MaxConnections" placeholder="10"/>
    </v:form-field>
    <v:form-field caption="Cache file path" >
      <v:input-text field="settings.CacheFilePath"/>
    </v:form-field>
    <v:form-field caption="Cache file start" >
      <v:input-text field="settings.CacheFileStart" placeholder="0"/>
    </v:form-field>
    <v:form-field caption="Cache file end" >
      <v:input-text field="settings.CacheFileEnd" placeholder="0"/>
    </v:form-field>
    <v:form-field>
      <v:db-checkbox field="settings.CheckCacheFirst" caption="Check cache first" hint="Utilize the offline cache prior to call online core api pricing service" value="true" checked="<%=checkCacheFirst%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="AuthZ settings">
  <v:widget-block>
    <v:form-field caption="AuthZ service URL" >
      <v:input-text field="settings.AuthZ_URL"/>
    </v:form-field>
    <v:form-field caption="Client Id">
      <v:input-text field="settings.AuthZ_ClientId"/>
    </v:form-field>
    <v:form-field caption="Client secret">
      <v:input-text field="settings.AuthZ_ClientSecret" type="password"/>
    </v:form-field>
    <v:form-field caption="Scope">
      <v:input-text field="settings.AuthZ_Scope"/>
    </v:form-field>
    <v:form-field caption="Connection timeout (secs)">
      <v:input-text field="settings.AuthZ_ConnectionTimeout" placeholder="10"/>
    </v:form-field>
    <v:form-field caption="Read timeout (secs)">
      <v:input-text field="settings.AuthZ_ReadTimeout" placeholder="10"/>
    </v:form-field>
    <v:form-field caption="Max retries">
      <v:input-text field="settings.AuthZ_MaxRetries" placeholder="3"/>
    </v:form-field>
  </v:widget-block>
</v:widget>


<script>
function getPluginSettings() {
  return {
	  SimulateRequest: $("#settings\\.SimulateRequest").isChecked(),
	  RefundOnDowngradeRoleIDs : $("#settings\\.RefundOnDowngradeRoleIDs").val(),
    Quote_URL: $("#settings\\.Quote_URL").val(),
    Mod_URL: $("#settings\\.Mod_URL").val(),
    Decode_URL: $("#settings\\.Decode_URL").val(),
    Catalog_URL: $("#settings\\.Catalog_URL").val(),
    ConnectionTimeout: $("#settings\\.ConnectionTimeout").val(),
    ReadTimeout: $("#settings\\.ReadTimeout").val(),
    MaxMessages: $("#settings\\.MaxMessages").val(),
    MaxConnections: $("#settings\\.MaxConnections").val(),
    CacheFilePath: $("#settings\\.CacheFilePath").val(),
    CacheFileStart: $("#settings\\.CacheFileStart").val(),
    CacheFileEnd: $("#settings\\.CacheFileEnd").val(),
    CheckCacheFirst: $("#settings\\.CheckCacheFirst").isChecked(),
    AuthZ_URL: $("#settings\\.AuthZ_URL").val(),
    AuthZ_ClientId: $("#settings\\.AuthZ_ClientId").val(),
    AuthZ_ClientSecret: $("#settings\\.AuthZ_ClientSecret").val(),
    AuthZ_Scope: $("#settings\\.AuthZ_Scope").val(),
    AuthZ_ConnectionTimeout: $("#settings\\.AuthZ_ConnectionTimeout").val(),
    AuthZ_ReadTimeout: $("#settings\\.AuthZ_ReadTimeout").val(),
    AuthZ_MaxRetries: $("#settings\\.AuthZ_MaxRetries").val()
	};
}
</script>