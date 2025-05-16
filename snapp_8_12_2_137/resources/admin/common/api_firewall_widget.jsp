<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
String entityId = pageBase.getNullParameter("EntityId");
LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"));
DOApiFirewall cfg = pageBase.getBL(BLBO_ApiFirewall.class).loadApiFirewall(entityType, entityId, true, false);
DOApiFirewall inh = pageBase.getBL(BLBO_ApiFirewall.class).loadApiFirewall(entityType, entityId, false, true);
request.setAttribute("cfg", cfg);
request.setAttribute("inh", inh);

boolean showServiceFilter = true;
if (entityType.isLookup(LkSNEntityType.Workstation)) {
  LookupItem workstationType = SrvBO_Cache_Station.instance().getStationById(entityId).workstationType; 
  showServiceFilter = LkSNWorkstationType.is3Party(workstationType);
}
%>

<style>
.inherit-info {
  text-decoration: underline;
  margin-bottom: 10px;
}
.command-label {
  display: inline-block;
  background: #e0e0e0;
  padding: 4px 6px 4px 6px;
  border-radius: 4px;
}
</style>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" href="javascript:doSaveApiFirewall()"/>
</div>
  
<div class="tab-content">
  <v:widget caption="@System.ApiFirewall_AddressTitle">
    <v:widget-block>
      <v:db-checkbox field="cfg.CustomAddressRange" value="true" caption="@System.ApiFirewall_UseCustomRules" onclick="doEnableDisable()"/><br/>
      <v:db-checkbox field="cbApplyAddressRange" value="true" caption="@System.ApiFirewall_AddressRestrictions" onclick="doEnableDisable()"/>
    </v:widget-block>
    <v:widget-block id="specific-address-all" clazz="v-hidden">
      <i><v:itl key="@System.ApiFirewall_NoRestrictions"/></i>
    </v:widget-block>
    <v:widget-block id="specific-address-container" clazz="v-hidden">
      <v:grid>
        <thead>
          <tr>
            <td><v:grid-checkbox header="true"/></td>
            <td width="50%">From IP address</td>
            <td width="50%">To IP address</td>
          </tr>
        </thead>
        <tbody id="address-tbody">
        </tbody>
        <tbody>
          <tr>
            <td colspan="100%">
              <v:button caption="@Common.Add" fa="plus" href="javascript:doAddAddress()"/>
              <v:button caption="@Common.Remove" fa="minus" href="javascript:doRemoveAddresses()"/>
            </td>
          </tr>
        </tbody>
      </v:grid>
    </v:widget-block>
    <v:widget-block id="inherit-address-container" clazz="v-hidden">
      <% if (!inh.InheritAddressEntityId.isNull()) { %>
        <div class="inherit-info">Rules inherited from: <snp:entity-link entityId="<%=inh.InheritAddressEntityId%>" entityType="<%=inh.InheritAddressEntityType%>"><%=inh.InheritAddressEntityName.getHtmlString()%></snp:entity-link></div>
      <% } %>
      <% if (inh.AddressList.isEmpty()) { %>
        <i><v:itl key="@System.ApiFirewall_NoRestrictions"/></i>
      <% } else { %>
        <% for (DOApiFirewall.DOApiFirewallAddress adr : inh.AddressList) { %>
          <%=adr.FromIP.getHtmlString()%> &rarr; <%=adr.ToIP.getHtmlString()%><br/>
        <% } %>
      <% } %>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="@System.ApiFirewall_ServiceTitle">
  <% if (!showServiceFilter) { %>
    <v:widget-block>
      <v:itl key="@System.ApiFirewall_WksNotApplicable"/>
    </v:widget-block>
  <% } else {%>
    <v:widget-block>
      <v:db-checkbox field="cfg.CustomServiceFilter" value="true" caption="@System.ApiFirewall_UseCustomRules" onclick="doEnableDisable()"/><br/>
      <v:db-checkbox field="cbApplyServiceFilter" value="true" caption="@System.ApiFirewall_ServiceRestrictions" onclick="doEnableDisable()"/>
    </v:widget-block>
    <v:widget-block id="specific-service-all" clazz="v-hidden">
      <i><v:itl key="@System.ApiFirewall_NoRestrictions"/></i>
    </v:widget-block>
    <v:widget-block id="specific-service-container" clazz="v-hidden">
      <div id="service-template" class="v-hidden">
        <select class="combo-service form-control"><option/>
        <% for (String service : Service2Manager.getCmdList(null)) { %>
          <option><%=JvString.escapeHtml(service)%></option>
        <% } %>
        </select>
      </div>
      <% for (String service : Service2Manager.getCmdList(null)) { %>
        <div class="command-template v-hidden" data-ServiceName="<%=JvString.escapeHtml(service)%>">
          <select class="combo-command" multiple>
          <% for (String command : Service2Manager.getCommandList(service)) { %>
            <option value="<%=JvString.escapeHtml(command)%>"><%=JvString.escapeHtml(command)%></option>
          <% } %>
          </select>
        </div>
      <% } %>
      <v:grid>
        <thead>
          <tr>
            <td><v:grid-checkbox header="true"/></td>
            <td width="25%">Service</td>
            <td width="75%">Commands</td>
          </tr>
        </thead>
        <tbody id="service-tbody">
        </tbody>
        <tbody>
          <tr>
            <td colspan="100%">
              <v:button caption="@Common.Add" fa="plus" href="javascript:doAddService()"/>
              <v:button caption="@Common.Remove" fa="minus" href="javascript:doRemoveServices()"/>
            </td>
          </tr>
        </tbody>
      </v:grid>
    </v:widget-block>
    <v:widget-block id="inherit-service-container" clazz="v-hidden">
      <% if (!inh.InheritServiceEntityId.isNull()) { %>
        <div class="inherit-info">Rules inherited from: <snp:entity-link entityId="<%=inh.InheritServiceEntityId%>" entityType="<%=inh.InheritServiceEntityType%>"><%=inh.InheritServiceEntityName.getHtmlString()%></snp:entity-link></div>
      <% } %>
      <% if (inh.ServiceList.isEmpty()) { %>
        <i><v:itl key="@System.ApiFirewall_NoRestrictions"/></i>
      <% } else { %>
        <v:grid>
          <thead>
            <tr>
              <td width="25%">Service</td>
              <td width="75%">Commands</td>
            </tr>
          </thead>
          <tbody>
          <% for (DOApiFirewall.DOApiFirewallService srv : inh.ServiceList) { %>
            <tr class="grid-row">
              <td><%=srv.ServiceName.getHtmlString()%></td>
              <td>
              <% if (srv.CommandNames.isEmpty()) { %>
                <i>- <v:itl key="@Common.All" transform="uppercase"/> -</i>
              <% } else { %>
                <% for (String commandName : srv.CommandNames.getArray()) { %>
                  <div class="command-label"><%=JvString.escapeHtml(commandName)%></div>
                <% } %>
              <% } %>
              </td>
            </tr>
          <% } %>
          </tbody>
        </v:grid>
      <% } %>
    </v:widget-block>
  <% } %>
  </v:widget>

<script>
$(document).ready(function() {
  var dlg = $("#api_firewall_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Save" encode="JS"/>: doSaveApiFirewall,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
  <% if (cfg.CustomAddressRange.getBoolean() && !cfg.AddressList.isEmpty()) { %>
    $("#cbApplyAddressRange").setChecked(true);
    <% for (DOApiFirewall.DOApiFirewallAddress adr : cfg.AddressList) { %>
      doAddAddress(<%=adr.FromIP.getJsString()%>, <%=adr.ToIP.getJsString()%>);
    <% } %>
  <% } %>
  
  <% if (cfg.CustomServiceFilter.getBoolean() && !cfg.ServiceList.isEmpty()) { %>
    $("#cbApplyServiceFilter").setChecked(true);
    <% for (DOApiFirewall.DOApiFirewallService adr : cfg.ServiceList) { %>
      doAddService(<%=adr.ServiceName.getJsString()%>, <%=adr.CommandNames.getJsString()%>);
    <% } %>
  <% } %>
  
  doEnableDisable();
});

function doEnableDisable() {
  var customAddress = $("#cfg\\.CustomAddressRange").isChecked();
  var applyAddress = $("#cbApplyAddressRange").isChecked();
  $("#cbApplyAddressRange").closest(".checkbox-label").setClass("v-hidden", !customAddress);
  $("#specific-address-all").setClass("v-hidden", !(customAddress && !applyAddress));
  $("#specific-address-container").setClass("v-hidden", !customAddress || !applyAddress);
  $("#inherit-address-container").setClass("v-hidden", customAddress);
  
  var customService = $("#cfg\\.CustomServiceFilter").isChecked();
  var applyService = $("#cbApplyServiceFilter").isChecked();
  $("#cbApplyServiceFilter").closest(".checkbox-label").setClass("v-hidden", !customService);
  $("#specific-service-all").setClass("v-hidden", !(customService && !applyService));
  $("#specific-service-container").setClass("v-hidden", !customService || !applyService);
  $("#inherit-service-container").setClass("v-hidden", customService);
}

function doAddAddress(fromIP, toIP) {
  var tr = $("<tr/>").appendTo("#address-tbody");
  var tdCB = $("<td><input type='checkbox' class='cblist'/></td>").appendTo(tr);
  var tdFrom = $("<td><input type='text' class='txt-fromip form-control'/></td>").appendTo(tr);
  var tdTo = $("<td><input type='text' class='txt-toip form-control'/></td>").appendTo(tr);

  tdFrom.find("input").val(fromIP);
  tdTo.find("input").val(toIP);
  
  if (!(fromIP) && !(toIP))
    tdFrom.find("input").focus();
}

function doRemoveAddresses() {
  $("#address-tbody .cblist:checked").closest("tr").remove();
}

function doAddService(serviceName, commandNames) {
  var tr = $("<tr/>").appendTo("#service-tbody");
  var tdCB = $("<td><input type='checkbox' class='cblist'/></td>").appendTo(tr);
  var tdService = $("<td/>").appendTo(tr);
  var tdCommand = $("<td class='td-command'/>").appendTo(tr);
  
  tdService.html($("#service-template").html());
  if (serviceName)
    tdService.find("select").val(serviceName);
  tdService.find("select").change(function() {
    recalcCommandCombo($(this), null);
  });
  
  if (serviceName)
    recalcCommandCombo(tdService.find("select"), commandNames);
  else
    tdService.find("select").focus();
}

function doRemoveServices() {
  $("#service-tbody .cblist:checked").closest("tr").remove();
}

function recalcCommandCombo(serviceCombo, commandNames) {
  var serviceName = serviceCombo.val();
  var template = $(".command-template[data-ServiceName='" + serviceName + "']");
  var tdCommand = serviceCombo.closest("tr").find(".td-command");
  tdCommand.html(template.html());
  
  var sel = tdCommand.find("select").selectize({
    dropdownParent: "body",
    plugins: ["remove_button","drag_drop"]
  });
  
  if (commandNames)
    sel[0].selectize.setValue(commandNames);
}

function doSaveApiFirewall() {
  var reqDO = {
    Command: "SaveApiFirewall",
    SaveApiFirewall: {
      ApiFirewall: {
        EntityType: <%=entityType.getCode()%>,
        EntityId: <%=JvString.jsString(entityId)%>,
        CustomAddressRange: $("#cfg\\.CustomAddressRange").isChecked(),
        CustomServiceFilter: $("#cfg\\.CustomServiceFilter").isChecked(),
        AddressList: [],
        ServiceList: []
      }
    }
  };
  
  if ($("#cbApplyAddressRange").isChecked()) {
    $("#address-tbody tr").each(function(index, tr) {
      tr = $(tr);
      var fromIP = tr.find(".txt-fromip").val().trim();
      var toIP = tr.find(".txt-toip").val().trim();
      if ((fromIP != "") && (toIP != "")) {
        reqDO.SaveApiFirewall.ApiFirewall.AddressList.push({
          FromIP: fromIP,
          ToIP: toIP
        });
      }
    });
  }
  
  if ($("#cbApplyServiceFilter").isChecked()) {
    $("#service-tbody tr").each(function(index, tr) {
      tr = $(tr);
      var serviceName = tr.find(".combo-service").val();
      if (serviceName != "") {
        reqDO.SaveApiFirewall.ApiFirewall.ServiceList.push({
          ServiceName: serviceName,
          CommandNames: tr.find(".combo-command")[0].selectize.getValue()
        });
      }
    });
  }
  
  vgsService("ApiFirewall", reqDO, false, function(ansDO) {
    showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>, function() {
      window.location.reload();
    });
  });
}
</script>

</div>