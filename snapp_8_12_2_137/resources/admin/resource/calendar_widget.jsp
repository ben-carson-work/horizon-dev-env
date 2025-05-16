<%@page import="java.util.Calendar"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageCalendarWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
LookupItem entityType = pageBase.getLkParameter(LkSN.EntityType, "EntityType");
String entityId = pageBase.getNullParameter("EntityId");

JvDataSet dsUnit = null;
if (entityType.isLookup(LkSNEntityType.ResourceType, LkSNEntityType.Location)) 
  dsUnit = pageBase.getBL(BLBO_Resource.class).getUnitDS(entityType, entityId);
request.setAttribute("dsUnit", dsUnit);

JvDataSet dsEvent = pageBase.getBL(BLBO_Resource.class).getEventDS(entityType, entityId);
request.setAttribute("dsEvent", dsEvent);

String localeFileName = "/libraries/scheduler/locale/locale_" + pageBase.getLangISO() + ".js";
boolean localeFileExists = JvIO.filedirExists(pageContext.getServletContext().getRealPath(localeFileName));
%>

<script src="<v:config key="site_url"/>/libraries/scheduler/dhtmlxscheduler.js" type="text/javascript" charset="utf-8"></script>
<script src="<v:config key="site_url"/>/libraries/scheduler/ext/dhtmlxscheduler_units.js" type="text/javascript" charset="utf-8"></script>
<script src="<v:config key="site_url"/>/libraries/scheduler/ext/dhtmlxscheduler_all_timed.js" type="text/javascript" charset="utf-8"></script>
<% if (localeFileExists) { %>
  <script src="<v:config key="site_url"/><%=localeFileName%>" type="text/javascript" charset="utf-8"></script>
<% } %>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/scheduler/dhtmlxscheduler.css" type="text/css" media="screen" title="no title">

<div class="tab-content cal-tab no-select">

  <div id="scheduler_here" class="dhx_cal_container">
    <div class="dhx_cal_navline">
      <div class="dhx_cal_prev_button">&nbsp;</div>
      <div class="dhx_cal_next_button">&nbsp;</div>
      <div class="dhx_cal_today_button"></div>
      <div class="dhx_cal_date"></div>
      <input type="text" id="txt-cal-datepicker" class="form-control">
      
      <div class="dhx_cal_tab" <%="name=\"day_tab\""%> style="right:204px;"></div>
      <div class="dhx_cal_tab" <%="name=\"week_tab\""%> style="right:140px;"></div>
      <div class="dhx_cal_tab" <%="name=\"month_tab\""%> style="right:76px;"></div>
      <% if (entityType.isLookup(LkSNEntityType.ResourceType, LkSNEntityType.Location)) { %>
        <div class="dhx_cal_tab" <%="name=\"unit_tab\""%> style="right:280px;"></div>
      <% } %>
    </div>
    <div class="dhx_cal_header">
    </div>
    <div class="dhx_cal_data">
    </div>
  </div>
  <div class="cal-wait-glass v-hidden"></div>

  <div id="resource-menu" class="cal-resource-menu">
    <input type="text" id="txtResourceFullText" placeholder="<v:itl key="@Common.FullSearch"/>" onkeyup="applyResourceFilter()"/>
    <% if (entityType.isLookup(LkSNEntityType.Location, LkSNEntityType.ResourceType)) { %>
      <div style="padding:6px;text-align:center">
        <v:button id="btn-filters" caption="@Common.Filters" fa="filter"/>
      </div>
    <% } %>
    <div class="cal-resource-list">
    <% String resourceTypeId = entityType.isLookup(LkSNEntityType.ResourceType) ? entityId : null; %>
    <% JvDataSet dsResource = pageBase.getBL(BLBO_Resource.class).getResourceDS(resourceTypeId); %>
    <% while (!dsResource.isEof()) { %>
      <% LookupItem resourceEntityType = LkSN.EntityType.getItemByCode(dsResource.getField("EntityType")); %>
      <div class="cal-resource" 
          data-EntityType="<%=resourceEntityType.getCode()%>" 
          data-EntityId="<%=dsResource.getField("EntityId").getHtmlString()%>" 
          data-ResourceTypeIDs="<%=dsResource.getField("ResourceTypeIDs").getHtmlString()%>" 
          data-ResourceSkillIDs="<%=dsResource.getField("ResourceSkillIDs").getHtmlString()%>">
        <v:grid-icon name="<%=BLBO_Account.findAccountIconName(resourceEntityType)%>" repositoryId="<%=dsResource.getField(\"ProfilePictureId\").getString()%>"/>
        <div class="cal-resource-name"><%=dsResource.getField("EntityName").getHtmlString()%></div>
      </div>
      <% dsResource.next(); %>
    <% } %>
    </div>
  </div>
  
</div>

<div id="event-select-dialog" class="v-hidden" title="<v:itl key="@Resource.SelectAnEvent"/>">
  <v:grid>
    <v:ds-loop dataset="<%=dsEvent%>">
    <tr class="grid-row" data-EventId="<%=dsEvent.getField(QryBO_Event.Sel.EventId).getHtmlString()%>">
      <td><v:grid-icon name="<%=dsEvent.getField(QryBO_Event.Sel.IconName).getString()%>" repositoryId="<%=dsEvent.getField(QryBO_Event.Sel.ProfilePictureId).getString()%>"/></td>
      <td width="100%">
        <span class="list-title"><%=dsEvent.getField(QryBO_Event.Sel.EventName).getHtmlString()%></span><br/>
        <span class="list-subtitle"><%=dsEvent.getField(QryBO_Event.Sel.EventCode).getHtmlString()%></span>
      </td>
    </tr>
    </v:ds-loop>
  </v:grid>
</div>

<div id="filter-tooltip-template" class="v-hidden">
  <div class="filter-tooltip-content">
    <div class="filter-tooltip-rtype-list">
      <% JvDataSet dsResourceType = pageBase.getBL(BLBO_Resource.class).getResourceTypeDS(null); %>
      <v:ds-loop dataset="<%=dsResourceType%>">
        <%
        resourceTypeId = dsResourceType.getField("ResourceTypeId").getString();
        boolean acceptRT = true;
        if (entityType.isLookup(LkSNEntityType.ResourceType))
          acceptRT = JvString.isSameText(resourceTypeId, entityId);
        %>
        <% if (acceptRT) { %>
          <div class="cal-rtype noselect" data-ResourceTypeId="<%=resourceTypeId%>">
            <img class="list-icon" src="<v:image-link name="<%=LkSNEntityType.ResourceType.getIconName()%>" size="32"/>" width="32" height="32"/>
            <div class="cal-rtype-name"><%=dsResourceType.getField("ResourceTypeName").getHtmlString()%></div>
            <div class="cal-rtype-code"><%=dsResourceType.getField("ResourceTypeCode").getHtmlString()%></div>
          </div>
        <% } %>
      </v:ds-loop>
    </div>
    <div class="filter-tooltip-rtype-detail">
      <div class="filter-tooltip-rtype-detail-title"><v:itl key="@Resource.Skills"/></div>
      <div class="filter-tooltip-rtype-detail-empty"><v:itl key="@Resource.NoSkills"/></div>
      <v:ds-loop dataset="<%=dsResourceType%>">
        <% resourceTypeId = dsResourceType.getField("ResourceTypeId").getString(); %>
        <% JvDataSet dsSkill = pageBase.getBL(BLBO_Resource.class).getResourceSkillDS(resourceTypeId, false); %>
        <v:ds-loop dataset="<%=dsSkill%>">
          <% String resourceSkillId = dsSkill.getField("ResourceSkillId").getString(); %>
          <% if (resourceSkillId != null) { %>
            <div class="cal-rskill v-hidden" data-ResourceTypeId="<%=resourceTypeId%>">
              <label class="checkbox-label">
                <input type="checkbox" value="<%=resourceSkillId%>"/>
                <%=dsSkill.getField("ResourceSkillName").getHtmlString()%>
              </label>
            </div>
          <% } %>
        </v:ds-loop>
      </v:ds-loop>
      <div class="filter-tooltip-rtype-detail-match">
        <b><v:itl key="@Common.Matches"/>:</b> <span class="filter-match-quantity"></span>
        <a href="javascript:$('#btn-filters').popover('hide')" style="float:right"><v:itl key="@Common.Apply"/></a>
      </div>
    </div>
  </div>
</div>

<style>
#txt-cal-datepicker {
  position: absolute;
  top: 14px;
  left: 211px;
  width: 100px;
  height: 32px;
}

<% if (entityType.isLookup(LkSNEntityType.ResourceType, LkSNEntityType.Location)) { %>
  #txt-cal-datepicker {
    left: 295px;
  }
<% } %>

<%if (entityType.isLookup(LkSNEntityType.Person, LkSNEntityType.Resource)) {%>
  .dhx_cal_container {
    right: 0;
  }
  .cal-resource-menu {
    display: none;
  }
<%}%>
</style>

<%!
private String newActionDialogHREF(LookupItem entityType) {
  return "javascript:newActionDialog(" + entityType.getCode() + ")";
}
%>

<v:popup-menu id="calendar-popup-menu">
  <v:popup-item caption="@Common.New" href="#"/>
  <v:popup-divider/>
  <v:popup-item caption="@Performance.Performance" icon="calendar.png" href="javascript:newPerformanceDialog()"/>
  <v:popup-divider/>
  <v:popup-item caption="@Action.Activity" icon="action_activity.png" href="<%=newActionDialogHREF(LkSNEntityType.Activity)%>"/>
  <v:popup-item caption="@Action.PhoneCall" icon="action_phonecall.png" href="<%=newActionDialogHREF(LkSNEntityType.PhoneCall)%>"/>
  <v:popup-item caption="@Action.Meeting" icon="action_meeting.png" href="<%=newActionDialogHREF(LkSNEntityType.Meeting)%>"/>
  <v:popup-item caption="@Action.OffDuty" icon="action_offduty.png" href="<%=newActionDialogHREF(LkSNEntityType.OffDuty)%>"/>
</v:popup-menu>


<script>

var units = [];
var selResourceTypeId = null;
var selResourceSkillIDs = [];

$(document).ready(function() {
  <%if (entityType.isLookup(LkSNEntityType.ResourceType, LkSNEntityType.Location)) {%>
    <v:ds-loop dataset="<%=dsUnit%>">
      units.push({
        key: "<%=dsUnit.getField("EntityId").getHtmlString()%>", 
        label: buildUnitHeader(<%=dsUnit.getField("EntityType").getInt()%>, "<%=dsUnit.getField("EntityId").getHtmlString()%>", "<%=dsUnit.getField("EntityName").getHtmlString()%>"),
        EntityType: <%=dsUnit.getField("EntityType").getInt()%>
      });    
    </v:ds-loop>                    

    <%if (entityType.isLookup(LkSNEntityType.ResourceType)) {%>
      scheduler.locale.labels.unit_tab = <v:itl key="@Resource.Resources" encode="JS"/>;
    <%} else if (entityType.isLookup(LkSNEntityType.Location)) {%>
      scheduler.locale.labels.unit_tab = <v:itl key="@Event.Events" encode="JS"/>;
    <%}%>

    scheduler.createUnitsView({
      name: "unit",
      property: "unit_id",
      list: units,
      size: 10,
      step: 9
    });
  <%}%>
  
  $("#btn-filters").attr("data-content", $("#filter-tooltip-template").html()).popover({
    container: "body",
    placement: "auto bottom",
    trigger: "click",
    html: true
  });

  <% if (entityType.isLookup(LkSNEntityType.ResourceType)) { %>
    selResourceTypeId = <%=JvString.jsString(entityId)%>;
	<% } %>
	<% if (entityType.isLookup(LkSNEntityType.Location)) { %>
	  $(document).on("click", ".cal-rtype", function() {
      selResourceTypeId = $(this).is(".selected") ? null : $(this).attr("data-ResourceTypeId");
      selResourceSkillIDs = [];
      refreshRTypeFilter();
      applyResourceFilter();
	  });
	<% } %>
	
  $(document).on("click", ".cal-rskill input", function() {
    var rskillInputs = $(".popover-content .cal-rskill input"); 
    selResourceSkillIDs = [];
    rskillInputs.filter(":checked").each(function() {
      selResourceSkillIDs.push($(this).val());
    });
    applyResourceFilter();
  });
  
  var step = 15;
  var format = scheduler.date.date_to_str("%H:%i");
  
  scheduler.config.hour_size_px=(60/step)*22;
  scheduler.templates.hour_scale = function(date) {
    html="";
    for (var i=0; i<60/step; i++){
      html+="<div style='height:22px;line-height:22px;'>"+format(date)+"</div>";
      date = scheduler.date.add(date,step,"minute");
    }
    return html;
  };
  
  scheduler.config.xml_date="%Y-%m-%d %H:%i";
  scheduler.config.drag_create = false;
  scheduler.config.dblclick_create = false;
  scheduler.config.all_timed = true;
  scheduler.config.start_on_monday = <%=(rights.FirstDayOfWeek.getInt() == Calendar.MONDAY)%>;
  scheduler.init('scheduler_here',new Date(),"week");
});

var lastDroppedEntityId = null;
$(".cal-resource").draggable({
  helper: "clone",
  appendTo: "body",
  cursor: "move",
  cursorAt: {
    top: 0,
    left: 100
  },
  start: function(event, ui) {
    $(ui.helper).addClass("cal-resource-draghelper");
  },
  drag: function(event, ui) {
    if (scheduler.getState().mode != "month") {
      var x = event.pageX - $(".dhx_cal_data").offset().left;
      var y = event.pageY - $(".dhx_cal_data").offset().top + $(".dhx_cal_data").scrollTop();
      
      var row = $(".cal-row-selector");
      if (row.length == 0)
        row = $("<div class='cal-selector cal-row-selector'/>").appendTo(".dhx_cal_data");

      row.css("top", y);
      
      var dt = scheduler.getActionData(event).date;
      row.html("<span class='cal-selector-date'>" + scheduler.templates.day_date(dt) + "</span><span class='cal-selector-time'>" + scheduler.templates.event_date(dt) + "</span>");
      
      var childs = $(".dhx_cal_data").children();
      for (var i=0; i<childs.length; i++) {
        var child = $(childs[i]);
        if (child.hasClass("dhx_scale_holder") || child.hasClass("dhx_scale_holder_now")) {
          if ((x >= child.position().left) && (x <= child.position().left + child.width())) {
            var col = $(".cal-col-selector");
            if (col.length == 0)
              col = $("<div class='cal-selector cal-col-selector'/>").appendTo(".dhx_cal_data");
            col.css({
              left: child.position().left,
              width: child.width() + "px",
              top: 0,
              height: child.height() + "px"
            });
          }
        }
      }
    }
  },
  stop: function(event, ui) {
    $(".cal-selector").remove();
  }
});
$("#scheduler_here .dhx_cal_data").droppable({
  accept: ".cal-resource",
  drop: function(event, ui) {
    if ($(this).find(".cal-event-dragover").length <= 0) {
      lastActionData = scheduler.getActionData(event);
      lastDroppedEntityId = $(ui.draggable).attr("data-EntityId");
      setTimeout(newPerformanceDialog, 0);
    }
  }
});

//--- Method: SelectRTypeFilter ---//
function refreshRTypeFilter() {
  var cont = $(".filter-tooltip-content"); 
  cont.find(".cal-rtype.selected").removeClass("selected");
  cont.find(".cal-rskill").addClass("v-hidden");
  cont.find(".filter-tooltip-rtype-detail-empty").removeClass("v-hidden");
  
  if (selResourceTypeId != null) {
    cont.find(".cal-rtype[data-ResourceTypeId='" + selResourceTypeId + "']").addClass("selected");
    
    var skills = cont.find(".cal-rskill[data-ResourceTypeId='" + selResourceTypeId + "']");
    if (skills.length > 0) {
      skills.removeClass("v-hidden");
      cont.find(".filter-tooltip-rtype-detail-empty").addClass("v-hidden");
      
      skills.find("input").setChecked(false);
      if (selResourceSkillIDs) {
        for (var i=0; i<selResourceSkillIDs.length; i++) 
          skills.find("input[value='" + selResourceSkillIDs[i] + "']").setChecked(true);
      }
    }
  }
  
}

//--- Method: ReloadData ---//
var lastView = null;
function reloadData() {
  $(".cal-wait-glass").removeClass("v-hidden");
  
  var newView = scheduler.getState().mode;
  if (lastView != newView) {
    lastView = newView;
    if (newView != "month")
      $(".dhx_cal_data").scrollTop(700);
  }

  var reqDO = {
    Command: "GetSchedule",
    GetSchedule: {
      EntityType: <%=entityType.getCode()%>,
      EntityId: "<%=entityId%>",
      DateTimeFrom: scheduler.getState().min_date.toJSON(),
      DateTimeTo: scheduler.getState().max_date.toJSON(),
      UnitView: (scheduler.getState().mode == "unit")
    }
  };
 
  vgsService("Performance", reqDO, false, function(ansDO) {
    var items = [];
    if ((ansDO.Answer) && (ansDO.Answer.GetSchedule)) {
      for (var i=0; i<ansDO.Answer.GetSchedule.ScheduleList.length; i++) {
        var item = ansDO.Answer.GetSchedule.ScheduleList[i];
        items.push({
          text: item.Title,
          start_date: xmlToDate(item.DateTimeFrom), 
          end_date: xmlToDate(item.DateTimeTo), 
          unit_id: item.UnitId,
          vgsdata: item
        });
      }
    }
    
    scheduler.clearAll();
    scheduler.parse(items, "json");
    $(".cal-wait-glass").addClass("v-hidden");
  });
}

//--- Event: OnViewChange ---//
scheduler.attachEvent("onViewChange", reloadData);
//--- Event: OnSchedulerChange ---//
$(document).on("OnSchedulerChange", reloadData);

//--- Method: buildUnitHeader ---//
function buildUnitHeader(entityType, entityId, entityName) {
  var urlo = null;
  if (entityType == <%=LkSNEntityType.Event.getCode()%>) 
    urlo = "<v:config key="site_url"/>/admin?page=event&id=" + entityId;
  else if ($.inArray(entityType, [<%=LkSNEntityType.Resource.getCode()%>, <%=LkSNEntityType.Person.getCode()%>])) 
    urlo = "<v:config key="site_url"/>/admin?page=account&id=" + entityId;

  if (urlo == null)
    return entityName;
  else 
    return "<a href='" + urlo + "'>" + entityName + "</a>";
}

//--- Method: GetUnitEntityType ---// 
function getUnitEntityType(entityId) {
  for (var i=0; i<units.length; i++) {
    if (units[i].key == entityId)
      return units[i].EntityType;
  }
  return null;
}

//--- Event: OnClick ---//
scheduler.attachEvent("onClick", function (id, e) {
  var ev = scheduler.getEvent(id);
  if (ev.vgsdata.EntityType == <%=LkSNEntityType.Performance.getCode()%>)
    asyncDialogEasy("performance/performance_dialog", "id=" + ev.vgsdata.Performance.PerformanceId);
  else
    asyncDialogEasy("action/action_dialog", "id=" + ev.vgsdata.Action.ActionId);
});

//--- Event: OnSchedulerClick ---//
var lastActionData = null;
$("#scheduler_here .dhx_cal_data").click(function() {
  if ($(event.target).hasClass("dhx_scale_holder") || $(event.target).hasClass("dhx_scale_holder_now")) {
    lastActionData = scheduler.getActionData(event);
    <%if (entityType.isLookup(LkSNEntityType.Location)) {%>
      newPerformanceDialog();
    <%} else {%>
      popupMenu("#calendar-popup-menu", null, event);
    <%}%>
  } 
});

//-- Method: selectEvent ---//
var selectEvent_CallBack = null;
function selectEvent(callback) {
  var eventId = null;
  
  <%if (entityType.isLookup(LkSNEntityType.Location)) {%>
    if (lastActionData.section)
      eventId = lastActionData.section;
  <%}%> 
  <%if (dsEvent.getRecordCount() == 1) {%>
    eventId = "<%=dsEvent.getField("EventId").getHtmlString()%>";      
  <%}%>
  
  if (eventId != null)
    callback(eventId);
  else {
    selectEvent_CallBack = callback;
    $("#event-select-dialog").dialog({
      modal: true,
      width: 350,
      height: 500
    });
  }
}

//--- Event: EventDialog.RowClick ---//
$("#event-select-dialog tr").click(function() {
  $("#event-select-dialog").dialog("close");
  selectEvent_CallBack($(this).attr("data-EventId"));
});

//--- Method: NewPerformance ---//
function newPerformanceDialog() {
  var unitId = null;
  var locationId = null;

  <%if (entityType.isLookup(LkSNEntityType.Resource, LkSNEntityType.Person)) {%>
    unitId = "<%=entityId%>"; 
    <%} else if (entityType.isLookup(LkSNEntityType.ResourceType)) {%>
    unitId = (lastActionData.section) ? lastActionData.section : lastDroppedEntityId; 
  <%} else if (entityType.isLookup(LkSNEntityType.Location)) {%>
    locationId = "<%=entityId%>"; 
    unitId = lastDroppedEntityId;
    lastDroppedEntityId = null;
  <%}%>
  
  selectEvent(function(eventId) {
    var params = "id=new&EventId=" + eventId + "&DateTimeFrom=" + dateToXML(lastActionData.date) + "DateTimeTo=" + dateToXML(lastActionData.date);
    if (unitId)
      params += "&ResourceId=" + unitId;
    if (locationId)
      params += "&LocationId=" + locationId;
    
    asyncDialogEasy("performance/performance_dialog", params);
  });
}

//--- Method: NewAction ---//
function newActionDialog(entityType) {
  var unitId = "";
  <%if (entityType.isLookup(LkSNEntityType.Resource, LkSNEntityType.Person)) {%>
    unitId = "<%=entityId%>"; 
  <%} else if (entityType.isLookup(LkSNEntityType.ResourceType)) {%>
    unitId = (lastActionData.section) ? lastActionData.section : ""; 
  <%}%>

  var params = "id=new";
  params += "&AssigneeAccountId=" + unitId;
  params += "&EntityType=" + entityType;
  params += "&DateTimeFrom=" + dateToXML(lastActionData.date);
  params += "&DateTimeTo=" + dateToXML(lastActionData.date);
  asyncDialogEasy("action/action_dialog", params);
}

//--- Method: LoadPerformance ---//
function loadPerformance(performanceId, callback) {
  var reqDO = {
    Command: "LoadPerformance",
    LoadPerformance: {
      PerformanceId: performanceId
    }
  };
  
  vgsService("Performance", reqDO, false, function(ansDO) {
    callback(ansDO.Answer.LoadPerformance.Performance);
  });
}

//--- Method: SavePerformance ---//
function savePerformance(perf) {
  var reqDO = {
    Command: "SavePerformance",
    SavePerformance: {
      Performance: perf
    }
  };
  
  vgsService("Performance", reqDO, true, function(ansDO) {
    var error = getVgsServiceError(ansDO);
    if (error != null)
      showIconMessage("warning", error);
    reloadData();
  });
}

//--- Method: UpdatePerformance ---//
function updatePerformance(ev) {
  loadPerformance(ev.vgsdata.Performance.PerformanceId, function(perf) {
    perf.DateTimeFrom = dateToXML(ev.start_date);
    perf.DateTimeTo = dateToXML(ev.end_date);
    
    var srcUnitId = ev.vgsdata.UnitId;
    var dstUnitId = ev.unit_id; 
    if ((srcUnitId) && (dstUnitId) && (srcUnitId != dstUnitId)) {
      var rtList = perf.ResourceTypeList;
      for (var i=0; i<rtList.length; i++) {
        for (var k=0; k<rtList[i].ResourceList.length; k++) {
          if (rtList[i].ResourceList[k].EntityId == srcUnitId) {
            rtList[i].ResourceList[k].EntityId = dstUnitId;
            rtList[i].ResourceList[k].EntityType = getUnitEntityType(dstUnitId);
          }
        }
      }
      perf.ResourceTypeList = rtList;
    }
    
    savePerformance(perf);
  });
}

//--- Method: AddResourceToPerformance ---//
function addResourceToPerformance(entityType, entityId, performanceId) {
  var reqDO = {
    Command: "AddResourceToPerformance",
    AddResourceToPerformance: {
      EntityType: entityType,
      EntityId: entityId,
      PerformanceId: performanceId
    }
  };
  
  vgsService("Resource", reqDO, false, reloadData);
}

//--- Method: LoadAction ---//
function loadAction(actionId, callback) {
  var reqDO = {
    Command: "Load",
    Load: {
      ActionId: actionId
    }
  };
  
  vgsService("Action", reqDO, false, function(ansDO) {
    callback(ansDO.Answer.Load.Action);
  });
}

//--- Method: SaveAction ---//
function saveAction(action) {
  var reqDO = {
    Command: "Save",
    Save: {
      Action: action
    }
  };
    
  vgsService("Action", reqDO, false, reloadData);
}

//--- Method: UpdateAction ---//
function updateAction(ev) {
  loadAction(ev.vgsdata.Action.ActionId, function(action) {
    action.CreateDateTime = dateToXML(ev.start_date);
    action.CloseDateTime = dateToXML(ev.end_date);
    
    var srcUnitId = ev.vgsdata.UnitId;
    var dstUnitId = ev.unit_id; 
    if ((srcUnitId) && (dstUnitId) && (srcUnitId != dstUnitId)) {
      var rtList = action.LinkList;
      for (var i=0; i<rtList.length; i++) {
        if (rtList[i].EntityId == srcUnitId) {
          rtList[i].EntityId = dstUnitId;
          rtList[i].EntityType = getUnitEntityType(dstUnitId);
        } 
      }
      action.LinkList = rtList;
    }
    
    saveAction(action);
  });
}

//--- Method: AddResourceToAction ---//
function addResourceToAction(entityType, entityId, actionId) {
  loadAction(actionId, function(action) {
    action.LinkList = [{
      ActionLinkType: <%=LkSNActionLinkType.Assignee.getCode()%>,
      EntityType: entityType,
      EntityId: entityId
    }];
    
    saveAction(action);
  });
}

//--- Event: OnEventChanged ---//
scheduler.attachEvent("onEventChanged", function(id, ev) {
  if (ev.vgsdata.EntityType == <%=LkSNEntityType.Performance.getCode()%>)
    updatePerformance(ev);
  else
    updateAction(ev);
});

//--- Event: ResourceMenu.Collapse ---//
$(".resource-menu-collapse").click(function() {
  $('.cal-tab').addClass('menu-collapsed');
  scheduler.update_view();
});

//--- Event: ResourceMenu.Expand ---//
$(".resource-menu-expand").click(function() {
  $('.cal-tab').removeClass('menu-collapsed');
  scheduler.update_view();
});

//--- Method: applyResourceFilter ---//
function applyResourceFilter() {
  var qty = 0;
  var fullText = $("#txtResourceFullText").val().toLowerCase();
  var resources = $(".cal-resource");
  for (var i=0; i<resources.length; i++) {
    var name = $(resources[i]).find(".cal-resource-name").html().toLowerCase();
    var visible = 
        ((name == "") || (name.indexOf(fullText) >= 0)) &&
        ((selResourceTypeId == null) || ($(resources[i]).attr("data-ResourceTypeIDs").indexOf(selResourceTypeId) >= 0));
    
    var itemResourceSkillIDs = $(resources[i]).attr("data-ResourceSkillIDs");
    if (visible && (selResourceSkillIDs) && (selResourceSkillIDs.length > 0)) {
      for (var k=0; k<selResourceSkillIDs.length; k++) {
        var skillId = selResourceSkillIDs[k];
        if (itemResourceSkillIDs.indexOf(skillId) < 0) {
          visible = false;
          break;
        }
      }
    }
    
    $(resources[i]).setClass("v-hidden", !visible);
    if (visible)
      qty++;
  }
  
  $(".filter-match-quantity").text(qty);
}

//--- Event: RenderEvent ---//
scheduler.renderEvent = function(container, ev) {
  if (ev.vgsdata == null) 
    return false;
  else {
    var unitsOnTitle = ((ev.vgsdata.MainUnitName) ? ev.vgsdata.MainUnitName : "");
    var units = "";
    if ((ev.vgsdata) && (ev.vgsdata.UnitList)) {
      for (var i=0; i<ev.vgsdata.UnitList.length; i++) {
        var unit = ev.vgsdata.UnitList[i];
        if (unit.VisibleInRecap) {
          units += "<li><a href='<%=pageBase.getContextURL()%>?page=account&id=" + unit.EntityId + "'>" + unit.EntityName + "</a></li>";
          if (unit.EntityId != ev.vgsdata.MainUnitId) {
            if (unitsOnTitle != "")
              unitsOnTitle += " &mdash; "
            unitsOnTitle += unit.EntityName;
          }
        }
      }
    }
    if (units != "")
      units = "<ul>" + units + "</ul>";
    
    var iconURL = (ev.vgsdata.ProfilePictureId) ? "/repository?type=thumb&id=" + ev.vgsdata.ProfilePictureId : "/imagecache?size=32&name=" + ev.vgsdata.IconName;
    var styleCover = (ev.vgsdata.ProfilePictureId) ? "; background-size:contain" : "";
    var icon = "<span class='dhx_event_move cal-event-icon' style=\"background-image:url('<v:config key="site_url"/>" + iconURL + "')" + styleCover + "\"></span>";
    var title1 = "<div class='cal-event-title1'>" + ev.vgsdata.Title + "</div>";
    var title2 = "<div class='cal-event-title2'>" + unitsOnTitle + "</div>";
    var title = "<div class='cal-event-title' title='" + ev.text + "'>" + icon + title1 + title2  + "</div>";
    
    var bottom = "<div class='dhx_event_resize cal-event-footer'></div>";
    

    var body = units;
    
    container.innerHTML = "<div class='cal-event " + ev.vgsdata.StatusClass + "'>" + title + "<div class='cal-event-body'>" + body + "</div>" + bottom + "</div>";
    
    $(container).droppable({
      accept: ".cal-resource",
      over: function(event, ui) {
        $(this).find(".cal-event").addClass("cal-event-dragover");
      },
      out: function(event, ui) {
        $(this).find(".cal-event").removeClass("cal-event-dragover");
      },
      drop: function(event, ui) {
        $(this).find(".cal-event").removeClass("cal-event-dragover");
        
        var entityType = parseInt($(ui.draggable).attr("data-EntityType"));
        var entityId = $(ui.draggable).attr("data-EntityId");
        if (ev.vgsdata.EntityType == <%=LkSNEntityType.Performance.getCode()%>)
          addResourceToPerformance(entityType, entityId, ev.vgsdata.Performance.PerformanceId);
        else
          addResourceToAction(entityType, entityId, ev.vgsdata.Action.ActionId);
      }
    });
    return true;
  }
};

$("#txt-cal-datepicker").datepicker().change(function() {
  scheduler.setCurrentView($(this).datepicker("getDate"));
});


</script>
