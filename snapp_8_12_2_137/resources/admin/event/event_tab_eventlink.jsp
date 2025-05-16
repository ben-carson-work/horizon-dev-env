<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEvent" scope="request"/>
<jsp:useBean id="event" class="com.vgs.snapp.dataobject.DOEvent" scope="request"/>

<%
  QueryDef qdef = new QueryDef(QryBO_Event.class);
  // Select
  qdef.addSelect(QryBO_Event.Sel.EventId);
  qdef.addSelect(QryBO_Event.Sel.EventCode);
  qdef.addSelect(QryBO_Event.Sel.EventName);
  qdef.addSelect(QryBO_Event.Sel.IconName);
  qdef.addSelect(QryBO_Event.Sel.ProfilePictureId);
  // Filter
  qdef.addFilter(QryBO_Event.Fil.ItineraryEventId, pageBase.getId());
  // Sort
  qdef.addSort(QryBO_Event.Sel.ItineraryPriorityOrder);
  // Exec
  JvDataSet ds = pageBase.execQuery(qdef);
%>

<script>

function showEventSearchDialog() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.Event.getCode()%>,
    EventParams: {
      EventTypes: "<%=LkSNEventType.GenAdm.getCode()%>,<%=LkSNEventType.PerfEvent.getCode()%>"
    },
    onPickup: function(item) {
      addChildEvent(item);
      updateEvents();
    }
  });
}

function addChildEvent(item) {
  var tr = $("<tr class='grid-row' data-EventId='" + item.ItemId + "'/>").appendTo("#child-event-grid tbody");
  
  $("<td/>").appendTo(tr).html("<input type='checkbox' class='cblist' name='ChildEventId' value='" + item.ItemId + "'/>");
  
  $("<td/>").appendTo(tr).html("<img class='list-icon' src='" + getVComboIconURL(item.IconName, item.ProfilePictureId) + "'/>");
  
  var tdName = $("<td/>").appendTo(tr);
  tdName.html("<a href='" + item.ItemURL + "'>" + item.ItemName + "</a><br/><span class='list-subtitle'>" + item.ItemCode + "</span>");
  
  $("<td/>").appendTo(tr).html("<img class='sortable-handle row-hover-visible' src='<v:image-link name="move_item.png" size="16"/>'/>");
}

function updateEvents() {
  var childIDs = [];
  var trs = $("#child-event-grid tbody tr");
  for (var i=0; i<trs.length; i++) {
    childIDs.push($(trs[i]).attr("data-EventId"));
  }
  
  vgsService("Event", {
    Command: "UpdateEventItinerary",
    UpdateEventItinerary: {
      EventId: "<%=pageBase.getId()%>",
      ChildEventIDs: childIDs.join()
    }
  });
}

function removeEvents() {
  var cbs = $("#child-event-grid [name='ChildEventId']:checked");
  for (var i=0; i<cbs.length; i++) 
    $(cbs[i]).closest("tr").remove();
  updateEvents();
}

$(document).ready(function() {
  <v:ds-loop dataset="<%=ds%>">
    addChildEvent({
      ItemId: "<%=ds.getField(QryBO_Event.Sel.EventId).getHtmlString()%>",  
      ItemCode: "<%=ds.getField(QryBO_Event.Sel.EventCode).getHtmlString()%>",  
      ItemName: "<%=ds.getField(QryBO_Event.Sel.EventName).getHtmlString()%>",  
      IconName: "<%=ds.getField(QryBO_Event.Sel.IconName).getHtmlString()%>",  
      ProfilePictureId: "<%=ds.getField(QryBO_Event.Sel.ProfilePictureId).getHtmlString()%>"  
    });
  </v:ds-loop>
  
  $("#child-event-grid tbody").sortable({
    handle: ".sortable-handle",
    stop: updateEvents
  });
});

</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Add" fa="plus" href="javascript:showEventSearchDialog()"/>
  <v:button caption="@Common.Remove" fa="minus" href="javascript:removeEvents()"/>
</div>

<div class="tab-content">
  <v:grid id="child-event-grid">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td>&nbsp;</td>
        <td width="100%">
          <v:itl key="@Common.Name"/><br/>
          <v:itl key="@Common.Code"/>
        </td>
        <td></td>
      </tr>
    </thead>
    <tbody>
    </tbody>
  </v:grid>
</div>