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
<% boolean canEdit = rights.SystemSetupAccessPoints.getOverallCRUD().canUpdate(); %>
<v:page-form>

<div class="tab-toolbar">
  <v:button id="btn-add" caption="@Common.Add" fa="plus" title="@Common.Add" enabled="<%=canEdit%>"/>
  <v:button id="btn-remove" caption="@Common.Remove" fa="minus" title="@Common.Remove" enabled="<%=canEdit%>"/>
      
  <v:pagebox gridId="accesspoint-grid" />
</div>
    
<div class="tab-content">
  <v:last-error/>
  
  <% String params = "AptControllerWorkstationId=" + pageBase.getId(); %>
  <v:async-grid id="accesspoint-grid" jsp="workstation/accesspoint_grid.jsp" params="<%=params%>" />

</div>

<script>

$(document).ready(function() {
  
  $("#btn-add").click(function() {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.AccessPoint.getCode()%>,
      onPickup: function(item) {
        checkAccessPoint(item.ItemId, function(apt) {
          if (apt.ControllerWorkstationId == null)
            doChangeAccessPointController(<%=JvString.jsString(pageBase.getId())%>, item.ItemId);
          else if (apt.ControllerWorkstationId == <%=JvString.jsString(pageBase.getId())%>)
            showMessage(itl("@AccessPoint.AptAlreadySelected"));
          else {
            confirmDialog(itl("@AccessPoint.AptAlreadyControlledByOther", apt.ControllerWorkstationName), function() {
              doChangeAccessPointController(<%=JvString.jsString(pageBase.getId())%>, item.ItemId);
            });
          }
        });
      }
    });
  });

  $("#btn-remove").click(function() {
    var aptWksIDs = $("[name='WorkstationId']").getCheckedValues();
    if (aptWksIDs == "")
      showMessage(itl("@Common.NoElementWasSelected"));
    else {
      confirmDialog(null, function() {
        doChangeAccessPointController(null, aptWksIDs);
      });
    }
  });

  function doChangeAccessPointController(workstationId, aptWksIDs) {
    var reqDO = {
      Command: "ChangeAccessPointController",
      ChangeAccessPointController: {
        ControllerWorkstationId: workstationId,
        AccessPointIDs: aptWksIDs
      }
    };
    vgsService("Workstation", reqDO, false, function(ansDO) {
      changeGridPage("#accesspoint-grid", 1);
    });
  }
  
  function checkAccessPoint(item, callback) {
    var reqDO = {
      Command: "SearchApt",
      SearchApt: {
        WorkstationId: item,
      }
    };
    vgsService("Workstation", reqDO, false, function(ansDO) {
      var list = ansDO.Answer.SearchApt.AccessPointList;
      var apt = ((list == null) || (list.length == 0)) ? null : list[0];
      if (callback) 
        callback(apt);
    });
  }
});
 
</script>
</v:page-form>
