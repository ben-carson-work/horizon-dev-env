<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
DOExtensionPackage pkg = pageBase.getBL(BLBO_Plugin.class).loadExtensionPackage(pageBase.getId());
request.setAttribute("pkg", pkg);
%>

<v:dialog id="extpackage_dialog" tabsView="true" title="@Plugin.ExtensionPackage" width="1200" height="800" autofocus="false">

  <v:tab-group name="tab" main="true">
    <%-- PROFILE --%>
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <jsp:include page="extpackage_dialog_tab_main.jsp"/>
    </v:tab-item-embedded>

    <%-- INFO --%>
    <v:tab-item-embedded tab="tabs-info" caption="@Common.Info">
      <jsp:include page="extpackage_dialog_tab_info.jsp"/>
    </v:tab-item-embedded>

    <%-- SETTINGS --%>
    <% if (!pkg.PackageInfo.SettingsJSP.isNull()) { %>
      <v:tab-item-embedded tab="tabs-settings" caption="@Common.Settings">
        <jsp:include page="extpackage_dialog_tab_settings.jsp"/>
      </v:tab-item-embedded>
    <% } %>
        
    <%-- LOGS --%>
    <% if (pageBase.isTab("tab", "logs") || pageBase.getBLDef().hasLogs(pageBase.getId())) { %>
      <v:tab-item-embedded caption="@Common.Logs" tab="logs">
        <jsp:include page="../log/log_tab_widget.jsp"/>
      </v:tab-item-embedded>
    <% } %>
  </v:tab-group>

</v:dialog>