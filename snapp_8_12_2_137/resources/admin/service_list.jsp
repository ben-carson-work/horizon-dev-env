<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageServiceList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="../common/header.jsp"/>
<v:page-title-box/>
<v:last-error/>

<script>

function refresh() {
  changeGridPage("#service-grid", 1);
}

function refreshTimer() {
  refresh();
  setTimeout(refreshTimer, 10000);
}

$(document).ready(refreshTimer);

function changeStatus(status) {
  var reqDO = {
    Command: "ChangeStatus",
    ChangeStatus: {
      ServiceIDs: $("#service-grid [name='ServiceId']").getCheckedValues(),
      ServiceStatus: status
    }
  };
  vgsService("Service", reqDO, false, refresh);
}

</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button fa="sync-alt" caption="@Common.Refresh" href="javascript:refresh()" />
      <% String hrefStart = "javascript:changeStatus(" + LkSNServiceStatus.Started.getCode() + ")"; %>
      <v:button fa="play-circle" caption="@Common.Start" href="<%=hrefStart%>" enabled="<%=rights.SettingsITSettings.getBoolean()%>"/>
      <% String hrefStop = "javascript:changeStatus(" + LkSNServiceStatus.Stopped.getCode() + ")"; %>
      <v:button fa="stop-circle" caption="@Common.Stop" href="<%=hrefStop%>" enabled="<%=rights.SettingsITSettings.getBoolean()%>"/>
    </div>
    
    <div class="tab-content">
      <v:async-grid id="service-grid" jsp="service_grid.jsp" />
    </div>
  </v:tab-item-embedded>
</v:tab-group>

 
<jsp:include page="../common/footer.jsp"/>
