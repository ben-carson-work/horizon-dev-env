<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>


<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<%
  boolean credit = JvString.isSameString("1", settings.getChildField("AllowedCards").getString());
  boolean gift = JvString.isSameString("2,3", settings.getChildField("AllowedCards").getString());
  boolean restrictCardTypes = JvString.getNull(settings.getChildField("AllowedCards").getString()) != null ? true : false;
%>	      
	    
<!-- DOPlugin_WDW_FIPay_Payment_Settings -->
<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="@PluginSettings.FIPay.DeviceConnector" mandatory="true">
      <v:combobox field="settings.DeviceConnectorPluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(plugin.WorkstationId.getString(), LkSNDriverType.DeviceConnector)%>" allowNull="false" idFieldName="PluginId" captionFieldName="DriverName"/>
	  </v:form-field>
	</v:widget-block>
  <v:widget-block>
    <v:db-checkbox field="settings.RestrictCardTypes" caption="Restrict card types" value="true" checked="<%=restrictCardTypes%>"/><br/><br/>
    <div id="restrict-card-config">
      <label><input type="radio" name="accepted-cards" id="accepted-credit" value="1" checked>Credit/Debit cards</label>&nbsp;&nbsp;&nbsp;
      <label><input type="radio" name="accepted-cards" id="accepted-gift" value="2,3">Gift/Reward cards</label>
    </div>
  </v:widget-block>
  <v:widget-block>
    <v:db-checkbox field="settings.DenyRefundOnDifferentCard" caption="Deny refund on new card" hint="When checked, refund on new card is not allowed" value="true"/><br/><br/>
  </v:widget-block>
</v:widget>


<script>
function refreshConfig() {
	var restrictCardTypes = $("#settings\\.RestrictCardTypes").isChecked();
	$("#restrict-card-config").setClass("hidden", !restrictCardTypes);
	$("#accepted-credit").prop('checked', <%=credit%>);
  $("#accepted-gift").prop('checked', <%=gift%>);
}

function getPluginSettings() {
  return {
	  DeviceConnectorPluginId: $("#settings\\.DeviceConnectorPluginId").val(),
	  DenyRefundOnDifferentCard: $("#settings\\.DenyRefundOnDifferentCard").isChecked(),
	  AllowedCards: $("#settings\\.RestrictCardTypes").isChecked() ? $("#restrict-card-config").find("[name='accepted-cards']:checked").val() : ""
  };
}

$("#settings\\.RestrictCardTypes").change(refreshConfig);

refreshConfig();

</script>

