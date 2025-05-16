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
<jsp:useBean id="workstation" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>

<style>
.btn-settings, 
.btn-copy, 
.btn-generate { 
  font-size: 24px;
  margin: 5px;
}

.btn-settings:hover, 
.btn-copy:hover,
.btn-generate:hover {
  cursor: pointer;
} 
</style>
<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 

String distributorIdHint = JvString.lines(
    "Distributor ID needs to be unique per Workstation.",
    "This value must be numeric and along with the API Key must be provided to Prio Ticket for mapping prior to testing.", 
    "Example Distributor ID = 501");
        
String resellerMappingHint = JvString.lines(
    "List of ResellerId=ResellerName mapping.",
    "",
    "**Example:**",
    "2899=Klook",
    "405=Tiqets",
    "1234=Expedia",
    "etc...");

String filterPerformanceTypeHint = JvString.lines(
    "**When selected**",
    "- \"ticket_type\" sent by PRIO is expected to be in the format {DistID}/{ResellerId}/{ProductFamilyId}/**{PerformanceTypeCode}**.",
    "- **PerformanceTypeCode** will be checked against the performance type assigned to the performance that is trying to be booked.",
    "- If a performance is configured as 'default', then PerformanceTypeCode is not expected to be passed.",
    "- In case there is any mismatch between the PerformanceTypeCode passed and the performance configuration, an error will result.",
    "",
    "**When NOT selected**",
    "- \"ticket_type\" sent by PRIO is expected to be in the format {DistID}/{ResellerId}/{ProductFamilyId}. Any additional values which are passed after the ProductFamilyId will be ignored by the system.");

%>

<v:widget caption="Options">
  <v:widget-block>
    <div><v:db-checkbox field="settings.TrimPhoneNumber" value="true" caption="Trim phone number" hint="When selected, system will trim any invalid character in the phone number, instead of rejecting the request as per default."/></div>
    <div><v:db-checkbox field="settings.FilterPerformanceType" value="true" caption="Filter performance type" hint="<%=filterPerformanceTypeHint%>"/></div>
  </v:widget-block>
</v:widget>

<v:grid id="prio-config-grid">
  <thead>
    <v:grid-title caption="Distributors"/>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td width="10%">Distributor<v:hint-handle hint="<%=distributorIdHint%>"/></td>
      <td width="45%">API Key</td>
      <td width="45%">Workstation</td>
    </tr>
  </thead>

  <tbody id="prio-distributor-list"></tbody>
  
  <tbody id="prio-distributor-buttons">
    <tr>
      <td colspan="100%">
        <v:button id="btn-add" fa="plus" caption="@Common.Add"/>
        <v:button id="btn-remove" fa="minus" caption="@Common.Remove"/>
      </td>
    </tr>
  </tbody>
</v:grid>

<v:widget caption="Reseller mapping" hint="<%=resellerMappingHint%>">
  <v:widget-block>
    <textarea id="prio-reseller-map" class="form-control" rows="15"></textarea>
  </v:widget-block>
</v:widget>

<div id="prio-templates" class="hidden">
  <v:widget caption="Prio configurations">
    <v:widget-block>
      <v:grid id="prio-config-slot-grid">
       <thead>
         <tr class="prio-row-template">
           <td><v:grid-checkbox/></td>
           <td><v:input-text clazz="txt-distributorId" placeholder="Distributor Id"/></td>
           <td>
             <div class="input-group">
               <v:input-text clazz="txt-apiKeyToken" placeholder="API key Token"/>
               <span class="input-group-btn">
                 <v:button clazz="btn-apikey-regenerate" fa="redo" title="Generate a new random API key"/>
                 <v:button clazz="btn-apikey-copy" fa="copy" title="Copy API key to clipboard"/>
               </span>
             </div>
           </td>
           <td><snp:dyncombo clazz="class-combo-wks" field="workstation.WorkstationId" id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>"/></td>
         </tr>
       </thead>
      </v:grid>
    </v:widget-block>
  </v:widget>
</div>

<script>
  
  function getPluginSettings() {
    var result = {
      TrimPhoneNumber: $("#settings\\.TrimPhoneNumber").isChecked(),
      FilterPerformanceType: $("#settings\\.FilterPerformanceType").isChecked(),
      DistributorList: [],
      ResellerList: []
    }
    
    // Fill DistributorList
    $("#prio-config-grid tbody tr").each(function(idx, elem) {
      var $tr = $(elem);
      result.DistributorList.push({
        DistributorId: $tr.find(".txt-distributorId").val(),
        ApiKeyToken:   $tr.find(".txt-apiKeyToken").val(),
        WorkstationId: $tr.find(".class-combo-wks").val()
      });
    });
    
    // Fill ResellerList
    var resellerLines = $("#prio-reseller-map").val().split("\n");
    for (var i=0; i<resellerLines.length; i++) {
      var line = resellerLines[i];
      if (getNull(line) != null) {
        var splits = line.split("=");
        if (splits.length > 0) {
          result.ResellerList.push({
            ResellerExtCode: splits[0],
            ResellerName: ((splits.length > 1) ? splits[1] : "")
          });
        }
      }
    }
    
    return result;
  }

  $(document).ready(function() {
    var settings = <%=settings.getJSONString()%>;
    $("#prio-distributor-buttons #btn-add").click(doAdd);
    $("#prio-distributor-buttons #btn-remove").click(doRemove);
    doInitialize();
    
    function doInitialize() {
      if (settings) {
        for (var i=0; i<settings.DistributorList.length; i++)
          doAdd(settings.DistributorList[i]);

        var resellerMap = "";
        for (var i=0; i<settings.ResellerList.length; i++) {
          var reseller = settings.ResellerList[i];
          resellerMap += reseller.ResellerExtCode + "=" + reseller.ResellerName + "\n";
        }
        $("#prio-reseller-map").val(resellerMap);
      }
    }
    
    function doAdd(item) {
      var $tr = $("#prio-templates .prio-row-template").clone().appendTo("#prio-distributor-list");
  
      item = (item) ? item : {};
      
      $tr.attr("data-rowid", newStrUUID());
      $tr.find(".class-combo-wks").val(item.WorkstationId);
      $tr.find(".txt-distributorId").val(item.DistributorId);
      $tr.find(".txt-apiKeyToken").val(item.ApiKeyToken);
      $tr.data("item", item);
      
      $tr.find(".btn-apikey-regenerate").click(generateAPIKey);
      $tr.find(".btn-apikey-copy").click(copyAPIKey);
    }
    
    function doRemove() {
      $("#prio-distributor-list .cblist:checked").closest("tr").remove();
    }
    
    function generateAPIKey() {
      function _s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
          .toString(16)
          .substring(1);
        }
      
      var $txt = $(this).closest(".input-group").find(".txt-apiKeyToken");
      var newval = "";
      for (var i=0; i<10; i++)
        newval += _s4();
      $txt.val(newval);
    }
    
    function copyAPIKey() {
      var apiKey = $(this).closest(".input-group").find(".txt-apiKeyToken")[0];
      apiKey.select();
      apiKey.setSelectionRange(0, 99999);
      document.execCommand("copy");
      $(apiKey).blur();
      showMessage("API Key copied to clipboard");
    }
  });
</script>