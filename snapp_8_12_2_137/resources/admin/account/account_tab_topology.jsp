<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="account" class="com.vgs.snapp.dataobject.DOAccount" scope="request"/>

<div class="tab-content">
  <v:last-error/>

  <v:tab-group name="distri">
  
    <% //--- OPERATING AREA ---// %>
    <% String jsp_oparea = "/admin?page=account_tab_oparea&id=" + pageBase.getId() + "&EntityType=" + account.EntityType.getInt(); %>
    <v:tab-item caption="@Account.OpAreas" icon="oparea.png" tab="oparea" jsp="<%=jsp_oparea%>" default="true" />
        
    <% //--- WORKSTATION ---// %>
    <% request.setAttribute("LocationAccountId", pageBase.getId()); %>
    <v:tab-item caption="@Common.Workstations" icon="station.png" tab="wks" jsp="../workstation/workstation_list_widget.jsp" />
      
    <% //--- ACCESS AREA ---// %>
    <% String jsp_acarea = "/admin?page=account_tab_acarea&id=" + pageBase.getId() + "&EntityType=" + account.EntityType.getInt(); %>
    <v:tab-item caption="@Account.AccessAreas" icon="accessarea.png" tab="acarea" jsp="<%=jsp_acarea%>" />
        
    <% //--- ACCESS POINT ---// %>
    <% request.setAttribute("LocationAccountId", pageBase.getId()); %>
    <v:tab-item caption="@AccessPoint.AccessPoints" icon="accesspoint.png" tab="apt" jsp="../workstation/accesspoint_list_widget.jsp" />
    
  </v:tab-group>
</div>