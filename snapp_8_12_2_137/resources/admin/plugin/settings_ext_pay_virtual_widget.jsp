<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_ExtPayVirtual" scope="request"/>


<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:db-checkbox field="settings.SimulateIncAuthAmount" caption="@Common.SimulateIncAuthAmount" value="true"/><br/>
    <v:db-checkbox field="settings.SimulateNoToken" caption="Simulate no token in response" value="true"/><br/>
    <v:db-checkbox field="settings.ShowTokenConfirmation" caption="@Common.ShowTokenConfirmation" value="true"/><br/>
    <v:db-checkbox field="settings.DenyRefundOnExistingCard" caption="Deny refund on same card" value="true"/><br/>
    <v:db-checkbox field="settings.DenyRefundOnDifferentCard" caption="Deny refund on new card" value="true"/><br/><br/>
    <textarea id="settings.ParamData" class="form-control" rows="3" cols="8" placeholder="List of ParamData separated by ';': Offline=Y;DeviceTRNID=DDATTEHHSHSH etc."></textarea>
  </v:widget-block>
</v:widget>

<script>
$("#settings\\.ParamData").val(<%=settings.ParamData.getJsString()%>);

function getPluginSettings() {
  return {
	  SimulateIncAuthAmount: $("#settings\\.SimulateIncAuthAmount").isChecked(),
	  SimulateNoToken: $("#settings\\.SimulateNoToken").isChecked(),
	  ShowTokenConfirmation: $("#settings\\.ShowTokenConfirmation").isChecked(),
	  DenyRefundOnExistingCard: $("#settings\\.DenyRefundOnExistingCard").isChecked(),
	  DenyRefundOnDifferentCard: $("#settings\\.DenyRefundOnDifferentCard").isChecked(),
	  ParamData: $("#settings\\.ParamData").val() 
  };
}
</script>
