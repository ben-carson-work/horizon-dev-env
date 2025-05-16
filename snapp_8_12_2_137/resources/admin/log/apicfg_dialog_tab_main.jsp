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


<v:tab-content id="apicfg-tab-main">

  <v:grid>
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="40%">API</td>
        <td width="40%">Where</td> 
        <td width="10%" align="center"><v:itl key="@Common.Options"/> <v:hint-handle hint="@Log.ApiLogSaveTypesHint"/></td>
        <td width="10%">Duration threshold (ms)</td>
      </tr>
    </thead>
    <tbody id="apicfg-grid-data">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button id="btn-apicfg-add" fa="plus" caption="@Common.Add"/>
          <v:button id="btn-apicfg-del" fa="minus" caption="@Common.Remove"/>
        </td>
      </tr>
    </tbody>
  </v:grid>

</v:tab-content>


<div id="apicfg-main-templates" class="hidden">
  <table>
    <tr class="api-row-template">
      <td><v:grid-checkbox/></td>
      <td>
        <select class="combo-cmd form-control"><option value="">- all -</option>
          <optgroup label="Legacy">
          <% for (String cmd : Service2Manager.getCmdList(null)) { %>
            <option value="<%=JvString.escapeHtml(cmd)%>"><%=JvString.escapeHtml(cmd)%></option>
          <% } %>
          </optgroup>
          <optgroup label="REST v1">
          <% for (DORestApiRef item : BLBO_ApiLog.getRestApiList()) { %>
            <option value="<%=item.ClassSimpleName.getHtmlString()%>"><%=item.ClassSimpleName.getHtmlString()%></option>
          <% } %>
          </optgroup>
        </select>
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
        <input type="text" class="txt-threshold form-control" placeholder="All"/>
      </td>
    </tr>
  </table>
</div>


<script>
$(document).ready(function() {
  var $tabMain = $("#apicfg-tab-main");
  var $templates = $("#apicfg-main-templates");
  var $tbody = $("#apicfg-grid-data");
  
  $("#btn-apicfg-add").click(_add);
  $("#btn-apicfg-del").click(_remove);
  $(document).von($tbody, "apicfg-load", _initialize);
  $(document).von($tbody, "apicfg-save", _save);
  
  function _initialize(event, params) {
    for (const item of (params.apicfg.WriteItemList || []))
      _add(null, item);
  }
  
  function _add(event, item) {
    var $tr = $templates.find(".api-row-template").clone().appendTo($tbody);

    item = (item) ? item : {"LogInternal":true}; 
    console.log(item);
    
    $tr.find(".combo-cmd").val(item.RequestCode);
    $tr.find(".combo-wks").val(item.WorkstationId || item.OpAreaId || item.LocationId);
    $tr.find(".txt-threshold").val(item.DurationThreshold);
    $tr.find("#LogInternal").setChecked(item.LogInternal);
    $tr.find("#Log4J").setChecked(item.Log4J);
  }
  
  function _remove() {
    $tbody.find(".cblist:checked").closest("tr").remove();
  }
  
  function _save(event, params) {
	  params.apicfg.WriteItemList = [];
	  var isEmpty = true; // flag to track if all fields are empty

	  $tbody.find("tr").each(function(idx, elem) {
	    var $tr = $(elem);
	    var $wksopt = $tr.find(".combo-wks option[value='" + $tr.find(".combo-wks").val() + "']");
	    
	    var config = {
	      RequestCode: $tr.find(".combo-cmd").val(),
	      LocationId: $wksopt.attr("data-LocationId"),
	      OpAreaId: $wksopt.attr("data-OpAreaId"),
	      WorkstationId: $wksopt.attr("data-WorkstationId"),
	      DurationThreshold: $tr.find(".txt-threshold").val(),
	      LogInternal: $tr.find("#LogInternal").isChecked(),
	      Log4J: $tr.find("#Log4J").isChecked()
	    };
	    params.apicfg.WriteItemList.push(config);
	  });
	}
});
</script>
