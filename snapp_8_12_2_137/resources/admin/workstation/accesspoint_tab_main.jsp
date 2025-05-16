<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="wks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<style>
.apt-needed-upld-pkg-wrn { 
  display: block;
  color: red;
  font-size: 11pt;
  margin: 5px;
}
</style>

<%
PluginSettingsBase plgSettings = pageBase.getBL(BLBO_Plugin.class).getPluginSettings(wks.DrvClassAlias.getString());
request.setAttribute("settings", plgSettings.getPluginConfigDataObject(wks.AptSettings.getString()));

boolean canEdit = rights.SystemSetupAccessPoints.getOverallCRUD().canUpdate(); 
boolean canCreate = rights.SystemSetupAccessPoints.getOverallCRUD().canCreate();
boolean canEditSiae = BLBO_DBInfo.isSiae() ? pageBase.getBL(BLBO_Siae.class).findCodiceRichiedente(pageBase.getId()) == null : true;
String sDisabled = (canEdit) ? "" : "disabled=\"disabled\""; 

QueryDef qdef = new QueryDef(QryBO_Account.class);
// Select
qdef.addSelect(QryBO_Account.Sel.AccountId);
qdef.addSelect(QryBO_Account.Sel.DisplayName);
// Where
qdef.addFilter(QryBO_Account.Fil.EntityType, LkSNEntityType.AccessArea.getCode());
qdef.addFilter(QryBO_Account.Fil.ParentAccountId, wks.LocationAccountId.getString());
//Sort
qdef.addSort(QryBO_Account.Sel.DisplayName);
// Exec
JvDataSet dsArea = pageBase.execQuery(qdef);

if (pageBase.isNewItem())
  wks.AptReentryControl.setInt(LkSNAccessPointReentryControl.FirstEntryAndReentryAndCrossover.getCode());
%>

<%
boolean neededUploadPkg = false;
String msg = "";
if (!pageBase.isNewItem()){
  QueryDef qdefWks = new QueryDef(QryBO_Workstation.class);
  //Select
  qdefWks.addSelect(QryBO_Workstation.Sel.DrvName);
  qdefWks.addSelect(QryBO_Workstation.Sel.DrvLibraryName);
  qdefWks.addSelect(QryBO_Workstation.Sel.DrvExtPackageId);
  //Where
  qdefWks.addFilter(QryBO_Workstation.Fil.WorkstationId, pageBase.getId());
  qdefWks.addFilter(QryBO_Workstation.Fil.WorkstationType, LkSNWorkstationType.APT.getCode());
  //Exec
  JvDataSet dsWks = pageBase.execQuery(qdefWks);
  
  neededUploadPkg = dsWks.getField(QryBO_Workstation.Sel.DrvExtPackageId).isNull() && !dsWks.getField(QryBO_Workstation.Sel.DrvLibraryName).getEmptyString().isEmpty(); //used to warn the user that the selected plugin for the access point has been moved into a package
  msg = JvMultiLang.translate(pageContext.getRequest(), "@Common.NeedUploadPackageAptWrn", dsWks.getField(QryBO_Workstation.Sel.DrvName).getJsString());
}
%>
<script>
  var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(wks.MetaDataList)%>;
</script>

<v:page-form id="apt-form">
<v:input-text type="hidden" field="wks.WorkstationId"/>
<v:input-text type="hidden" field="wks.LicenseId"/>
<v:input-text type="hidden" field="wks.WorkstationType"/>
<v:input-text type="hidden" field="wks.LocationAccountId"/>
<v:input-text type="hidden" field="wks.AptReentryControl"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" onclick="doSave()" enabled="<%=canEdit && !neededUploadPkg%>"/>
  
  <% if (!pageBase.isNewItem()) { %>
    <% String clickDup = "asyncDialogEasy('workstation/workstation_dup_dialog', 'id=" + pageBase.getId() + "')"; %>
    <v:button caption="@Common.Duplicate" fa="clone" onclick="<%=clickDup%>" enabled="<%=canCreate%>"/>
    
    <v:button id="btn-simrot" caption="@AccessPoint.SimulateRotations" fa="sync-alt" enabled="<%=rights.SimulateRotations.getBoolean()%>"/>
  <% } %>
</div>

<div class="tab-content">
<v:last-error/>
  <% if (neededUploadPkg) { %>
    <div class="apt-needed-upld-pkg-wrn"><%=msg%></div>
  <% } %>
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="wks.WorkstationCode" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="wks.WorkstationName" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Category.Category" mandatory="true">
        <v:combobox field="wks.CategoryId" lookupDataSetName="dsCategoryAll" idFieldName="CategoryId" captionFieldName="AshedCategoryName" linkEntityType="<%=LkSNEntityType.Category%>" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block> 
    <v:widget-block>
      <v:form-field caption="@Common.Driver" mandatory="true">
        <v:combobox field="wks.DriverId" lookupDataSetName="ds-drv-all" idFieldName="DriverId" captionFieldName="DriverName" enabled="<%=canEdit && canEditSiae%>"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.Controller">
        <snp:dyncombo field="wks.AptControllerWorkstationId" entityType="<%=LkSNEntityType.Workstation%>" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block> 
    <v:widget-block>
      <v:form-field caption="@Account.OpArea" mandatory="true">
        <v:combobox field="wks.OpAreaAccountId" lookupDataSetName="dsOpArea" idFieldName="AccountId" captionFieldName="Displayname" linkEntityType="<%=LkSNEntityType.OperatingArea%>" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Account.AccessAreas">
        <v:multibox field="wks.AptAccessAreaIDs" lookupDataSet="<%=dsArea%>" idFieldName="AccountId" captionFieldName="DisplayName" placeholder="@AccessPoint.InheritFromGate" linkEntityType="<%=LkSNEntityType.AccessArea%>" />
      </v:form-field>
      <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.AccessPoint.getCode() + ",'accessPoint.TagIDs')"; %>
      <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.AccessPoint); %>
        <v:multibox field="wks.AptTagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block> 
  </v:widget>
  
  <v:grid id="accesspoint-description-grid">
    <thead>
      <v:grid-title caption="@Common.Descriptions"/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="30%"><v:itl key="@Common.ValidFrom"/></td>
        <td width="30%"><v:itl key="@Common.ValidTo"/></td>
        <td width="40%"><v:itl key="@Common.Description"/></td>
      </tr>
    </thead>
    <tbody id="accesspoint-description-tbody"></tbody>
    <tbody class="toolbar">
      <tr>
        <td colspan="100%">
          <v:button caption="@Common.Add" fa="plus" href="javascript:doAddAccessPointDescription()"/>
          <v:button caption="@Common.Remove" fa="minus" href="javascript:doRemoveAccessPointDescription()"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
  
  
  <v:widget caption="@Common.Options">
    <v:widget-block>
      <% 
      LookupItem[] aptControlTypes = new LookupItem[] {
          LkSNAccessPointControl.Closed,
          LkSNAccessPointControl.Controlled,
          LkSNAccessPointControl.Free,
          LkSNAccessPointControl.SimRotation,
          LkSNAccessPointControl.SimRedemption
      };
      %>
      <v:form-field caption="@AccessPoint.EntryControl">
        <select name="wks.AptEntryControl" class="form-control" <%=sDisabled%>>
        <% for (LookupItem controlType : aptControlTypes) { %>
          <% String sSelected = wks.AptEntryControl.isLookup(controlType) ? "selected" : ""; %> 
          <option value="<%=controlType.getCode()%>" <%=sSelected%>><%=controlType.getHtmlDescription(pageBase.getLang())%></option>
        <% } %>
        </select>
      </v:form-field>
      <v:form-field caption="@AccessPoint.ExitControl">
        <select name="wks.AptExitControl" class="form-control" <%=sDisabled%>>
        <% for (LookupItem item : aptControlTypes) { %>
          <% String sSelected = wks.AptExitControl.isLookup(item) ? "selected" : ""; %> 
          <option value="<%=item.getCode()%>" <%=sSelected%>><%=item.getHtmlDescription(pageBase.getLang())%></option>
        <% } %>
        </select>
      </v:form-field>
      <v:form-field caption="@AccessPoint.ReentryControl">
        <div id="reentry-control-choice">
          <label class="checkbox-label"><input type="radio" onclick="refreshReentryControl()" id="ReentryControlOp-Entry" name="ReentryControlOperation" value="entry">&nbsp;<v:itl key="@Lookup.TicketUsageType.Entry"/></label>&nbsp;&nbsp;&nbsp;
          <label class="checkbox-label"><input type="radio" onclick="refreshReentryControl()" id="ReentryControlOp-Transit" name="ReentryControlOperation" value="transit">&nbsp;<v:itl key="@Lookup.TicketUsageType.Transit"/></label>
        </div>
        <div id="reentry-control-choice-container" class="v-hidden">
          <label class="checkbox-label"><input type="checkbox" id="ReentryControl-FirstEntry" value="true">&nbsp;<v:itl key="@Common.FirstEntry"/></label>&nbsp;&nbsp;&nbsp;
          <label class="checkbox-label"><input type="checkbox" id="ReentryControl-Reentry" value="true">&nbsp;<v:itl key="@Common.Reentry"/></label>&nbsp;&nbsp;&nbsp;
          <label class="checkbox-label"><input type="checkbox" id="ReentryControl-Crossover" value="true">&nbsp;<v:itl key="@Entitlement.Crossover"/>
        </div>
        
      </v:form-field>
      <v:form-field caption="@AccessPoint.HardwareCode">
        <v:input-text field="wks.AptHardwareCode" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block> 
    <v:widget-block>
      <v:form-field caption="@AccessPoint.CounterMode">
        <%
        LookupItem[] aptCounterModeTypes = new LookupItem[] {
            LkSNAccessPointCounterMode.None,
            LkSNAccessPointCounterMode.Entry,
            LkSNAccessPointCounterMode.Exit,
            LkSNAccessPointCounterMode.Both
        };
        %>
        <select id="wks.AptCounterMode" class="form-control" <%=sDisabled%>>
        <% for (LookupItem item : aptCounterModeTypes) { %>
          <% String sSelected = wks.AptCounterMode.isLookup(item) ? "selected" : ""; %> 
          <option value="<%=item.getCode()%>" <%=sSelected%>><%=item.getHtmlDescription(pageBase.getLang())%></option>
        <% } %>
        </select>
      </v:form-field>
      <v:form-field caption="@AccessPoint.EntryCount">
        <v:input-text field="wks.AptEntryCount" enabled="false"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.ExitCount">
        <v:input-text field="wks.AptExitCount" enabled="false"/>
      </v:form-field>
    </v:widget-block> 
    <v:widget-block>
      <v:db-checkbox field="wks.AptCheckValidPerformance" caption="@AccessPoint.CheckValidPerformance" value="true" enabled="<%=canEdit%>"/><br/>
      <v:db-checkbox field="wks.QueueControl" caption="@Event.QueueControl" value="true" enabled="<%=canEdit%>"/><br/>
    </v:widget-block>
  </v:widget>

  <div id=settings>
    <% if (plgSettings.getPluginConfigPageName() != null) { %>
      <jsp:include page="<%=plgSettings.getPluginConfigPageName()%>"/>
    <% } else { %>
      <v:widget caption="@Common.Configuration">
        <jsp:include page="../common/config_not_available.jsp"/>
      </v:widget>
    <% } %>
  </div>
  
  <div id="maskedit-container"></div>
  
</div>

<script>
//# sourceURL=accesspoint_tab_main.jsp
$(document).ready(function() {
	<% if (wks.WorkstationType.isLookup(LkSNWorkstationType.APT)) { %>
    <% for (DOAccessPointDescription aptDesc : wks.APTDescriptionList) { %>
      doAddAccessPointDescription(<%=JvString.jsString(aptDesc.ValidDateFrom.getXMLValue())%>, <%=JvString.jsString(aptDesc.ValidDateTo.getXMLValue())%>, <%=aptDesc.Description.getJsString()%>);
    <% } %>
  <%}%>
  
  $("#btn-simrot").click(function() {
	    asyncDialogEasy("workstation/accesspoint_simrotation_dialog", "id=<%=pageBase.getId()%>");
	  });
  
});

//Data Masks

function reloadMaskEdit(categoryId) {
  asyncLoad("#maskedit-container", "admin?page=maskedit_widget&id=<%=pageBase.getId()%>&EntityType=<%=LkSNEntityType.Workstation.getCode()%>&CategoryId=" + categoryId + "&readonly=<%=!canEdit%>");
}
reloadMaskEdit(document.getElementById("wks.CategoryId").value);

$("#wks\\.CategoryId").change(function() {
  reloadMaskEdit(this.value);
});


$("#ReentryControlOp-Transit").prop('checked', $("#wks\\.AptReentryControl").val()==<%=LkSNAccessPointReentryControl.Transit.getCode()%>);
$("#ReentryControlOp-Entry").prop('checked', $("#wks\\.AptReentryControl").val()!=<%=LkSNAccessPointReentryControl.Transit.getCode()%>);
refreshReentryControl();


function refreshReentryControl() {
  var selected = $("#reentry-control-choice").find("[name='ReentryControlOperation']:checked").val();
  $("#reentry-control-choice-container").setClass("v-hidden", selected === 'transit'); 
  setReentryCheckBoxes();
}

function setAptReentryControl() {
  if ($("#ReentryControlOp-Transit").isChecked()) {
    $("#wks\\.AptReentryControl").val(<%=LkSNAccessPointReentryControl.Transit.getCode()%>);
    return true;
  }
  else {
    var FirstEntry = $("#ReentryControl-FirstEntry").isChecked();
    var Reentry = $("#ReentryControl-Reentry").isChecked();
    var CrossOver = $("#ReentryControl-Crossover").isChecked();
    
    if  (!FirstEntry && !Reentry && !CrossOver) {
      showMessage(<v:itl key="@AccessPoint.NoReentryOptionSelected" encode="JS"/>);
      return false;
    }
    else {
      if (FirstEntry && Reentry && CrossOver)
        $("#wks\\.AptReentryControl").val(<%=LkSNAccessPointReentryControl.FirstEntryAndReentryAndCrossover.getCode()%>);
      if (FirstEntry && Reentry && !CrossOver)
        $("#wks\\.AptReentryControl").val(<%=LkSNAccessPointReentryControl.FirstEntryAndReentry.getCode()%>);
      if (FirstEntry && !Reentry && CrossOver)
        $("#wks\\.AptReentryControl").val(<%=LkSNAccessPointReentryControl.FirstEntryAndCrossover.getCode()%>);
      if (!FirstEntry && Reentry && CrossOver)
        $("#wks\\.AptReentryControl").val(<%=LkSNAccessPointReentryControl.ReentryAndCrossover.getCode()%>);
      if (FirstEntry && !Reentry && !CrossOver)
        $("#wks\\.AptReentryControl").val(<%=LkSNAccessPointReentryControl.FirstEntryOnly.getCode()%>);
      if (!FirstEntry && Reentry && !CrossOver)
        $("#wks\\.AptReentryControl").val(<%=LkSNAccessPointReentryControl.ReentryOnly.getCode()%>);
      if (!FirstEntry && !Reentry && CrossOver)
        $("#wks\\.AptReentryControl").val(<%=LkSNAccessPointReentryControl.CrossoverOnly.getCode()%>);
      return true
    }
  }
}

function setReentryCheckBoxes() {
  if ($("#wks\\.AptReentryControl").val()==<%=LkSNAccessPointReentryControl.FirstEntryAndReentryAndCrossover.getCode()%>) {
    $("#ReentryControl-FirstEntry").prop('checked', true);
    $("#ReentryControl-Reentry").prop('checked', true);
    $("#ReentryControl-Crossover").prop('checked', true);
  }
  if ($("#wks\\.AptReentryControl").val()==<%=LkSNAccessPointReentryControl.FirstEntryAndReentry.getCode()%>) {
    $("#ReentryControl-FirstEntry").prop('checked', true);
    $("#ReentryControl-Reentry").prop('checked', true);
    $("#ReentryControl-Crossover").prop('checked', false);
  }
  if ($("#wks\\.AptReentryControl").val()==<%=LkSNAccessPointReentryControl.FirstEntryAndCrossover.getCode()%>) {
    $("#ReentryControl-FirstEntry").prop('checked', true);
    $("#ReentryControl-Reentry").prop('checked', false);
    $("#ReentryControl-Crossover").prop('checked', true);
  }
  if ($("#wks\\.AptReentryControl").val()==<%=LkSNAccessPointReentryControl.ReentryAndCrossover.getCode()%>) {
    $("#ReentryControl-FirstEntry").prop('checked', false);
    $("#ReentryControl-Reentry").prop('checked', true);
    $("#ReentryControl-Crossover").prop('checked', true);
  }
  if ($("#wks\\.AptReentryControl").val()==<%=LkSNAccessPointReentryControl.FirstEntryOnly.getCode()%>) {
    $("#ReentryControl-FirstEntry").prop('checked', true);
    $("#ReentryControl-Reentry").prop('checked', false);
    $("#ReentryControl-Crossover").prop('checked', false);
  }
  if ($("#wks\\.AptReentryControl").val()==<%=LkSNAccessPointReentryControl.ReentryOnly.getCode()%>) {
    $("#ReentryControl-FirstEntry").prop('checked', false);
    $("#ReentryControl-Reentry").prop('checked', true);
    $("#ReentryControl-Crossover").prop('checked', false);
  }
  if ($("#wks\\.AptReentryControl").val()==<%=LkSNAccessPointReentryControl.CrossoverOnly.getCode()%>) {
    $("#ReentryControl-FirstEntry").prop('checked', false);
    $("#ReentryControl-Reentry").prop('checked', false);
    $("#ReentryControl-Crossover").prop('checked', true);
  }
}

function doAddAccessPointDescription(validDateFrom, validDateTo, description) {
	  var tr = $("<tr/>").appendTo("#accesspoint-description-tbody");
	  var tdCB = $("<td/>").appendTo(tr); 
	  var tdFrom = $("<td/>").appendTo(tr); 
	  var tdTo = $("<td/>").appendTo(tr); 
	  var tdDescription = $("<td/>").appendTo(tr);
	  
	  $("<input type='checkbox' class='cblist'/>").appendTo(tdCB);

	  var pickerFrom = $("<input type='text' class='form-control' name='ValidDateFrom'/>").appendTo(tdFrom).datepicker();
	  pickerFrom.attr("placeholder", "<v:itl key="@Common.Unlimited" encode="UTF-8"/>");
	  pickerFrom.datepicker("setDate", (validDateFrom) ? xmlToDate(validDateFrom) : new Date());

	  var pickerTo = $("<input type='text' class='form-control' name='ValidDateTo'/>").appendTo(tdTo).datepicker();
	  pickerTo.attr("placeholder", "<v:itl key="@Common.Unlimited" encode="UTF-8"/>");
	  if (validDateTo)
	    pickerTo.datepicker("setDate", xmlToDate(validDateTo));
	  
	  $("<input type='text' name='Description' class='form-control'/>").appendTo(tdDescription).val(description);
	}

	function doRemoveAccessPointDescription() {
	  $("#accesspoint-description-grid tbody .cblist:checked").parents("tr").remove();
	}

function doSave() {
  var metaDataList = prepareMetaDataArray("#apt-form");
  
  if (setAptReentryControl()) {
    if (functionExists("saveAptSettings"))
      saveAptSettings();
    //post("#apt-form", "save");
    
    checkRequired("#apt-form", function() {
      
    var reqDO = {
      Command: "SaveWorkstation",
        SaveWorkstation: {
          Workstation: {
            LocationAccountId		       : <%=wks.LocationAccountId.getJsString()%>,
            WorkstationId              : <%=wks.WorkstationId.getJsString()%>,
            WorkstationType            : <%=wks.WorkstationType.getJsString()%>,
            WorkstationCode            : $("#wks\\.WorkstationCode").val(),
            WorkstationName            : $("#wks\\.WorkstationName").val(),
            CategoryId                 : $("#wks\\.CategoryId").val(),
            OpAreaAccountId            : $("#wks\\.OpAreaAccountId").val(),
            AptAccessAreaIDs		       : $("#wks\\.AptAccessAreaIDs").val(),	
            AptControllerWorkstationId : $("#wks\\.AptControllerWorkstationId").val(),   
            AptCounterMode             : $("#wks\\.AptCounterMode").val(),
            AptEntryControl            : $("[name='wks.AptEntryControl']").val(),
            AptExitControl             : $("[name='wks\\.AptExitControl']").val(),
            AptReentryControl          : $("#wks\\.AptReentryControl").val(),
            AptHardwareCode            : $("#wks\\.AptHardwareCode").val(),
            DriverId                   : $("#wks\\.DriverId").val(),
            QueueControl               : $("#wks\\.QueueControl").isChecked(),
            AptCheckValidPerformance   : $("#wks\\.AptCheckValidPerformance").isChecked(),
            ExitTurnstile              : $("#wks\\.ExitTurnstile").isChecked(),
            AptSettings				         : $("[name='AptSettings']").val(),
            MetaDataList			         : metaDataList,
            APTDescriptionList         : [],
            AptTagIDs                  : $("#wks\\.AptTagIDs").val()
          }
        }
      };
    
      <% if (wks.WorkstationType.isLookup(LkSNWorkstationType.APT)) {%>
	      var trs = $("#accesspoint-description-tbody tr");
	      for (var i=0; i<trs.length; i++) {
	        var aptDesc = {
	          ValidDateFrom: $(trs[i]).find("[name='ValidDateFrom']").getXMLDate(),
	          ValidDateTo: $(trs[i]).find("[name='ValidDateTo']").getXMLDate(),
	          Description: $(trs[i]).find("[name='Description']").val(),
	        };
	        
	        reqDO.SaveWorkstation.Workstation.APTDescriptionList.push(aptDesc);
	      }
	    <% }%>
      
      showWaitGlass();
      vgsService("Workstation", reqDO, false, function(ansDO) {
        hideWaitGlass();
        entitySaveNotification(<%=LkSNEntityType.AccessPoint.getCode()%>, ansDO.Answer.SaveWorkstation.WorkstationId);
      });  
    });
  }
}

</script>
  
</v:page-form>
