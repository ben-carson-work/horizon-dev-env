<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="wks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<v:page-form>

<div class="tab-toolbar">
  <v:button id="btn-add" caption="@Common.Add" fa="plus" title="@Common.Add" enabled="<%=rights.SystemSetupAccessPoints.getOverallCRUD().canCreate()%>"/>
  <v:button id="btn-remove" caption="@Common.Remove" fa="minus" title="@Common.Remove" enabled="<%=rights.SystemSetupAccessPoints.getOverallCRUD().canUpdate()%>"/>
      
  <v:pagebox gridId="accesspoint-grid" />
</div>
    
<div class="tab-content">
  <v:last-error/>
  
  <% String params = "MonitorWorkstationId=" + pageBase.getId(); %>
  <v:async-grid id="accesspoint-grid" jsp="workstation/accesspoint_grid.jsp" params="<%=params%>" />

</div>

<script>

$(document).ready(function() {
  
  $("#btn-add").click(function() {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.AccessPoint.getCode()%>,
      onPickup: function(item) {
        doAddMonitoredAccessPoint(<%=JvString.jsString(pageBase.getId())%>, item.ItemId);
      }
    });
  });

  $("#btn-remove").click(function() {
    var aptWksIDs = $("[name='WorkstationId']").getCheckedValues();
    if (aptWksIDs == "")
      showMessage(itl("@Common.NoElementWasSelected"));
    else {
      confirmDialog(null, function() {
        doRemoveMonitoredAccessPoint(<%=JvString.jsString(pageBase.getId())%>, aptWksIDs.split(","));
      });
    }
  });

  function doAddMonitoredAccessPoint(workstationId, accessPointId) {
    var reqDO = {
      Command: "AddMonitoredAccessPoint",
      AddMonitoredAccessPoint: {
        Workstation: {
          WorkstationId: workstationId
        },
        AccessPointList: [{
          WorkstationId: accessPointId
        }]
      }
    };
    vgsService("Workstation", reqDO, false, function(ansDO) {
      changeGridPage("#accesspoint-grid", 1);
    });
  }

  function doRemoveMonitoredAccessPoint(workstationId, accessPointIDs) {
    var reqDO = {
      Command: "RemoveMonitoredAccessPoint",
      RemoveMonitoredAccessPoint: {
        Workstation: {
          WorkstationId: workstationId
        },
        AccessPointList: []
      }
    };
    for (var i=0; i<accessPointIDs.length; i++) {
      reqDO.RemoveMonitoredAccessPoint.AccessPointList.push({
        WorkstationId: accessPointIDs[i]
      });
    }
    vgsService("Workstation", reqDO, false, function(ansDO) {
      changeGridPage("#accesspoint-grid", 1);
    });
  }
});
 
</script>
</v:page-form>
