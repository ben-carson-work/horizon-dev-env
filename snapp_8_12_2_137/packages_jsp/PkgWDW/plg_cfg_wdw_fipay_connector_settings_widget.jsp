<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
boolean enforceSSL = settings.getChildField("EnforceSSL").getBoolean();
boolean ignorePAXDevice = settings.getChildField("IgnorePAXDevice").getBoolean();
boolean watchdog = settings.getChildField("Watchdog").getBoolean();
boolean manualRetrieveSession = settings.getChildField("ManualRetrieveSession").getBoolean();
boolean forceManualOnTimeout = settings.getChildField("ForceManualOnTimeout").getBoolean();

boolean sendAPPUIFraudElements = settings.getChildField("SendAPPUIFraudElements").getBoolean();
boolean checkedApprovedTrnOnly = settings.getChildField("PrintReceiptApprovedTrnOnly").isUndefined() || settings.getChildField("PrintReceiptApprovedTrnOnly").isNull() || settings.getChildField("PrintReceiptApprovedTrnOnly").getBoolean();
boolean checkedVoid = settings.getChildField("PrintReceiptForVoid").isUndefined() || settings.getChildField("PrintReceiptForVoid").isNull() || settings.getChildField("PrintReceiptForVoid").getBoolean();

String retriesHint = 
  "Number of times that POS should retry if a failure occurs</br>" +  
  "while trying to retrieve the payment status and details from</br>" +  
  "FIPay (unknown error, no response or malformed response,</br>" +
  "timeout exceeded, etc), 0 means retries disabled";
  
String pollingHint = 
    "Number of seconds for POS to wait before try (or retry)</br>" +
    "to retrieve the payment status and details from FIPay";

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

<!-- DOPlugin_WDW_FIPay_Connector_Settings -->
<v:widget caption="Connector settings">
  <v:widget-block>
    <v:db-checkbox field="settings.EnforceSSL" caption="SSL / TLS1.2" value="true" checked="<%=enforceSSL%>" /><br/>
    <v:form-field caption="Server IP" mandatory="true">
      <v:input-text field="settings.ServerURL"/>
    </v:form-field>
    <v:form-field caption="@Common.ServerPort" mandatory="true">
      <v:input-text field="settings.ServerPort"/>
    </v:form-field>
    <v:form-field caption="@Auth.RequestTimeoutSec">
      <v:input-text field="settings.POSReqTimeout" placeholder="90"/>
    </v:form-field>
    <v:form-field caption="FIPay message timeout (secs)">
      <v:input-text field="settings.FIPayTimeout" placeholder="60"/>
    </v:form-field>
  </v:widget-block>  
  <v:widget-block>
    <v:db-checkbox field="settings.Watchdog" caption="Watchdog" value="true" checked="<%=watchdog%>" /><br/>
    <div id="watchdog-config">
      <v:form-field caption="Frequency (secs)">
        <v:input-text field="settings.WatchdogFreq" placeholder="60"/>
      </v:form-field>
      <v:form-field caption="Timeout (secs)">
        <v:input-text field="settings.WatchdogTimeout" placeholder="5"/>
      </v:form-field>  
    </div>
  </v:widget-block>	    
  <v:widget-block>
    <v:form-field caption="Encryption certificate" hint="Certificate used to encrypt credit/debit gift/reward cards manually inserted">
    <textarea name="settings.Certificate" id="settings.Certificate" class="form-control" rows="15" cols="10" placeholder="Paste certificate here"></textarea>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Common settings">
  <v:widget-block>
    <v:form-field caption="@PluginSettings.FIPay.StoreNumber" mandatory="true">
      <v:input-text field="settings.StoreNumber"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.FIPay.TerminalNumber" mandatory="true">
      <v:input-text field="settings.TerminalNumber"/>
    </v:form-field>
    <v:form-field caption="Search client ID" hint="Alternative client ID to be used when searching transactions by card">
      <v:input-text field="settings.SearchClientID"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:db-checkbox field="settings.IgnorePAXDevice" caption="Ignore PAX device" value="true" checked="<%=ignorePAXDevice%>" /><br/>
    <div id="pax-config">
      <v:form-field caption="Guest device">
        <select name="settings.GuestDevice" id="settings.GuestDevice" class="form-control">
          <option value="Left">Left</option>
          <option value="Right">Right</option>
        </select>
      </v:form-field>
      <v:form-field caption="Cast member device">
        <select name="settings.CastMemberDevice" id="settings.CastMemberDevice" class="form-control">
          <option value="Left">Left</option>
          <option value="Right">Right</option>
        </select>
      </v:form-field>
    </div>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Receipt.ReceiptWidth">
      <v:input-text field="settings.ReceiptWidth" placeholder="42"/>
    </v:form-field>
    <v:form-field caption="Signature confirmation" >
      <v:lk-combobox lookup="<%=LkSN.SignatureConfirmationType%>" field="settings.SignatureConfirmationType" allowNull="false"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>    
    <v:db-checkbox field="settings.PrintReceiptApprovedTrnOnly" caption="Print receipt for approved transactions only" value="true" checked="<%=checkedApprovedTrnOnly%>" /><br/>
    <v:db-checkbox field="settings.PrintReceiptForVoid" caption="Print receipt for void transactions" value="true" checked="<%=checkedVoid%>" />
  </v:widget-block>
  <v:widget-block>    
    <v:form-field caption="Disable cancel on payment (secs)" hint="When configured, cancel button on payments is disabled for specified seconds. Zero means always enabled." mandatory="false">
      <v:input-text field="settings.CancelEnableTimeout" placeholder="30"/>
    </v:form-field>
  </v:widget-block>
 
</v:widget>

<v:widget caption="APP UI settings">  
  <v:widget-block>
    <v:db-checkbox field="settings.SendAPPUIFraudElements" caption="Send fraud elements to APP UI" value="true" checked="<%=sendAPPUIFraudElements%>" />
    <v:form-field caption="Retries on error" hint="<%=retriesHint%>">
      <v:input-text field="settings.APPUIRetries" placeholder="0"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
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
</v:widget>

<v:widget caption="Folio settings">
  <v:widget-block>
    <v:form-field caption="Folio charge URL" mandatory="true">
      <v:input-text field="settings.FolioCharge_URL"/>
    </v:form-field>
    <v:form-field caption="Pms Folio charge URL" mandatory="true">
      <v:input-text field="settings.PmsFolioCharge_URL"/>
    </v:form-field>
    <v:form-field caption="Pms Folio refund URL" mandatory="true">
      <v:input-text field="settings.PmsFolioRefund_URL"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="AuthZ settings">
  <v:widget-block>
    <v:form-field caption="AuthZ service URL" mandatory="true">
      <v:input-text field="settings.AuthZ_URL"/>
    </v:form-field>
    <v:form-field caption="Client Id" mandatory="true">
      <v:input-text field="settings.AuthZ_ClientId"/>
    </v:form-field>
    <v:form-field caption="Client secret" mandatory="true">
      <v:input-text field="settings.AuthZ_ClientSecret" type="password"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function refreshConfig() {
	var watchdog = $("#settings\\.Watchdog").isChecked();
  $("#watchdog-config").setClass("hidden", !watchdog);
	
	var ignorePAXDevice = $("#settings\\.IgnorePAXDevice").isChecked();
  $("#pax-config").setClass("hidden", ignorePAXDevice);
  
  var manualRetrieveSession = $("#settings\\.ManualRetrieveSession").isChecked();
  $("#polling-config").setClass("hidden", manualRetrieveSession);

}

function getPluginSettings() {
	var watchdog = $("#settings\\.Watchdog").isChecked();
  return {
	  EnforceSSL: $("#settings\\.EnforceSSL").isChecked(),
    ServerURL: $("#settings\\.ServerURL").val(),
    ServerPort: $("#settings\\.ServerPort").val(),
    POSReqTimeout: $("#settings\\.POSReqTimeout").val(),
    FIPayTimeout: $("#settings\\.FIPayTimeout").val(),
    Watchdog: watchdog,
    WatchdogFreq: watchdog ? $("#settings\\.WatchdogFreq").val() : null,
    WatchdogTimeout: watchdog ? $("#settings\\.WatchdogTimeout").val() : null,
    Certificate: $("#settings\\.Certificate").val(),
    StoreNumber: $("#settings\\.StoreNumber").val(),
    TerminalNumber: $("#settings\\.TerminalNumber").val(),
    SearchClientID: $("#settings\\.SearchClientID").val(),
    IgnorePAXDevice: $("#settings\\.IgnorePAXDevice").isChecked(),    
    GuestDevice: $("#settings\\.GuestDevice").val(),
    CastMemberDevice: $("#settings\\.CastMemberDevice").val(),
    AllowedCards: $("#settings\\.RestrictCardTypes").isChecked() ? $("#restrict-card-config").find("[name='accepted-cards']:checked").val() : "",
    ReceiptWidth: $("#settings\\.ReceiptWidth").val(),
    SignatureConfirmationType: $("#settings\\.SignatureConfirmationType").val(),
    PrintReceiptApprovedTrnOnly: $("#settings\\.PrintReceiptApprovedTrnOnly").isChecked(),
    PrintReceiptForVoid: $("#settings\\.PrintReceiptForVoid").isChecked(),
    CancelEnableTimeout: $("#settings\\.CancelEnableTimeout").val(),
    SendAPPUIFraudElements: $("#settings\\.SendAPPUIFraudElements").isChecked(),
    ManualRetrieveSession: $("#settings\\.ManualRetrieveSession").isChecked(),
    RetrieveSessionPolling: $("#settings\\.RetrieveSessionPolling").val(),
    RetrieveSessionTimeout: $("#settings\\.RetrieveSessionTimeout").val(),
    ForceManualOnTimeout: $("#settings\\.ForceManualOnTimeout").isChecked(),
    APPUIRetries: $("#settings\\.APPUIRetries").val(),
    FolioCharge_URL: $("#settings\\.FolioCharge_URL").val(),
    PmsFolioCharge_URL: $("#settings\\.PmsFolioCharge_URL").val(),
    PmsFolioRefund_URL: $("#settings\\.PmsFolioRefund_URL").val(),
    AuthZ_URL: $("#settings\\.AuthZ_URL").val(),
    AuthZ_ClientId: $("#settings\\.AuthZ_ClientId").val(),
    AuthZ_ClientSecret: $("#settings\\.AuthZ_ClientSecret").val()
  };
}

$("#settings\\.Watchdog").change(refreshConfig);
$("#settings\\.IgnorePAXDevice").change(refreshConfig);
$("#settings\\.ManualRetrieveSession").change(refreshConfig);
$("#settings\\.Certificate").val(<%=settings.getChildField("Certificate").getJsString()%>);
$("#settings\\.GuestDevice").val(<%=settings.getChildField("GuestDevice").getJsString()%>);
$("#settings\\.CastMemberDevice").val(<%=settings.getChildField("CastMemberDevice").getJsString()%>);

refreshConfig();

</script>

