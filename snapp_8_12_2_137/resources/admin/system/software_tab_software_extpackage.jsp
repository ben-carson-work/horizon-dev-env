<%@page import="com.vgs.snapp.dataobject.plugin.*"%>
<%@page import="com.vgs.snapp.api.extpackage.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.store.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSoftware" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>
<jsp:useBean id="pageSoftware" scope="request" class="com.vgs.snapp.dataobject.DOPageSoftware"/>

<style><%@ include file="software_tab_software_extpackage.css" %></style>
<script><%@ include file="software_tab_software_extpackage.js" %></script>
  
<v:widget id="extpkg-widget" caption="@Plugin.ExtensionPackages">
  <v:widget-block include="<%=pageSoftware.CreatePackages.getBoolean() || pageSoftware.EditPackages.getBoolean()%>">
    <v:button-group>
      <v:button id="btn-add" caption="@Common.Add" fa="plus"/>
      <v:button id="btn-upload" caption="@Upload.Upload" fa="folder-open" include="<%=pageSoftware.ManualUpload.getBoolean()%>"/>
    </v:button-group>
  </v:widget-block>
  
  <v:widget-block id="extpkg-updateall-box" clazz="hidden">
    <v:alert-box type="info" style="margin:0">
      <div>Update available for <span id="extpkg-update-count"></span> package(s).</div>
      <% if (pageSoftware.EditPackages.getBoolean()) { %>
        <a id="btn-updateall" href="javascript:" style="font-weight:bold">Update now</a>
      <% } %>
    </v:alert-box>
  </v:widget-block>
  
  <v:widget-block id="extpkg-list-container">
  </v:widget-block>
  
  <div id="templates" class="hidden">
    <div class="extpkg-tile v-tooltip hint-tooltip">
      <div class="pkg-icon"><img src=""/></div>
      <div class="pkg-code"></div>
      <div class="pkg-version"></div>
      <div class="pkg-topbar"><%--Leave as last item in the tile in order to catch click events--%>
        <%-- <div class="pkg-status pkg-status-ok"><i class="fa fa-circle-check fg-green"></i></div> --%>
        <div class="pkg-status pkg-status-warn"><i class="fa fa-triangle-exclamation fg-orange"></i></div>
        <div class="pkg-status pkg-status-disabled"><i class="fa fa-circle-xmark fg-gray"></i></div>
        <div class="pkg-update pkg-update-available"><i class="fa fa-circle-down fg-blue"></i></div>
      </div>
    </div>
    
    <div class="extpkg-tooltip">
      <div><span style="font-weight:bold" class="extpkg-code"></span> <span class="extpkg-version"></span></div>
      <div style="font-style:italic" class="extpkg-desc"></div>
      <div style="font-weight:bold; margin-top:10px" class="extpkg-update"></div>
    </div>
  </div>
</v:widget>


