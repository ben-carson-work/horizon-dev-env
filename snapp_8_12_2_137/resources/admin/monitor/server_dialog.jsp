<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.DOServer.DOServerParam"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Server.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>

<%
String idString = pageBase.getParameter("serverId");
int id = Integer.parseInt(idString);

boolean masked = !rights.VGSSupport.getBoolean();
DOServer server = pageBase.getBL(BLBO_Server.class).getServer(id, masked);
%>

<v:dialog id="server_dialog" icon="siae.png" tabsView="true" title="Server parameters" width="850" height="700" autofocus="false">
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <jsp:include page="server_dialog_tab_main.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-system" caption="@Common.System">
      <jsp:include page="server_dialog_tab_system.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-param" caption="@Common.Parameters">
      <jsp:include page="server_dialog_tab_param.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-jvmargs" caption="JVM args">
      <jsp:include page="server_dialog_tab_jvmargs.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-startup" caption="@Common.StartUpDateTime">
      <jsp:include page="server_dialog_tab_startup.jsp"/>
    </v:tab-item-embedded>
    
   	<v:tab-item-embedded tab="tabs-updateversion" caption="@System.WarUpdates">
      <jsp:include page="server_dialog_tab_updateversion.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>

<script>

$(document).ready(function() {
  var dlg = $("#server_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Settings" encode="JS"/>: function() {
        asyncDialogEasy("right/rights_dialog", "Filter=server&EntityType=<%=LkSNEntityType.Server.getCode()%>&ServerId=<%=id%>");
      },
      <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
    };
  });
});
</script>
</v:dialog>