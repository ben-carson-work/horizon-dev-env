<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_PCSC_RFID" scope="request"/>


<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
   <v:widget-block>
	 <v:form-field caption="Reversal read" hint="Read card id in reversal way">
    	<v:db-checkbox field="settings.ReversalRead" caption="@Common.Enable" value="true"/>
    </v:form-field>
   	<v:form-field caption="Keep leading zero" hint="If flaged leading zero won't be removed from read card id">
    	<v:db-checkbox field="settings.KeepLeadingZero" caption="@Common.Enable" value="true"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.FeigRfid.ReadData">
      <v:db-checkbox field="settings.ReadData" caption="@Common.Enabled" value="true"/>
    </v:form-field>
    <v:form-field id="data-read-first-db" caption="@PluginSettings.FeigRfid.FirstDataBlock">
      <v:input-text field="settings.FirstDataBlock"/>
    </v:form-field>
    <v:form-field id="data-read-num-of-bytes" caption="@PluginSettings.FeigRfid.NumberOfBytes">
      <v:input-text field="settings.NumberOfBytes"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
 
 
<script>

$(document).ready(function() {
  enableDisableDataRead();
});

$("#settings\\.ReadData").change(enableDisableDataRead);

function enableDisableDataRead() {
  var enabled = $("#settings\\.ReadData").isChecked();
    $("#data-read-first-db").setClass("v-hidden", !enabled); 
    $("#data-read-num-of-bytes").setClass("v-hidden", !enabled); 
}

function getPluginSettings() {
  return {
    ReadData: $("#settings\\.ReadData").isChecked(),
    ReaderType: $("#settings\\.ReaderType").val(),
    FirstDataBlock: $("#settings\\.FirstDataBlock").val(),
    NumberOfBytes: $("#settings\\.NumberOfBytes").val(),
    ReversalRead: $("#settings\\.ReversalRead").isChecked(),
    KeepLeadingZero: $("#settings\\.KeepLeadingZero").isChecked()
  };
}

</script>
 