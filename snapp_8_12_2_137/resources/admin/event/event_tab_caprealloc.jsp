<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEvent" scope="request"/>
<jsp:useBean id="event" class="com.vgs.snapp.dataobject.DOEvent" scope="request"/>

<% 
boolean canEdit = pageBase.getRightCRUD().canUpdate(); 
%>

<style><%@ include file="event_tab_caprealloc.css" %></style>
<script><%@ include file="event_tab_caprealloc.js" %></script>

<v:tab-toolbar>
  <v:button id="btn-event-caprealloc-save" fa="save" caption="@Common.Save" enabled="<%=canEdit%>"/>
  <v:button id="btn-event-caprealloc-config" fa="gear" caption="@Common.Settings" enabled="<%=canEdit%>"/>
  <v:button-group>
    <v:button id="btn-event-caprealloc-threshold-add" fa="plus" caption="@Event.CapacityReallocation_AddThreshold" enabled="<%=canEdit%>"/>
    <v:button id="btn-event-caprealloc-threshold-del" fa="minus" caption="@Event.CapacityReallocation_RemoveThreshold" enabled="<%=canEdit%>"/>
  </v:button-group>
</v:tab-toolbar>

<v:tab-content>
  
  <v:profile-recap>
    <v:widget caption="@Common.Settings">
      <v:widget-block>
        <v:db-checkbox field="event.CapacityReallocationByTask" value="true" caption="@Event.CapacityReallocationByTask" hint="@Event.CapacityReallocationByTaskHint" enabled="<%=canEdit%>"/>
      </v:widget-block>
    </v:widget>
    
    <v:alert-box type="info"><v:itl key="@Event.CapacityReallocation_Hint"/></v:alert-box>
  </v:profile-recap>
  
  <v:profile-main>
    <table id="caprealloc-matrix" data-eventid="<%=event.EventId.getHtmlString()%>" data-caprealloc="<%=JvString.escapeHtmlAttr(event.CapacityThresholdList.getJSONString())%>"></table>
  </v:profile-main>
  
</v:tab-content>

