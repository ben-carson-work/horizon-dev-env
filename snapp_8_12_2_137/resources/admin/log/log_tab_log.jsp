<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<%@ taglib uri="snp-tags" prefix="snp"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLogAndApiTracing" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String defaultDateXML = pageBase.getBrowserFiscalDate().getXMLDate();
pageBase.setDefaultParameter("FilterDate", defaultDateXML);
%>

<v:tab-toolbar>
  <v:button id="btn-search" caption="@Common.Search" fa="search" enabled="<%=rights.MonitorIT.getBoolean()%>"/>
  <v:button id="btn-config" caption="@Common.Settings" fa="sliders" enabled="<%=rights.SettingsITSettings.getBoolean()%>"/>

  <v:pagebox gridId="log-grid" />
</v:tab-toolbar>

<v:tab-content include="<%=rights.MonitorIT.getBoolean()%>">
  <v:profile-recap>
    <v:widget caption="@Common.TimeRange">
      <v:widget-block>
        <v:itl key="@Common.Date"/><br/>
        <v:input-text type="datepicker" field="FilterDate"/> 
                      
        <div class="filter-divider"></div>
        
        <v:itl key="@Common.FromTime"/><br/>
        <v:input-text type="timepicker" field="TimeFrom" />
                      
        <div class="filter-divider"></div>

        <v:itl key="@Common.ToTime"/><br/>
        <v:input-text type="timepicker" field="TimeTo" />
      </v:widget-block>
    </v:widget>

    <v:widget caption="@Common.Type">
      <v:widget-block>
        <snp:dyncombo field="EntityType" entityType="<%=LkSNEntityType.LookupTable_EntityType%>"/>
        
        <div id="driver-block" class="hidden">
          <div class="filter-divider"></div>
          <snp:dyncombo field="DriverId" entityType="<%=LkSNEntityType.Driver%>"/>
        </div> 
      </v:widget-block>
      <v:widget-block>
        <v:lk-checkbox field="LogLevel" lookup="<%=LkSN.LogLevel%>"/> 
      </v:widget-block>
    </v:widget>

    <v:widget caption="@Common.Workstation">
      <v:widget-block>
        <v:itl key="@Account.Location"/><br/>
        <snp:dyncombo auditLocationFilter="true" id="LocationId" entityType="<%=LkSNEntityType.Location%>"/>
        
        <div class="filter-divider"></div>
        
        <v:itl key="@Account.OpArea"/><br/>
        <snp:dyncombo auditLocationFilter="true" id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" parentComboId="LocationId"/>
        
        <div class="filter-divider"></div>
        
        <v:itl key="@Common.Workstation"/><br/>
        <snp:dyncombo auditLocationFilter="true" id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>" parentComboId="OpAreaId"/>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  <v:profile-main>
    <v:async-grid id="log-grid" jsp="log/log_grid.jsp" autoload="false"/>
  </v:profile-main>
</v:tab-content>


<script>

$(document).ready(function() {
  $("#btn-search").click(_search);
  $("#btn-config").click(_config);
  $("#EntityType").change(_enableDisable);
  _search();

  function _search() {
    setGridUrlParam("#log-grid", "FromDateTime", _getDateTimeFilter("#TimeFrom", false));
    setGridUrlParam("#log-grid", "ToDateTime", _getDateTimeFilter("#TimeTo", true));

    setGridUrlParam("#log-grid", "LocationId", $("#LocationId").val());
    setGridUrlParam("#log-grid", "OpAreaId", $("#OpAreaId").val());
    setGridUrlParam("#log-grid", "WorkstationId", $("#WorkstationId").val());
    setGridUrlParam("#log-grid", "EntityType", $("#EntityType").val());
    setGridUrlParam("#log-grid", "AltEntityId", isEntityTypePlugin() ? $("#DriverId").val() : "");
    setGridUrlParam("#log-grid", "LogLevel", $("[name='LogLevel']").getCheckedValues(), true);
  }
  
  function _enableDisable() {
    $("#driver-block").setClass("hidden", !isEntityTypePlugin());
  }
  
  function isEntityTypePlugin() {
    return $("#EntityType").val() == <%=LkSNEntityType.Plugin.getCode()%>;
  }
  
  function _getDateTimeFilter(field, max) {
    var date = $("#FilterDate-picker").getXMLDate();
    if (getNull(date) == null)
      date = <%=JvString.jsString(defaultDateXML)%>;

    var time = $(field).getXMLTime();
    if (getNull(time) == null)
      time = (max === true) ? "23:59" : "00:00";
    
    return date + "T" + time;
  }

  function _config() {
    asyncDialogEasy("log/logcfg_dialog");
  }
});

</script>
