<%@page import="com.vgs.broadcast.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Workstation.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstationMonitor" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean widget = pageBase.isParameter("widget", "true"); %>

<% if (!rights.WebSockets.getBoolean()) { %>
<div id="wks-monitor-tab" class="tab-content">
  <div class="errorbox offline-box">Web-Sockets disabled</div>
</div>
<% } else { 
	QueryDef qdef = new QueryDef(QryBO_Workstation.class);
	// Select
	qdef.addSelect(Sel.IconName);
	qdef.addSelect(Sel.CommonStatus);
	qdef.addSelect(Sel.WorkstationId);
	qdef.addSelect(Sel.WorkstationType);
	qdef.addSelect(Sel.WorkstationCode);
	qdef.addSelect(Sel.WorkstationName);
	qdef.addSelect(Sel.WorkstationURI);
	qdef.addSelect(Sel.LocationAccountId);
	qdef.addSelect(Sel.LocationDisplayName);
	qdef.addSelect(Sel.OpAreaAccountId);
	qdef.addSelect(Sel.OpAreaDisplayName);
	qdef.addSelect(Sel.CategoryRecursiveName);
	qdef.addSelect(Sel.LoggedUserAccountId);
	qdef.addSelect(Sel.LoggedUserAccountName);
	qdef.addSelect(Sel.LastClientActivity);
	qdef.addSelect(Sel.LastClientVersion);
	qdef.addSelect(Sel.LastClientIPAddress);
	qdef.addSelect(Sel.Offline);
	qdef.addSelect(Sel.AptControllerWorkstationId);
	// Sort
	qdef.addSort(Sel.LocationDisplayName);
	qdef.addSort(Sel.OpAreaDisplayName);
	qdef.addSort(Sel.WorkstationName);
	// Where
	
	qdef.addFilter(Fil.WorkstationType, LkSNWorkstationType.APT.getCode());
	qdef.addFilter(Fil.HasControllerWorkstation, "true");
	
	LookupItem entityType = LkSN.EntityType.findItemByCode(pageBase.getParameter("EntityType"));
	if (entityType != null) {
	  if (entityType.isLookup(LkSNEntityType.Location))
	    qdef.addFilter(Fil.LocationAccountId, pageBase.getId());
	  else if (entityType.isLookup(LkSNEntityType.OperatingArea))
	    qdef.addFilter(Fil.OpAreaAccountId, pageBase.getId());
	  else if (entityType.isLookup(LkSNEntityType.AccessArea))
	    qdef.addFilter(Fil.AccessAreaAccountId, pageBase.getId());
	}
	
	// Exec
	JvDataSet ds = pageBase.execQuery(qdef);
	request.setAttribute("ds", ds);
%>

<jsp:include page="workstation_monitor_css.jsp"/>
<jsp:include page="workstation_monitor_js.jsp"/>

<div class="tab-toolbar">
  <v:button id="btn-select-all" caption="Select all" fa="check" clazz="v-hidden"/>
  <v:button id="btn-unselect-all" caption="Unselect all" fa="times" clazz="v-hidden"/>
  <v:button id="btn-actions" caption="Actions" fa="flag" clazz="v-hidden"/>
</div>

<v:popup-menu id="actions-menu">
  <v:popup-item id="menu-config" caption="@Common.Configuration" fa="cog"/>
  <v:popup-item id="menu-droparm" caption="@AccessPoint.DropArm"/>
  <v:popup-item id="menu-skip-rotation" caption="@AccessPoint.SkipRotation"/>
  <v:popup-divider/>
  <v:popup-item id="menu-restart" caption="@AccessPoint.RestartApplication"/>
</v:popup-menu>

<div id="wks-monitor-tab" class="tab-content">
  <div class="errorbox offline-box">Establishing connection to server...</div>

<v:ds-loop dataset="<%=ds%>">
  <div 
      id="<%=ds.getField(Sel.WorkstationId).getHtmlString()%>"
      class="apt-container noselect" 
      data-WorkstationId="<%=ds.getField(Sel.AptControllerWorkstationId).getHtmlString()%>"
      data-Status=""
      onclick="onAccessPointClick(this)"
      oncontextmenu="onAccessPointMenu(this)">
    <div class="apt-checkbox"></div>
    <div class="apt-name"><%=ds.getField(Sel.WorkstationName).getHtmlString()%></div>
    <div class="apt-body apt-body-unknown">
      <v:itl key="@Common.Connecting"/>
      <div class="spinner-icon"><i class="fa fa-circle-notch fa-spin fa-fw"></i></div>
    </div>
    <div class="apt-body apt-body-error"></div>
    <div class="apt-body apt-body-normal">
      <div class="apt-passage-status"></div>
      <div class="apt-light-status">
        <img class="apt-icon apt-icon-good" src="<v:image-link name="adm_good_green.png" size="32"/>"/>
        <img class="apt-icon apt-icon-bad" src="<v:image-link name="adm_bad_red.png" size="32"/>"/>
        <img class="apt-icon apt-icon-reentry" src="<v:image-link name="adm_reentry_orange.png" size="32"/>"/>
        <img class="apt-icon apt-icon-flash" src="<v:image-link name="adm_flash_orange.png" size="32"/>"/>
      </div>
      <div class="apt-op-message"><div class="apt-op-message-text"></div></div>
      <div class="apt-properties">
        <div class="apt-rot-line" style="float:left; width:100%">
	        <div class="apt-rotin" style="width:20%"><span class="apt-label">IN</span></div>
	        <div class="apt-rotin" style="width:36%"><span class="apt-label">Waiting</span><span class="apt-value apt-rot-wait"></span></div>
	        <div class="apt-rotin" style="width:44%; padding-left: 5px;"><span class="apt-label">Total</span><span class="apt-value apt-rot-total"></span></div>
	      </div>
        <div class="apt-rot-line" style="float:left; width:100%">
	        <div class="apt-rotout" style="width:20%"><span class="apt-label">OUT</span></div>
	        <div class="apt-rotout" style="width:36%"><span class="apt-label">Waiting</span><span class="apt-value apt-rot-wait"></span></div>
	        <div class="apt-rotout" style="width:44%; padding-left: 5px;"><span class="apt-label">Total</span><span class="apt-value apt-rot-total"></span></div>
        </div>
        <div class="apt-user" style="float:left; width:100%"><span class="apt-label">Operator</span><span class="apt-value"></span></div>
      </div>
    </div>
  </div>
</v:ds-loop> 

</div>

<div id="dlg-apt-changestatus" class="v-hidden">
  <div>
    <v:itl key="@AccessPoint.EntryControl"/><br/>
    <v:lk-combobox field="EntryControl" lookup="<%=LkSN.AccessPointControl%>" allowNull="true"/>
  </div>
  <div>
    <v:itl key="@AccessPoint.ReentryControl"/><br/>
    <v:lk-combobox field="ReentryControl" lookup="<%=LkSN.AccessPointReentryControl%>" allowNull="true"/>
  </div>
  <div>
    <v:itl key="@AccessPoint.ExitControl"/><br/>
    <v:lk-combobox field="ExitControl" lookup="<%=LkSN.AccessPointControl%>" allowNull="true"/>
  </div>
</div>

<% } %>