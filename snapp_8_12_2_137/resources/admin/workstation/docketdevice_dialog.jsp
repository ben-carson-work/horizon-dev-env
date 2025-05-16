<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.web.library.bean.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_DocketDevice.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String docketDeviceId = pageBase.getParameter("id");
String workstationId = pageBase.getParameter("WorkstationId");
StationBean station = SrvBO_Cache_Station.instance().getStationById(workstationId);
FtCRUD wksRightCRUD = pageBase.getBLDef().getEntityRightCRUD(rights.SystemSetupWorkstations, rights, new String[] {station.locationId});

BLBO_DocketDevice bl = pageBase.getBL(BLBO_DocketDevice.class);
DODocketDevice docketDevice = pageBase.isNewItem() ? bl.prepareNewDocketDevice() : bl.loadDocketDevice(docketDeviceId); 
request.setAttribute("docketDevice", docketDevice);
if (workstationId == null)
  workstationId = docketDevice.WorkstationId.toString();
BLBO_Workstation wks = pageBase.getBL(BLBO_Workstation.class);
String wksLocationId = null;

QueryDef qdef = new QueryDef(QryBO_Workstation.class);
qdef.addSelect(QryBO_Workstation.Sel.LocationAccountId);
qdef.addFilter(QryBO_Workstation.Fil.WorkstationId, workstationId);

JvDataSet ds = pageBase.execQuery(qdef);
if (!ds.isEmpty())
  wksLocationId = ds.getField(QryBO_Workstation.Sel.LocationAccountId).getString();
%>
<script>
  $(document).ready(function(){
    var dlg = $("#docketdevices_dialog");
    dlg.on("snapp-dialog", function(event, params) {
      params.buttons = [
        {
          text: <v:itl key="@Common.Save" encode="JS"/>,
          click: doSave,
        }, 
        {
          text: <v:itl key="@Common.Cancel" encode="JS"/>,
          click: doCloseDialog
        }                     
      ];
    });
  });

  function doSave() {
    var reqDO = {
      Command: "SaveDocketDevice",
      SaveDocketDevice: {
        DocketDevice: {
          DocketDeviceId : <%=docketDevice.DocketDeviceId.isNull() ? null : "\"" + docketDevice.DocketDeviceId.getHtmlString() + "\""%>,
          DocketDeviceName: $("#docketDevice\\.DocketDeviceName").val(),
          DocketDeviceType: "<%=docketDevice.DocketDeviceType.getInteger()%>",
          WorkstationId: "<%=workstationId%>",
          ProductTypeTagIDs: $("#docketDevice\\.ProductTypeTagIDs").val(),
          OpAreaIDs: $("#docketDevice\\.OpAreaIDs").val()
        } 
      }
    };
    
    vgsService("DocketDevice", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.DocketDevice.getCode()%>);
      $("#docketdevices_dialog").dialog("close");
    });
   }
</script>

<v:dialog id="docketdevices_dialog" tabsView="true" title="@Workstation.DocketDevices"  width="900" height="700">

<v:tab-group name="tabs" main="true">
  <v:tab-item-embedded tab="tabs-profile" caption="@Common.Profile" default="true">
  <div class="tab-content">
	  <v:widget caption="@Common.General" icon="profile.png">
	    <v:widget-block>
	      <v:form-field caption="@Common.Name" mandatory="true">
	        <v:input-text field="docketDevice.DocketDeviceName" enabled="<%=wksRightCRUD.canUpdate()%>"/>
	      </v:form-field>
	      <v:form-field caption="@Account.OpAreas" mandatory="true">
	        <v:multibox field="docketDevice.OpAreaIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getOpAreaDS(wksLocationId)%>" idFieldName="AccountId" captionFieldName="Displayname" linkEntityType="<%=LkSNEntityType.OperatingArea%>" enabled="<%=wksRightCRUD.canUpdate()%>"/>
	      </v:form-field>
	      <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.ProductType.getCode() + ",'docketDevice.ProductTypeTagIDs')"; %>
	      <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
	        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	        <v:multibox field="docketDevice.ProductTypeTagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=wksRightCRUD.canUpdate()%>"/>
	      </v:form-field>
	    </v:widget-block>
	  </v:widget>
  </div>
  </v:tab-item-embedded>  
  
   <% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
    <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
      <jsp:include page="../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>
</v:dialog>