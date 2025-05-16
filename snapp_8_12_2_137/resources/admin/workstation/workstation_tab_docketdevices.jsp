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
<% boolean canEdit = rights.SystemSetupWorkstations.getOverallCRUD().canUpdate() && rights.SystemSetupWorkstationDemographic.getBoolean();%>

<script>
function deleteDocketDevices() {
  var ids = $("[name='DocketDeviceId']").getCheckedValues();
  
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteDocketDevices",
      DeleteDocketDevices: {
        DocketDeviceIDs: ids
      }
    };
    vgsService("DocketDevice", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.DocketDevice.getCode()%>);
    });
  });  
 }
}

function search() {
  setGridUrlParam("#docketdevice-grid", "FullText", $("#search-text").val(), true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
    event.preventDefault(); 
  }
}
</script>

<div class="tab-toolbar">
  <input type="text" id="search-text" class="form-control default-focus" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" style="width:200px"/>
  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
  <span class="divider"></span>
  <% String hrefDocketDevices = "javascript:asyncDialogEasy('workstation/docketdevice_dialog', 'id=new" + "&WorkstationId=" + pageBase.getId() + "');"; %>
  <v:button caption="@Common.New" title="DocketDevice" fa="plus" href="<%=hrefDocketDevices %>" enabled="<%=canEdit%>"/>
  <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:deleteDocketDevices()" enabled="<%=canEdit%>" />
  
  <v:pagebox gridId="docketdevice-grid"/>
</div>
    
<div class="tab-content">
  <v:last-error/>
  <% String params = "WorkstationId=" + pageBase.getId() ;%>
  <v:async-grid id="docketdevice-grid" jsp="workstation/docketdevice_grid.jsp" params="<%= params %>" />
</div>