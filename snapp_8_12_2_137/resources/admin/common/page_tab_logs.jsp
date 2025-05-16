<%@page import="com.vgs.cl.JvArray"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
List<LookupItem> defaultLevelFilter = LookupManager.getArray(LkSNLogLevel.Fatal, LkSNLogLevel.Error, LkSNLogLevel.Warn, LkSNLogLevel.Info);
%>

<v:tab-toolbar>
  <v:lk-checkbox field="LogLevel" lookup="<%=LkSN.LogLevel%>" defaultValue="<%=defaultLevelFilter%>" inline="true" style="display:inline-block"/>
  <v:pagebox gridId="log-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <% String params = "EntityId=" + pageBase.getId() + "&LogLevel=" + JvArray.arrayToString(LookupManager.getIntArray(defaultLevelFilter), ","); %>
  <v:async-grid id="log-grid" jsp="log/log_grid.jsp" params="<%=params%>"/>
</v:tab-content>

  
<script>
  $("input[name='LogLevel']").click(function() {
    setGridUrlParam("#log-grid", "LogLevel", $("input[name='LogLevel']").getCheckedValues(), true);
  });
</script>
