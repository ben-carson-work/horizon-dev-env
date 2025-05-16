<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMeasureSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
  
<v:tab-group name="tab" main="true">
  <% boolean first = true; %>
  <% if (rights.GenericSetup.getBoolean()) { %>
    <v:tab-item caption="@Product.Measures" icon="measure.png" tab="measure" jsp="measure_setup_tab_measure.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.GenericSetup.getBoolean()) { %>
    <v:tab-item caption="@Product.MeasureProfiles" icon="measure.png" tab="measureprofile" jsp="measure_setup_tab_measureprofile.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
