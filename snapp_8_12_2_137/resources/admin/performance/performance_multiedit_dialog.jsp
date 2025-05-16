<%@page import="com.vgs.web.library.seat.BLBO_SeatEnvelope"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="perf" class="com.vgs.snapp.dataobject.DOPerformance" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String eventId = null;

String queryBase64 = pageBase.getNullParameter("QueryBase64");
String[] performanceIDs = new String[0];

String sPerformanceIDs = pageBase.getNullParameter("PerformanceIDs");
if (sPerformanceIDs != null) 
  performanceIDs = JvArray.stringToArray(sPerformanceIDs, ",");

if (performanceIDs.length > 0) 
  eventId = pageBase.getBL(BLBO_Performance.class).findPerformanceEventId(performanceIDs[0]);
else if (queryBase64 != null) {
  QueryDef qdef = (QueryDef)JvString.unserializeBase64(queryBase64);
  qdef.selectList.clear();
  qdef.addSelect(QryBO_Performance.Sel.EventId);
  qdef.pagePos = 1;
  qdef.recordPerPage = 1;
  JvDataSet ds = pageBase.execQuery(qdef);
  try {
    eventId = ds.getString(QryBO_Performance.Sel.EventId);
  }
  finally {
    ds.dispose();
  }
}

JvDataSet dsCalendar = pageBase.getBL(BLBO_Calendar.class).getCalendarDS(perf.CalendarId.getString());

boolean canEdit = pageBase.getBL(BLBO_Performance.class).checkRightsNoExceptions(perf.EventId.getString(), perf.PerformanceId.getString());
%>

<v:dialog id="performance_multiedit_dialog" title="@Common.MultiEdit" width="800" height="600" autofocus="false">
  <v:widget caption="@Common.General">
    <v:widget-block>
    
      <v:form-field caption="@Common.Status" checkBoxField="cbPerformanceStatus">
        <v:lk-combobox lookup="<%=LkSN.PerformanceStatus%>" field="PerformanceStatus" allowNull="false"/>
      </v:form-field>
      
      <v:form-field caption="@Performance.PerformanceTypeFromCalendar" checkBoxField="cbPerformanceTypeFromCalendar">
        <select class="form-control" name="PerformanceTypeFromCalendar">
          <option value="false"><v:itl key="@Common.Inactive"/></option>
          <option value="true"><v:itl key="@Common.Active"/></option>
        </select>
      </v:form-field>
      
      <v:form-field caption="@Performance.DynRateCode" checkBoxField="cbDynRateCode">
        <select class="form-control" name="DynRateCode">
          <option value="false"><v:itl key="@Common.Inactive"/></option>
          <option value="true"><v:itl key="@Common.Active"/></option>
        </select>
      </v:form-field>
      
      <v:form-field caption="@Performance.PerformanceType" checkBoxField="cbPerformanceTypeId">
        <% JvDataSet dsPT = pageBase.getBL(BLBO_PerformanceType.class).getDS(eventId); %>
        <v:combobox idFieldName="PerformanceTypeId" captionFieldName="PerformanceTypeName" lookupDataSet="<%=dsPT%>" name="PerformanceTypeId"/>
      </v:form-field>
      
      <v:form-field caption="@Performance.Duration" checkBoxField="cbDuration">
        <input type="text" name="Duration" class="form-control" placeholder="<v:itl key="@Performance.Minutes"/>"/>
      </v:form-field>
      
      <v:form-field caption="@Performance.DeltaPriceValue" checkBoxField="cbDeltaPrice">
        <input type="text" name="DeltaPrice" class="form-control"/>
      </v:form-field>
      
      <v:form-field caption="@Common.RestrictOpenOrder" checkBoxField="cbRestrictOpenOrder">
        <select class="form-control" name="RestrictOpenOrder">
          <option value="false"><v:itl key="@Common.Inactive"/></option>
          <option value="true"><v:itl key="@Common.Active"/></option>
        </select>
      </v:form-field>
      <v:form-field caption="@Common.Description" checkBoxField="cbPerformanceName">
        <input type="text" name="PerformanceName" class="form-control"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="@Common.Admission" checkBoxField="cbAdmission">
        <v:form-field caption="@Account.Location"><snp:dyncombo id="PME-Location-Select" entityType="<%=LkSNEntityType.Location%>"/></v:form-field>
        <v:form-field caption="@Account.AccessArea"><snp:dyncombo id="PME-AccessArea-Select" entityType="<%=LkSNEntityType.AccessArea%>" parentComboId="PME-Location-Select"/></v:form-field>
      </v:form-field>      
      <v:form-field caption="@Event.AdmissionOpenMins" hint="@Event.AdmissionOpenMinsHint" checkBoxField="cbAdmissionOpenMins">
        <% String placeHolder = perf.Default_AdmissionOpenMins.isNull("@Event.AdmissionOpenMinsPlaceholder"); %>
        <input type="text" name="perf.AdmissionOpenMins" class="form-control" placeholder="<v:itl key="<%=placeHolder%>"/>" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Event.AdmissionCloseMins" hint="@Event.AdmissionCloseMinsHint" checkBoxField="cbAdmissionCloseMins">
        <% String placeHolder = perf.Default_AdmissionCloseMins.isNull("@Event.AdmissionCloseMinsPlaceholder"); %>
        <input type="text" name="perf.AdmissionCloseMins" class="form-control" placeholder="<v:itl key="<%=placeHolder%>"/>" enabled="<%=canEdit%>"/>
      </v:form-field> 
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="@Seat.LimitedCapacity" checkBoxField="cbLimitedCapacity">
        <v:grid>
          <thead>
            <tr>
              <td><v:grid-checkbox header="true"/></td>
              <td width="40%"><v:itl key="@Seat.Category"/></td>
              <td width="40%"><v:itl key="@Seat.Envelope"/></td>
              <td width="20%"><v:itl key="@Common.Quantity"/></td>
            </tr>
          </thead>
          <tbody id="capacity-category-tbody"></tbody>
          <tbody id="capacity-templates" class="hidden">
            <tr class="capacity-row-template">
              <td><v:grid-checkbox/></td>
              <td>
                <v:combobox 
                    name="SeatCategoryId"
                    lookupDataSet="<%=pageBase.getBL(BLBO_Seat.class).getSeatCategoryDS()%>" 
                    idFieldName="AttributeItemId" 
                    captionFieldName="AttributeItemName" 
                    groupFieldName="AttributeId" 
                    groupLabelFieldName="AttributeName"
                    allowNull="false"
                />
              </td>
              <td>
                <v:combobox 
                    name="SeatEnvelopeId"
                    lookupDataSet="<%=pageBase.getBL(BLBO_SeatEnvelope.class).getSeatEnvelopeDS()%>" 
                    idFieldName="SeatEnvelopeId" 
                    captionFieldName="SeatEnvelopeName"
                    allowNull="false"
                />
              </td>
              <td><v:input-text field="Quantity"/></td>
            </tr>
          </tbody>
          <tbody>
            <tr>
              <td colspan="100%">
                <v:button id="btn-capacity-add" caption="@Common.Add" fa="plus"/>
                <v:button id="btn-capacity-del" caption="@Common.Remove" fa="minus"/>
              </td>
            </tr>
          </tbody>
        </v:grid>
      </v:form-field>
      <v:form-field caption="@Seat.RemoveSeatEnvelopes" checkBoxField="cbRemoveSeatEnvelopes">
        <% JvDataSet dsRemoveSeatEnvelope = pageBase.getBL(BLBO_SeatEnvelope.class).getSeatEnvelopeDS(); %>
        <v:multibox field="RemoveSeatEnvelopeIDs" lookupDataSet="<%=dsRemoveSeatEnvelope%>" idFieldName="SeatEnvelopeId" captionFieldName="SeatEnvelopeName"/>
      </v:form-field>
    </v:widget-block>
        
    <v:widget-block>
      <v:form-field caption="@Common.Tags" checkBoxField="cbTags">
        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Performance); %>
        <v:multibox field="TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
        <label align="left"><input type="radio" name="TagOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
        <label><input type="radio" name="TagOperation" value="remove"><v:itl key="@Common.Remove"/></label>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="@Common.Calendar" hint="@Performance.CalendarHint" checkBoxField="cbCalendar">
        <v:combobox field="perf.CalendarId" idFieldName="CalendarId" captionFieldName="CalendarName" lookupDataSet="<%=dsCalendar%>" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    
    <% boolean tabResource = rights.ResourceManagement.canUpdate() && pageBase.getBL(BLBO_Event.class).hasResourceManagement(eventId); %>
    <% if (tabResource) { %>
      <v:widget-block>
        <v:form-field caption="@Resource.Resources" checkBoxField="cbResources">
          <% for (DOResourceConfigRes rescfg : pageBase.getBL(BLBO_Resource.class).getResourceConfigList(eventId)) { %>
            <% for (int i=0; i<rescfg.Quantity.getInt(); i++) { %>
              <%
              String resourceTypeId = rescfg.ResourceTypeId.getString();
              JvDataSet dsResource = pageBase.getBL(BLBO_Resource.class).getResourceDS(resourceTypeId); 
              %>
              <div class="form-field resource-type" data-ResourceTypeId="<%=resourceTypeId%>">
                <div class="form-field-caption"><%=rescfg.ResourceTypeName.getHtmlString()%></div>
                <div class="form-field-value"><v:combobox idFieldName="EntityId" captionFieldName="EntityName" lookupDataSet="<%=dsResource%>" /></div>
              </div>
            <% } %>
          <% } %>
        </v:form-field>
      </v:widget-block>
    <% } %>
    
  </v:widget>
  
<script>
$(document).ready(function() {
  var $dlg = $("#performance_multiedit_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Ok" encode="JS"/>: doUpdatePerformances,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
  $dlg.find("#btn-capacity-add").click(doCapacityAdd);
  $dlg.find("#btn-capacity-del").click(doCapacityDel);
  
  function doCapacityAdd() {
    $dlg.find("#capacity-templates .capacity-row-template").clone().appendTo($dlg.find("#capacity-category-tbody"));
  }
  
  function doCapacityDel() {
    $dlg.find("#capacity-category-tbody .cblist:checked").closest("tr").remove();
  }


  function doUpdatePerformances() {
    var reqDO = {
      Command: "Update",
      Update: {
        PerformanceIDs: <%=JvString.jsString(sPerformanceIDs)%>,
        QueryBase64: <%=JvString.jsString(queryBase64)%>
      }
    };
    
    if ($dlg.find("[name='cbPerformanceStatus']").isChecked())
      reqDO.Update.PerformanceStatus = $dlg.find("[name='PerformanceStatus']").val();
    
    if ($dlg.find("[name='cbDynRateCode']").isChecked())
      reqDO.Update.DynRateCode = $dlg.find("[name='DynRateCode']").val();
    
    if ($dlg.find("[name='cbPerformanceTypeFromCalendar']").isChecked())
      reqDO.Update.PerformanceTypeFromCalendar = $dlg.find("[name='PerformanceTypeFromCalendar']").val();
    
    if ($dlg.find("[name='cbPerformanceTypeId']").isChecked())
      reqDO.Update.PerformanceTypeId = $dlg.find("[name='PerformanceTypeId']").val();
    
    if ($dlg.find("[name='cbDuration']").isChecked())
      reqDO.Update.Duration = $dlg.find("[name='Duration']").val();
    
    if ($dlg.find("[name='cbDeltaPrice']").isChecked())
      reqDO.Update.DeltaPrice = strToIntDef($dlg.find("[name='DeltaPrice']").val(), null);
    
    if ($dlg.find("[name='cbRestrictOpenOrder']").isChecked())
      reqDO.Update.RestrictOpenOrder = $dlg.find("[name='RestrictOpenOrder']").val();
    
    if ($dlg.find("[name='cbPerformanceName']").isChecked())
        reqDO.Update.PerformanceName = $dlg.find("[name='PerformanceName']").val();
    
    if ($dlg.find("[name='cbAdmission']").isChecked()) {
      reqDO.Update.LocationId = $dlg.find("#PME-Location-Select").val();
      reqDO.Update.AccessAreaId = $dlg.find("#PME-AccessArea-Select").val();  
    }
    
    if ($dlg.find("[name='cbAdmissionOpenMins']").isChecked())
      reqDO.Update.AdmissionOpenMins = $dlg.find("[name='perf.AdmissionOpenMins']").val();
        
    if ($dlg.find("[name='cbAdmissionCloseMins']").isChecked())
      reqDO.Update.AdmissionCloseMins = $dlg.find("[name='perf.AdmissionCloseMins']").val();        

    if ($dlg.find("[name='cbTags']").isChecked()) {
      reqDO.Update.TagOperation = $dlg.find("[name='TagOperation']:checked").val();
      reqDO.Update.TagIDs =  $dlg.find("#TagIDs").getStringArray();
    }
    
    if ($dlg.find("[name='cbCalendar']").isChecked())
      reqDO.Update.CalendarId = $dlg.find("[name='perf.CalendarId']").val();
    
    if ($dlg.find("[name='cbResources']").isChecked()) {
      reqDO.Update.ResourceTypeList = [];
      
      var rts = $(".resource-type");
      for (var i=0; i<rts.length; i++) {
        var resourceTypeId = $(rts[i]).attr("data-ResourceTypeId");
        var entityId = $(rts[i]).find("select").val();
        
        if (entityId != "") {
          var found = false;
          for (var k=0; k<reqDO.Update.ResourceTypeList.length; k++) {
            if (reqDO.Update.ResourceTypeList[k].ResourceTypeId == resourceTypeId) {
              reqDO.Update.ResourceTypeList[k].EntityIDs.push(entityId);
              found = true;
              break;
            }
          }
          
          if (!found) {
            reqDO.Update.ResourceTypeList.push({
              ResourceTypeId: resourceTypeId,
              EntityIDs: [entityId]
            });
          }
        }
      }
    }
    
    if ($dlg.find("[name='cbLimitedCapacity']").isChecked()) {
      reqDO.Update.SeatCapacityList = [];
      $dlg.find("#capacity-category-tbody .capacity-row-template").each(function(index, item) {
        var $tr = $(item);
        reqDO.Update.SeatCapacityList.push({
          "SeatCategoryId": $tr.find("[name='SeatCategoryId']").val(),
          "SeatEnvelopeId": $tr.find("[name='SeatEnvelopeId']").val(),
          "Quantity": $tr.find("[name='Quantity']").val()
        });
      });
    }
    
    if ($dlg.find("[name='cbRemoveSeatEnvelopes']").isChecked()) {
    	reqDO.Update.RemoveSeatEnvelopeList = [];
    	var removeSeatEnvelopeIDs = $dlg.find("#RemoveSeatEnvelopeIDs").getStringArray();
    	for (var i=0; i<removeSeatEnvelopeIDs.length; i++)
    		reqDO.Update.RemoveSeatEnvelopeList.push({"SeatEnvelopeId": removeSeatEnvelopeIDs[i]});
    }

    vgsService("Performance", reqDO, false, function(ansDO) {
      showAsyncProcessDialog(ansDO.Answer.Update.AsyncProcessId);
      $("#performance_multiedit_dialog").dialog("close");
    });
  }
});

</script>

</v:dialog>



