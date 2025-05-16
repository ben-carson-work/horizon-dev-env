<%@page import="com.vgs.web.library.BLBO_DBInfo"%>
<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="wks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
FtCRUD rightCRUD = pageBase.getBLDef().getWorkstationGroupCRUD(wks.WorkstationType.getLkValue()).getOverallCRUD();
FtCRUD aptRightCRUD = rights.SystemSetupAccessPoints.getOverallCRUD(); 
FtCRUD wksRightCRUD = rights.SystemSetupWorkstations.getOverallCRUD(); 
boolean canEdit = rightCRUD.canUpdate();
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
   <v:tab-group name="tab" main="true">
     <% if (wks.WorkstationType.isLookup(LkSNWorkstationType.APT)) { %>
       <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="accesspoint_tab_main.jsp" tab="main" default="true"/>
     <% } else { %>
       <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="workstation_tab_main.jsp" tab="main" default="true"/>
     <% } %>

     <%-- DEVICES --%>
     <% if ((wks.PluginCount.getInt() > 0) || pageBase.isTab("tab", "plugin")) { %>
       <v:tab-item caption="@Plugin.Devices" icon="device.png" tab="plugin" jsp="workstation_tab_plugin.jsp" />
     <% } %>
     
     <%-- CONTROLLED ACCESS POINTS --%>
     <% if (((wks.AccessPointCount.getInt() > 0) || pageBase.isTab("tab", "controlledaccesspoints")) && aptRightCRUD.canRead()) { %>
       <v:tab-item caption="@Workstation.ControlledAccessPoints" icon="accesspoint.png" tab="controlledaccesspoints" jsp="workstation_tab_controlledaccesspoints.jsp" />
     <% } %>
     
     <%-- MONITORED ACCESS POINTS --%>
     <% if ((!wks.MonitoredAccessPointList.isEmpty() || pageBase.isTab("tab", "monitoredaccesspoints")) && aptRightCRUD.canRead()) { %>
       <v:tab-item caption="@Workstation.MonitoredAccessPoints" icon="accesspoint.png" tab="monitoredaccesspoints" jsp="workstation_tab_monitoredaccesspoints.jsp" />
     <% } %>
              
     <%-- API-FIREWALL --%>
     <% if (rights.MonitorIT.getBoolean() && ((wks.ApiFirewallCount.getInt() > 0) || pageBase.isTab("tab", "APIFW"))) { %>
       <% request.setAttribute("EntityType", LkSNEntityType.Workstation.getCode()); %>
       <% request.setAttribute("EntityId", pageBase.getId()); %>
       <v:tab-item caption="@System.ApiFirewall" fa="block-brick-fire" tab="apifw" jsp="../common/api_firewall_widget.jsp" />
     <% } %>
           
     <%-- REPOSITORY --%>
     <% if ((wks.RepositoryCount.getInt() > 0) || pageBase.isTab("tab", "repository")) { %>
       <% String jsp_repository = "/admin?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Workstation.getCode() + "&readonly=" + !canEdit; %>
       <v:tab-item caption="@Common.Documents" icon="attachment.png" tab="repository" jsp="<%=jsp_repository%>" />
     <% } %>
       
     <%-- LOGS --%>
     <% if (pageBase.isTab("tab", "logs") || pageBase.getBLDef().hasLogs(pageBase.getId())) { %>
       <v:tab-item caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" tab="logs" jsp="../log/log_tab_widget.jsp" />
     <% } %>
     
      <%-- DOCKET DEVICES --%>
     <% if (((wks.DocketDeviceCount.getInt() > 0) || pageBase.isTab("tab", "docketdevices")) && wksRightCRUD.canRead()) { %>
       <v:tab-item caption="@Workstation.DocketDevices" fa="utensils" tab="docketdevices" jsp="../workstation/workstation_tab_docketdevices.jsp" />
     <% } %>
 
       <%-- USR ACTIVITY --%>
      <% if ((wks.UserActivityCount.getInt() > 0) && wks.WorkstationType.isLookup(LkSNWorkstationType.POS)) { %>
        <% String jsp_activity = pageBase.getContextURI() + "?page=grid_widget&jsp=account/user_activity_tab.jsp&EntityType=" + LkSNEntityType.Workstation.getCode();%>
        <v:tab-item caption="@Account.UserActivity" fa="sign-in-alt" tab="user_activity" jsp="<%=jsp_activity%>" />
      <% } %>
                
     <%-- ADD --%>
     <% if (canEdit) { %>
       <v:tab-plus>
      <%-- DEVICES --%>
      <% if ((wks.PluginCount.getInt() == 0) && wks.WorkstationType.isLookup(LkSNWorkstationType.getAcceptDevicesWorkstationType()) && !pageBase.isTab("tab", "plugin")) { %>
        <% String hrefDevices = pageBase.getContextURL() + "?page=workstation&id=" + pageBase.getId() + "&tab=plugin" + "&WorkstationType=" + wks.WorkstationType.getInt(); %>
        <v:popup-item caption="@Plugin.Devices" title="@Devices.DeviceSetupHint" fa="plug" href="<%=hrefDevices%>"/>
      <% } %>
      
      <%-- API FIREWALL --%>
      <% if (wks.ApiFirewallCount.getInt() == 0) { %>
        <% String hrefApiFW = pageBase.getContextURL() + "?page=workstation&id=" + pageBase.getId() + "&tab=apifw"; %>
        <v:popup-item caption="@System.ApiFirewall" fa="block-brick-fire" href="<%=hrefApiFW%>"/>
      <% } %>
      
      <%-- DOCKET DEVICES --%>
      <% if (((wks.DocketDeviceCount.getInt() == 0) && !pageBase.isTab("tab", "docketdevices")) && wksRightCRUD.canRead()) { %>
        <% String hrefDocketDevices = pageBase.getContextURL() + "?page=workstation&id=" + pageBase.getId() + "&tab=docketdevices"; %>
        <v:popup-item caption="@Workstation.DocketDevices" fa="utensils" href="<%=hrefDocketDevices%>"/>        
      <% } %>
      
      <%-- CONTROLLED ACCESS POINTS --%>
      <% if ((wks.AccessPointCount.getInt() == 0) && !pageBase.isTab("tab", "controlledaccesspoints") && aptRightCRUD.canRead()) { %>
        <% String hrefControlledAccessPoint = pageBase.getContextURL() + "?page=workstation&id=" + pageBase.getId() + "&tab=controlledaccesspoints"; %>
        <v:popup-item caption="@Workstation.ControlledAccessPoints" icon="accesspoint.png" href="<%=hrefControlledAccessPoint%>"/>
      <% } %>
      
      <%-- MONITORED ACCESS POINTS --%>
      <% if (wks.MonitoredAccessPointList.isEmpty() && !pageBase.isTab("tab", "monitoredaccesspoints") && aptRightCRUD.canRead() && wks.WorkstationType.isLookup(LkSNWorkstationType.POS)) { %>
        <% String hrefMonitoredAccessPoint = pageBase.getContextURL() + "?page=workstation&id=" + pageBase.getId() + "&tab=monitoredaccesspoints"; %>
        <v:popup-item caption="@Workstation.MonitoredAccessPoints" icon="accesspoint.png" href="<%=hrefMonitoredAccessPoint%>"/>
      <% } %>
      
     
            
    <% if (!pageBase.isNewItem()) { %>
      <%-- CONFIG --%>
      <% if (canEdit) { %>
        <% String filter = "setup"; %>
        <% 
          if (wks.WorkstationType.isLookup(LkSNWorkstationType.B2B))
            filter="setupB2B";
        %>
        <% 
          int entType = LkSNEntityType.Workstation.getCode();
          if (wks.WorkstationType.isLookup(LkSNWorkstationType.APT))
            entType = LkSNEntityType.AccessPoint.getCode();
        %>
        <% String hrefConfig = "javascript:asyncDialogEasy('right/rights_dialog', 'WksType=" + wks.WorkstationType.getString() + "&Filter=" + filter + "&EntityType=" + entType + "&EntityId=" + pageBase.getId() + "')"; %>
        <v:popup-item caption="@Common.Configuration" fa="tools" href="<%=hrefConfig%>"/>
      <% } %>
      <%-- RIGHTS --%>
      <% if (canEdit && !wks.WorkstationType.isLookup(LkSNWorkstationType.APT)) { %>    
        <% String filter = "right"; %>
        <% if (wks.WorkstationType.isLookup(LkSNWorkstationType.B2B))
             filter="rightB2B";
        %>
        <% String hrefRight = "javascript:asyncDialogEasy('right/rights_dialog', 'WksType=" + wks.WorkstationType.getString() + "&Filter=" + filter + "&EntityType=" + LkSNEntityType.Workstation.getCode() + "&EntityId=" + pageBase.getId() + "')"; %>
        <v:popup-item caption="@Common.Rights" fa="key" href="<%=hrefRight%>"/>
      <% } %>
        
      <%-- NOTES --%>
      <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Workstation.getCode() + "');"; %>
      <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
      
      <%-- HISTORY --%>
      <% if (rights.History.getBoolean()) { %>
        <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
        <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
      <% } %>      
      
      <%-- UPLOAD --%>
      <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.Workstation.getCode() + ", '" + pageBase.getId() + "', " + (wks.RepositoryCount.getInt() == 0) + ");"; %>
      <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
      <% } %>
      
      <%-- SIAE --%>
      <% if (BLBO_DBInfo.isSiae() && rights.FiscalSystemView.getBoolean() && !pageBase.isNewItem()) { %>
        <% String hrefSIAE = "javascript:asyncDialogEasy('siae/siae_workstation_dialog', 'id=" + pageBase.getId() + "')"; %>
        <v:popup-item caption="SIAE" icon="siae.png" href="<%=hrefSIAE%>"/>
      <% } %>
              
    </v:tab-plus>
    <% } %>
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp"/>
