<%@page import="com.vgs.web.library.BLBO_DataSource"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageOutboundCfg" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
int[] defaultStatusFilter = LookupManager.getIntArray(LkSNOutboundMessageStatus.Active, LkSNOutboundMessageStatus.Disabled);

QueryDef qdef = new QueryDef(QryBO_Plugin.class);
qdef.addSelect(QryBO_Plugin.Sel.PluginId, QryBO_Plugin.Sel.PluginDisplayName);
qdef.addFilter(QryBO_Plugin.Fil.DriverType, LkSNDriverType.OutboundBroker.getCode());
JvDataSet dsPlugin = pageBase.execQuery(qdef);
%>

<% if (!pageBase.getRights().QueueInstance.getBoolean() && pageBase.getRights().ExternalQueue.getBoolean()) { %>
<div class="tab-content">
  <v:alert-box type="warning">
    <% String href = pageBase.getRights().QueueURL.getString() + "/admin?page=outboundcfg&tab=message";%>
    <v:itl key="@Outbound.OutboundMessagesLink"/>&nbsp;
    <a href="<%=href%>" target="_blank"><%=href%></a>
  </v:alert-box>
</div>
<% } else { %>
<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" onclick="search()"/>
  <span class="divider"></span>
  <div class="btn-group">
    <v:button id="status-btn" caption="@Common.Status" clazz="disabled" fa="flag" dropdown="true"/>
    <v:popup-menu bootstrap="true">
      <% String hrefEnabled = "javascript:changeOutboundMessageStatus(" + LkSNOutboundMessageStatus.Active.getCode() + ")"; %>
      <v:popup-item caption="@Common.Enable" href="<%=hrefEnabled%>"/>
      <% String hrefDisabled = "javascript:changeOutboundMessageStatus(" + LkSNOutboundMessageStatus.Disabled.getCode() + ")"; %>
      <v:popup-item caption="@Common.Disable" href="<%=hrefDisabled%>"/>
    </v:popup-menu>
  </div>
  <div class="btn-group">
    <v:button id="priority-btn" caption="@Common.Priority" clazz="disabled" fa="sort-numeric-down" dropdown="true"/>
    <v:popup-menu bootstrap="true">
      <% for (LookupItem outboundMessagePriority : LkSN.OutboundMessagePriority.getItems()) { %>
        <% String href = "javascript:changeOutboundMessagePriority(" + outboundMessagePriority.getCode() + ")"; %>
        <v:popup-item caption="<%=outboundMessagePriority.getRawDescription()%>" href="<%=href%>"/>
      <%}%>
    </v:popup-menu>
  </div>
  <div class="btn-group">
    <v:button id="broker-btn" caption="@Outbound.Broker" clazz="disabled" fa="handshake" dropdown="true"/>
    <v:popup-menu bootstrap="true">
      <v:ds-loop dataset="<%=dsPlugin%>">
        <% String pluginName = dsPlugin.getField("PluginDisplayName").getString(); %>
        <% String pluginId = dsPlugin.getField("PluginId").getString(); %>
        <% String href = "javascript:changeBrokerPlugin('" + pluginId + "')"; %>
        <v:popup-item caption="<%=pluginName%>" href="<%=href%>"/>
      </v:ds-loop>
    </v:popup-menu>
  </div>
  <% JvDataSet dsDataSource = pageBase.getBL(BLBO_DataSource.class).getDataSourceDS(LkSNDataSourceType.Outbound); %>
  <% if (!dsDataSource.isEmpty()) { %>
    <div class="btn-group">
      <v:button id="datasource-btn" caption="@Common.DataSource" clazz="disabled" fa="database" dropdown="true"/>
      <v:popup-menu bootstrap="true">
        <v:popup-item caption="@Common.Default" href="javascript:changeDataSource(null)"/>
        <v:popup-divider/>
        <v:ds-loop dataset="<%=dsDataSource%>">
          <% String href = "javascript:changeDataSource('" + dsDataSource.getField("DataSourceId").getString() + "')"; %>
          <v:popup-item caption="<%=dsDataSource.getField(\"DataSourceName\").getString()%>" href="<%=href%>"/>
        </v:ds-loop>
      </v:popup-menu>
    </div>
  <% } %>

  <v:pagebox gridId="outboundmessage-grid"/>
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <v:widget caption="@Common.Search">
      <v:widget-block>
        <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>"/>
      </v:widget-block>
    </v:widget>
    <v:widget caption="@Common.Status">
      <v:widget-block>
        <v:db-checkbox field="Status" caption="@Common.Enabled" value="<%=LkSNOutboundMessageStatus.Active.getCode()%>" checked="<%=JvArray.contains(LkSNOutboundMessageStatus.Active.getCode(), defaultStatusFilter)%>" /><br/>
        <v:db-checkbox field="Status" caption="@Common.Disabled" value="<%=LkSNOutboundMessageStatus.Disabled.getCode()%>" checked="<%=JvArray.contains(LkSNOutboundMessageStatus.Disabled.getCode(), defaultStatusFilter)%>" /><br/>
        <v:db-checkbox field="Status" caption="@Common.Deleted" value="<%=LkSNOutboundMessageStatus.Deleted.getCode()%>" checked="<%=JvArray.contains(LkSNOutboundMessageStatus.Deleted.getCode(), defaultStatusFilter)%>" /><br/>
      </v:widget-block>
    </v:widget>
    <v:widget caption="@Common.Filters">
      <v:widget-block>

        <v:itl key="@Plugin.ExtensionPackage"/><br/>
        <snp:dyncombo id="ExtensionPackageId" entityType="<%=LkSNEntityType.ExtensionPackage%>" auditLocationFilter="true"/>        
        
        <div class="filter-divider"></div>
        
        <v:itl key="@Outbound.Broker"/><br/>
        <snp:dyncombo id="BrokerPluginId" entityType="<%=LkSNEntityType.Plugin_OutboundBroker %>"  auditLocationFilter="true" parentComboId="ExtensionPackageId" />

      </v:widget-block>
    </v:widget>
  </div>
  <div class="profile-cont-div">
    <% String params = "OutboundMessageStatus=" + JvArray.arrayToString(defaultStatusFilter, ","); %>
    <v:async-grid id="outboundmessage-grid" jsp="outbound/outboundmessage_grid.jsp" params="<%=params%>"/>
  </div>
</div>
<% } %>

<script>
$(document).ready(function() {
  $(document).on("cbListClicked", enableDisable);
  
  function enableDisable() {
    var empty = ($("#outboundmessage-grid [name='OutboundMessageId']").getCheckedValues() == "");
    $("#status-btn").setClass("disabled", empty);
    $("#priority-btn").setClass("disabled", empty);
    $("#broker-btn").setClass("disabled", empty);
    $("#datasource-btn").setClass("disabled", empty);
  }
  
  $("#full-text-search").keypress(function(e) {
    if (e.keyCode == KEY_ENTER) {
      search();
      return false;
    }
  });
});

function prepareUpdateMessageRequest() {
  return {
    Command: "UpdateOutboundMessage",
    UpdateOutboundMessage: {
      OutboundMessageIDs: $("[name='OutboundMessageId']").getCheckedValues()
    }
  };
}

function doUpdateOutboundMessage(reqDO, callback) {
  vgsService("Outbound", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.OutboundMessage.getCode()%>);
    if (callback) {
      ansDO = ((ansDO) && (ansDO.Answer) && (ansDO.Answer.UpdateOutboundMessage)) ? ansDO.Answer.UpdateOutboundMessage : {};
      callback(ansDO);
    }
  });
}

function changeOutboundMessageStatus(status) {
  var reqDO = prepareUpdateMessageRequest();
  reqDO.UpdateOutboundMessage.OutboundMessageStatus = status;
  doUpdateOutboundMessage(reqDO);
}

function changeOutboundMessagePriority(priority) {
  var reqDO = prepareUpdateMessageRequest();
  reqDO.UpdateOutboundMessage.OutboundMessagePriority = priority;
  doUpdateOutboundMessage(reqDO);
}

function changeBrokerPlugin(brokerId) {
  var reqDO = prepareUpdateMessageRequest();
  reqDO.UpdateOutboundMessage.OutboundBrokerId = brokerId;
  doUpdateOutboundMessage(reqDO);
}

function changeDataSource(dataSourceId) {
  var reqDO = prepareUpdateMessageRequest();
  reqDO.UpdateOutboundMessage.DataSourceId = dataSourceId;
  doUpdateOutboundMessage(reqDO);
}

function search() {
	setGridUrlParam("#outboundmessage-grid", "ExtensionPackageId", $("#ExtensionPackageId").val() || "");
	setGridUrlParam("#outboundmessage-grid", "BrokerPluginId", $("#BrokerPluginId").val() || "");
	setGridUrlParam("#outboundmessage-grid", "OutboundMessageStatus", $("[name='Status']").getCheckedValues());
	setGridUrlParam("#outboundmessage-grid", "FullText", $("#full-text-search").val(), true);
}

</script>