<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings");
boolean manualRetrieveSession = settings.getChildField("ManualRetrieveSession").getBoolean();
boolean forceManualOnTimeout = settings.getChildField("ForceManualOnTimeout").getBoolean();
boolean checkedApprovedTrnOnly = settings.getChildField("PrintReceiptApprovedTrnOnly").isUndefined() || settings.getChildField("PrintReceiptApprovedTrnOnly").isNull() || settings.getChildField("PrintReceiptApprovedTrnOnly").getBoolean();
boolean checkedVoid = settings.getChildField("PrintReceiptForVoid").isUndefined() || settings.getChildField("PrintReceiptForVoid").isNull() || settings.getChildField("PrintReceiptForVoid").getBoolean();

String retriesHint = 
"Number of times that POS should retry if a failure occurs</br>" +  
"while trying to retrieve the payment status and details from</br>" +  
"APP (unknown error, no response or malformed response,</br>" +
"timeout exceeded, etc), 0 means retries disabled";

String pollingHint = 
  "Number of seconds for POS to wait before try (or retry)</br>" +
  "to retrieve the payment status and details from APP";

String timeoutHint = 
  "Number of seconds after which the retrieve session polling should stop";
      
String manualRetrieveHint = 
"When checked, polling to retrieve payment status will not</br>" +  
"start and operator will be presented with a button in POS to</br>" +  
"perform the retrieval";
      
String forceManualOnTimeoutHint = 
"When checked, if timeout happens on polling, SnApp</br>" +  
"will allow cashier to manually try one last time to</br>" +  
"perform the retrieval";        
        
%>

<v:widget caption="General settings">
	<v:widget-block>
    <v:form-field caption="@Receipt.ReceiptWidth">
	    <v:input-text field="settings.ReceiptWidth" placeholder="42"/>
	  </v:form-field>   
	  <v:db-checkbox field="settings.PrintReceiptApprovedTrnOnly" caption="Print receipt for approved transactions only" value="true" checked="<%=checkedApprovedTrnOnly%>" /><br/>
	  <v:db-checkbox field="settings.PrintReceiptForVoid" caption="Print receipt for void transactions" value="true" checked="<%=checkedVoid%>" />
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
  </v:widget-block>
</v:widget>

<v:widget caption="APP">
  <v:widget-block>
    <v:form-field caption="Client Id" hint="When empty, client ID is inherited from \"External payment terminal ID\" topology parameter">
      <v:input-text field="settings.APP_ClientId" placeholder='Inherited from "External payment terminal ID" topology parameter'/>
    </v:form-field>
    <v:form-field caption="Client Cert Alias">
      <v:input-text field="settings.APP_ClientCertAlias"/>
    </v:form-field>
    <v:form-field caption="Private key" >
      <v:input-txtarea field="settings.APP_PrivateKey" rows="10"/>
    </v:form-field>
    <v:form-field caption="Search client ID" hint="Alternative client ID to be used when searching transactions by card">
      <v:input-text field="settings.APP_SearchClientId"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Retries on error" hint="<%=retriesHint%>">
      <v:input-text field="settings.APPUIRetries" placeholder="0"/>
    </v:form-field>
    <v:db-checkbox field="settings.ManualRetrieveSession" caption="Disable retrieve session polling" hint="<%=manualRetrieveHint%>" value="true" checked="<%=manualRetrieveSession%>" /><br/>
    <div id="polling-config">
      <v:form-field caption="Retrieve session polling (secs)" hint="<%=pollingHint%>">
        <v:input-text field="settings.RetrieveSessionPolling" placeholder="5"/>
      </v:form-field>
      <v:form-field caption="Retrieve session timeout (secs)" hint="<%=timeoutHint%>">
        <v:input-text field="settings.RetrieveSessionTimeout" placeholder="60"/>
      </v:form-field>
      <v:form-field>
        <v:db-checkbox field="settings.ForceManualOnTimeout" caption="Allow manual retrieve on timeout" hint="<%=forceManualOnTimeoutHint%>" value="true" checked="<%=forceManualOnTimeout%>" />
      </v:form-field>
    </div>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Encryption certificate" hint="Certificate used to encrypt gift/reward cards">
    <textarea name="settings.Certificate" id="settings.Certificate" class="form-control" rows="15" cols="10" placeholder="Paste certificate here"></textarea>
    </v:form-field>
  </v:widget-block> 
</v:widget>

<v:widget caption="Establish session">
  <v:widget-block>
    <v:form-field caption="URL" >
      <v:input-text field="settings.EstablishSession_URL"/>
    </v:form-field>
    <v:form-field caption="AuthZ scope">
      <v:input-text field="settings.EstablishSession_AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Get session by token">
  <v:widget-block>
    <v:form-field caption="URL" >
      <v:input-text field="settings.GetSessionByToken_URL"/>
    </v:form-field>
    <v:form-field caption="AuthZ scope">
      <v:input-text field="settings.GetSessionByToken_AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Update session">
  <v:widget-block>
    <v:form-field caption="URL" >
      <v:input-text field="settings.UpdateSession_URL"/>
    </v:form-field>
    <v:form-field caption="AuthZ scope">
      <v:input-text field="settings.UpdateSession_AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Cancel payment">
  <v:widget-block>
    <v:form-field caption="URL" >
      <v:input-text field="settings.CancelPayment_URL"/>
    </v:form-field>
    <v:form-field caption="AuthZ scope">
      <v:input-text field="settings.CancelPayment_AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Process refund">
  <v:widget-block>
    <v:form-field caption="URL" >
      <v:input-text field="settings.ProcessRefund_URL"/>
    </v:form-field>
    <v:form-field caption="AuthZ scope">
      <v:input-text field="settings.ProcessRefund_AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Void refund">
  <v:widget-block>
    <v:form-field caption="URL" >
      <v:input-text field="settings.VoidRefund_URL"/>
    </v:form-field>
    <v:form-field caption="AuthZ scope">
      <v:input-text field="settings.VoidRefund_AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Get gift/reward card balance">
  <v:widget-block>
    <v:form-field caption="URL" >
      <v:input-text field="settings.BalanceInquery_URL"/>
    </v:form-field>
    <v:form-field caption="AuthZ scope">
      <v:input-text field="settings.BalanceInquery_AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function refreshConfig() {
  var manualRetrieveSession = $("#settings\\.ManualRetrieveSession").isChecked();
  $("#polling-config").setClass("hidden", manualRetrieveSession);
}

function getPluginSettings() {
  var config = {
		  AuthZ_URL: $("#settings\\.AuthZ_URL").val(),
		  AuthZ_ClientId: $("#settings\\.AuthZ_ClientId").val(),
		  AuthZ_ClientSecret: $("#settings\\.AuthZ_ClientSecret").val(),
		  
		  APP_ClientId: $("#settings\\.APP_ClientId").val(),
		  APP_ClientCertAlias: $("#settings\\.APP_ClientCertAlias").val(),
		  APP_PrivateKey: $("#settings\\.APP_PrivateKey").val(),
		  
		  APP_SearchClientId: $("#settings\\.APP_SearchClientId").val(),
		  
		  ReceiptWidth: $("#settings\\.ReceiptWidth").val(),
      PrintReceiptApprovedTrnOnly: $("#settings\\.PrintReceiptApprovedTrnOnly").isChecked(),
	    PrintReceiptForVoid: $("#settings\\.PrintReceiptForVoid").isChecked(),
		  
		  ManualRetrieveSession: $("#settings\\.ManualRetrieveSession").isChecked(),
		  RetrieveSessionPolling: $("#settings\\.RetrieveSessionPolling").val(),
		  RetrieveSessionTimeout: $("#settings\\.RetrieveSessionTimeout").val(),
		  ForceManualOnTimeout: $("#settings\\.ForceManualOnTimeout").isChecked(),
		  APPUIRetries: $("#settings\\.APPUIRetries").val(),
		  
		  Certificate: $("#settings\\.Certificate").val(),
		  
		  EstablishSession_URL: $("#settings\\.EstablishSession_URL").val(),
		  EstablishSession_AuthZ_Scope: $("#settings\\.EstablishSession_AuthZ_Scope").val(),
		  
		  GetSessionByToken_URL: $("#settings\\.GetSessionByToken_URL").val(),
		  GetSessionByToken_AuthZ_Scope: $("#settings\\.GetSessionByToken_AuthZ_Scope").val(),
		 
		  UpdateSession_URL: $("#settings\\.UpdateSession_URL").val(),
		  UpdateSession_AuthZ_Scope: $("#settings\\.UpdateSession_AuthZ_Scope").val(),
      
      CancelPayment_URL: $("#settings\\.CancelPayment_URL").val(),
      CancelPayment_AuthZ_Scope: $("#settings\\.CancelPayment_AuthZ_Scope").val(),
      
      ProcessRefund_URL: $("#settings\\.ProcessRefund_URL").val(),
      ProcessRefund_AuthZ_Scope: $("#settings\\.ProcessRefund_AuthZ_Scope").val(),
      
      VoidRefund_URL: $("#settings\\.VoidRefund_URL").val(),
      VoidRefund_AuthZ_Scope: $("#settings\\.VoidRefund_AuthZ_Scope").val(),
      
      BalanceInquery_URL: $("#settings\\.BalanceInquery_URL").val(),
      BalanceInquery_AuthZ_Scope: $("#settings\\.BalanceInquery_AuthZ_Scope").val()
  };
  return config;
}

$("#settings\\.ManualRetrieveSession").change(refreshConfig);
$("#settings\\.Certificate").val(<%=settings.getChildField("Certificate").getJsString()%>);
refreshConfig();

</script>