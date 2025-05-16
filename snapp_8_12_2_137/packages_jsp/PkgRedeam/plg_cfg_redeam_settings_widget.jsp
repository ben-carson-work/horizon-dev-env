<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field clazz="redeam-field" caption="APIKey" hint="Key used to verify inbound calls. Provided or agreed with Redeam.">
      <v:input-text field="settings.APIKey"/>
    </v:form-field>
    <v:form-field clazz="redeam-field" caption="APISecret" hint="Secret used to verify inbound calls. Provided or agreed with Redeam.">
      <v:input-text field="settings.APISecret"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field clazz="redeam-field" caption="Code alias type" hint="Used to track Redeam hold/order UUID on SnApp orders">
      <snp:dyncombo field="settings.CreateBookingUuid_CodeAliasTypeId" entityType="<%=LkSNEntityType.CodeAliasType%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Channel API" hint="API provided by Redeam for which SnApp acts as client.\nProvides list of available resellers/OTAs and accept product-to-reseller mapping.">
  <v:widget-block>
    <v:form-field clazz="redeam-field" caption="Endpoint" hint="Redeam's Channel API endpoint. Provided by Redeam.">
      <v:input-text field="settings.ChannelEndpoint"/>
    </v:form-field>
    <v:form-field clazz="redeam-field" caption="APIKey" hint="Key used to sign channel calls. Provided by Redeam.">
      <v:input-text field="settings.ChannelAPIKey"/>
    </v:form-field>
    <v:form-field clazz="redeam-field" caption="APISecret" hint="Secret used to channel calls. Provided by Redeam.">
      <v:input-text field="settings.ChannelAPISecret"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Field mapping">
  <v:widget-block>
    <v:form-field clazz="redeam-field" caption="Void reason" hint="Will be attached to order-void transactions">
      <snp:dyncombo field="settings.VoidReason_MetaFieldId" entityType="<%=LkSNEntityType.MetaField%>"/>
    </v:form-field>
    <v:form-field clazz="redeam-field" caption="Void reason details" hint="Will be attached to order-void transactions">
      <snp:dyncombo field="settings.VoidReasonDetail_MetaFieldId" entityType="<%=LkSNEntityType.MetaField%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Resellers">
  <v:widget-block>
    <v:button id="btn-redeam-refresh-resellers" caption="Reload" fa="sync-alt" title="Call Readem Channel API and update resellers list"/>
  </v:widget-block>
  <v:widget-block style="max-height:200px; overflow-y:auto">
    <table id="redeam-reseller-table" style="width:100%">
    </table>
  </v:widget-block>
</v:widget>

<style>
#redeam-reseller-table td {padding: 5px; border-bottom: 1px solid var(--border-color);}
</style>

<script>
var redeamSettings = <%=((JvDocument)request.getAttribute("settings")).getJSONString()%>;

function getPluginSettings() {
  redeamSettings.APIKey = $("#settings\\.APIKey").val();
  redeamSettings.APISecret = $("#settings\\.APISecret").val();
  redeamSettings.CreateBookingUuid_CodeAliasTypeId = $("#settings\\.CreateBookingUuid_CodeAliasTypeId").val();
  redeamSettings.ChannelEndpoint = $("#settings\\.ChannelEndpoint").val();
  redeamSettings.ChannelAPIKey = $("#settings\\.ChannelAPIKey").val();
  redeamSettings.ChannelAPISecret = $("#settings\\.ChannelAPISecret").val();
  redeamSettings.VoidReason_MetaFieldId = $("#settings\\.VoidReason_MetaFieldId").val();
  redeamSettings.VoidReasonDetail_MetaFieldId = $("#settings\\.VoidReasonDetail_MetaFieldId").val();
  return redeamSettings;
}

$(document).ready(function() {
  _refreshResellers(redeamSettings.ResellerList);
  
  var channelSettingsChanged = false;
  $(".redeam-field").change(function() {
    channelSettingsChanged = true;
  });
  
  $("#btn-redeam-refresh-resellers").click(function() {
    if (channelSettingsChanged) {
      $(this).setEnabled(false);
      showMessage("Settings have changed. Please save and retry.");
    }
    else {
      showWaitGlass();
      vgsService("REDEAM", {Command:"UpdateResellers"}, false, function(ansDO) {
        hideWaitGlass();
        var resellers = (((ansDO || {}).Answer || {}).UpdateResellers || {}).ResellerList;
        redeamSettings.ResellerList = resellers;
        _refreshResellers(resellers);
      });
    }
  });
  
  function _refreshResellers(resellers) {
    var $table = $("#redeam-reseller-table");
    $table.empty();
    
    if (resellers) {
      for (var i=0; i<resellers.length; i++) {
        var reseller = resellers[i];
        var $tr = $("<tr></tr>").appendTo($table);
        $("<td></td>").appendTo($tr).text(reseller.ResellerExtCode);
        $("<td></td>").appendTo($tr).text(reseller.ResellerName);
      }
    } 
  }
});

</script>
