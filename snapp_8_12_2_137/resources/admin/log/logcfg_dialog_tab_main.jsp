<%@page import="com.vgs.web.library.bean.StationBean"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Comparator"%>
<%@page import="com.vgs.snapp.web.gencache.SrvBO_Cache_Station"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="logConfig" class="com.vgs.snapp.dataobject.DOLogConfig" scope="request"/>

<style>
tr:not([data-entitytype='<%=LkSNEntityType.Plugin.getCode()%>']) .combo-altentityid {
  display: none;
}
</style>


<v:tab-content id="logcfg-tab-main">
  
  <v:alert-box type="warning" include="<%=!logConfig.Warning.isNull()%>"><%=logConfig.Warning.getHtmlString()%></v:alert-box>

  <v:grid>
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="10%"><v:itl key="@Common.LogLevel"/></td>
        <td width="30%"><v:itl key="@Log.EntityType"/></td>
        <td width="30%">Where</td>
        <td width="10%"><v:itl key="@Common.Options"/></td>
        <td width="20%"><v:itl key="@Common.EmailAddress"/></td>
      </tr>
    </thead>
    <tbody id="grid-data">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
           <v:button id="btn-logcfg-add" fa="plus" caption="@Common.Add"/>
           <v:button id="btn-logcfg-del" fa="minus" caption="@Common.Remove"/>
        </td>
      </tr>
    </tbody>
  </v:grid>

  <div id="templates" class="hidden">
    <table>
      <tr class="log-row-template">
        <td><v:grid-checkbox/></td>
        <td>
          <v:lk-combobox clazz="combo-loglevel" lookup="<%=LkSN.LogLevel%>" allowNull="false"/>
        </td>
        <td>
          <snp:dyncombo clazz="combo-entitytype" entityType="<%=LkSNEntityType.LookupTable_EntityType%>"/>
          <snp:dyncombo clazz="combo-altentityid" entityType="<%=LkSNEntityType.Driver%>"/>
        </td>
        <td>
          <select class="combo-wks form-control"><option value="">- everywhere -</option>
          <%
          String lastLocationId = null; 
          String lastOpAreaId = null; 
          %>
          <% for (StationBean station : SrvBO_Cache_Station.instance().getList()) { %>
            <!-- LOCATION -->
            <% if (!JvString.isSameText(station.locationId, lastLocationId)) { %>
              <option 
                  value="<%=JvString.escapeHtml(station.locationId)%>"
                  data-LocationId="<%=JvString.escapeHtml(station.locationId)%>"
                  >&#9679; <%=JvString.escapeHtml(station.locationName)%></option>
              <% lastLocationId = station.locationId; %>
            <% } %>
            <!-- OP.AREA -->
            <% if (!JvString.isSameText(station.opAreaId, lastOpAreaId)) { %>
              <option 
                  value="<%=JvString.escapeHtml(station.opAreaId)%>" 
                  data-LocationId="<%=JvString.escapeHtml(station.locationId)%>"
                  data-OpAreaId="<%=JvString.escapeHtml(station.opAreaId)%>"
                  >&nbsp;&nbsp;&nbsp;&raquo; <%=JvString.escapeHtml(station.opAreaName)%></option>
              <% lastOpAreaId = station.opAreaId; %>
            <% } %>
            <!-- WORKSTATION -->
            <option 
                value="<%=JvString.escapeHtml(station.workstationId)%>" 
                data-LocationId="<%=JvString.escapeHtml(station.locationId)%>" 
                data-OpAreaId="<%=JvString.escapeHtml(station.opAreaId)%>"
                data-WorkstationId="<%=JvString.escapeHtml(station.workstationId)%>"
                >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=JvString.escapeHtml(station.workstationName)%></option>
          <% } %>
          </select>
        </td>
        <td nowrap>
          <div><v:db-checkbox field="LogInternal" value="true" caption="Internal"/></div>
          <div><v:db-checkbox field="Log4J" value="true" caption="Log4J"/></div>
        </td>
        <td>
          <v:input-text field="txt-email"/>
        </td>
      </tr>
    </table>
  </div>

</v:tab-content>

<script>
$(document).ready(function() {
  var $tab = $("#logcfg-tab-main");
  var $templates = $tab.find("#templates");
  var $tbody = $tab.find("#grid-data");
  
  $("#btn-logcfg-add").click(_add);
  $("#btn-logcfg-del").click(_remove);
  $(document).von($tbody, "logcfg-load", _initialize);
  $(document).von($tbody, "logcfg-save", _save);
  
  function _initialize(event, params) {
    var cfg = params.logcfg || {};
    
    $tab.find("[name='cbSnapp']").setChecked(cfg.SnappActive);
    $tab.find("[name='cbDataSourceId']").val(cfg.DataSourceId);
    $tab.find("[name='cbLog4j']").setChecked(cfg.Log4jActive);
    
    for (const item of (cfg.WriteItemList || []))
      _add(item);
  }
  
  function _add(item) {
    var $tr = $templates.find(".log-row-template").clone().appendTo($tbody);

    item = (item) ? item : {};
    
    $tr.find(".combo-loglevel").val(item.LogLevel);
    $tr.find(".combo-entitytype").change(function() {_enableDisableRow($tr)}).val(""+item.EntityType);
    $tr.find(".combo-altentityid").val(item.AltEntityId);
    $tr.find(".combo-wks").val(item.SourceWorkstationId || item.SourceOpAreaId || item.SourceLocationId);
    $tr.find("#LogInternal").setChecked(item.LogInternal);
    $tr.find("#Log4J").setChecked(item.Log4J);
    $tr.find("[name='txt-email']").val(item.EmailAddress);
    _enableDisableRow($tr);
  }
  
  function _remove() {
    $tbody.find(".cblist:checked").closest("tr").remove();
  }
  
  function _enableDisableRow(tr) {
    var $tr = $(tr);
    $tr.attr("data-entitytype", $tr.find(".combo-entitytype").val());
  }
  
  function _save(event, params) {
    params.logcfg.WriteItemList = [];
    $tbody.find("tr").each(function(idx, elem) {
      var $tr = $(elem);
      var $wksopt = $tr.find(".combo-wks option[value='" + $tr.find(".combo-wks").val() + "']");
      
      params.logcfg.SnappActive = $tab.find("[name='cbSnapp']").isChecked();
      params.logcfg.DataSourceId = $tab.find("[name='cbDataSourceId']").val();
      params.logcfg.Log4jActive = $tab.find("[name='cbLog4j']").isChecked();
      
      var entityType = $tr.find(".combo-entitytype").val();
      var altEntityId = (entityType == <%=LkSNEntityType.Plugin.getCode()%>) ? $tr.find(".combo-altentityid").val() : null;

      params.logcfg.WriteItemList.push({
        LogLevel: $tr.find(".combo-loglevel").val(),
        EntityType: entityType,
        AltEntityId: altEntityId,
        SourceLocationId: $wksopt.attr("data-LocationId"),
        SourceOpAreaId: $wksopt.attr("data-OpAreaId"),
        SourceWorkstationId: $wksopt.attr("data-WorkstationId"),
        LogInternal: $tr.find("#LogInternal").isChecked(),
        Log4J: $tr.find("#Log4J").isChecked(),
        EmailAddress: $tr.find("[name='txt-email']").val()
      });
    });
  }
});
</script>
