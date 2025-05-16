<%@page import="java.util.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
List<LookupItem> defaultLogLevels = LookupManager.getArray(LkSN.LogLevel, JvArray.stringToIntArray(JvUtils.getServletParameter(request, "defaultLogLevels"), ","));
boolean dateFilter = "true".equals(JvUtils.getServletParameter(request, "dateFilter"));
String defaultDateXML = pageBase.getBrowserFiscalDate().getXMLDate();
pageBase.setDefaultParameter("FilterDate", defaultDateXML);
LookupItem entityType = LkSN.EntityType.findItemByCode(JvUtils.getServletParameter(request, "EntityType")); 
%>

<v:tab-toolbar>
  <v:button id="btn-log-search" fa="search" caption="@Common.Search"/>
  <v:pagebox gridId="log-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
    <v:widget caption="@Common.TimeRange" include="<%=dateFilter%>">
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
        <v:lk-checkbox field="LogLevel" lookup="<%=LkSN.LogLevel%>" defaultValue="<%=defaultLogLevels%>"/> 
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  <v:profile-main>
    <v:async-grid id="log-grid" jsp="log/log_grid.jsp" autoload="false"/>
  </v:profile-main>
</v:tab-content>
    
<script>
$(document).ready(function() {
  $("#btn-log-search").click(_search);
  _search();
  
  function _search() {
    var $grid = $("#log-grid");
    
    <% if (dateFilter) { %>
      setGridUrlParam($grid, "FromDateTime", _getDateTimeFilter("#TimeFrom", false));
      setGridUrlParam($grid, "ToDateTime", _getDateTimeFilter("#TimeTo", true));
    <% } %>
    
    <% if (entityType != null) { %> 
      setGridUrlParam($grid, "EntityType", "<%=entityType.getCode()%>");
    <% } %>
    
    <% if (pageBase.getId() != null) { %>
    setGridUrlParam($grid, "EntityId", "<%=pageBase.getId()%>");
    <% } %>
    setGridUrlParam($grid, "LogLevel", $("[name='LogLevel']").getCheckedValues());
    changeGridPage($grid, 1);
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
});
</script>
