<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block >
    <v:form-field caption="@PluginSettings.IsADR301.Sound">
      <v:db-checkbox field="settings.Sound" caption="@Common.Enabled" value="true"/>
    </v:form-field>
    <v:form-field caption="Barcode reader" hint="When flaged barcode reader function wiil be disabled on the reader">
      <v:db-checkbox field="settings.BarcodeDisabled" caption="@Common.Disabled" value="true"/>
    </v:form-field>
    <v:form-field caption="Passport reader" hint="When flaged passport reader function wiil be disabled on the reader">
      <v:db-checkbox field="settings.PassportDisabled" caption="@Common.Disabled" value="true"/>
    </v:form-field>
    <v:form-field caption="Read delay" hint="Delay in millisecs. to prevent same media read to be trigger to be validate, values less than three seconds are ignored">
    	<v:input-text field="settings.SameMediaDelay" type="number"/>
  	</v:form-field>
  <v:form-field caption="@PluginSettings.IsADR301.ChinaIdReader">
    <v:db-checkbox field="settings.ChinaIdReaderEnable" caption="@Common.Enabled" value="true"/>
  </v:form-field>
 </v:widget-block>
 <v:widget-block id="interface-type-combo">

    <v:form-field caption="Idle reader loop frequency"  hint="Frequency for GovID reader idel loop in milleseonds, default value is 500">
      <v:input-text field="settings.ReaderNoCardLoopFrequency" placeholder="500"/>
    </v:form-field>

    <v:form-field caption="Good Reader loop frequency"  hint="Frequency for GovID reader loop after a good read in milleseonds, default value is 100">
      <v:input-text field="settings.ReaderGoodReadLoopFrequency" placeholder="100"/>
    </v:form-field>
    
    <v:form-field caption="@Common.Type">
      <select id="settings.InterfaceType" class="form-control">
        <option value=1>Serial</option>
        <option value=2>USB</option>
      </select>        
    </v:form-field>

    <div  id="interface-serial" class="v-hidden">
    <v:form-field caption="@Common.PortName">
      <select id="settings.ChinaIdReaderPort" class="form-control">
      <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
        <% String com = comPort.getDescription(); %>
        <% String value = comPort.getCode() + "";%>
        <% String sel = JvString.isSameText(value, settings.getChildField("ChinaIdReaderPort").getString()) ? "selected" : ""; %>
        <option value="<%=value%>" <%=sel%>><%=com%></option>
      <% } %>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.Baudrate">
      <v:lk-combobox lookup="<%=LkSN.BaudRate%>" field="settings.ChinaIdReaderBaud"/>
    </v:form-field>
    </div>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  $("#settings\\.InterfaceType").val(<%=settings.getChildField("InterfaceType").getInt()%>);
  enableDisableChinaIdReader();
  enableDisableInterface();
});

$("#settings\\.ChinaIdReaderEnable").change(enableDisableChinaIdReader);
$("#settings\\.InterfaceType").change(enableDisableInterface);


function enableDisableInterface() {
  var inter = $("#settings\\.InterfaceType").val();
  $("#interface-serial").setClass("v-hidden", !((inter == 1) && $("#settings\\.ChinaIdReaderEnable").isChecked())); 
}

function enableDisableChinaIdReader() {
  var enabled = $("#settings\\.ChinaIdReaderEnable").isChecked();
  $("#interface-type-combo").setClass("v-hidden", !enabled); 
  enableDisableInterface();
}

function getPluginSettings() {
  return {
    InterfaceType: $("#settings\\.InterfaceType").val(),
    Sound: $("#settings\\.Sound").isChecked(),
    ChinaIdReaderEnable: $("#settings\\.ChinaIdReaderEnable").isChecked(),
    ChinaIdReaderPort: $("#settings\\.ChinaIdReaderPort").val(),
    ChinaIdReaderBaud: $("#settings\\.ChinaIdReaderBaud").val(),
    ReaderNoCardLoopFrequency: $("#settings\\.ReaderNoCardLoopFrequency").val(),
    ReaderGoodReadLoopFrequency: $("#settings\\.ReaderGoodReadLoopFrequency").val(),
    SameMediaDelay: $("#settings\\.SameMediaDelay").val(),
    BarcodeDisabled: $("#settings\\.BarcodeDisabled").isChecked(),
    PassportDisabled: $("#settings\\.PassportDisabled").isChecked()
  };
}

</script> 