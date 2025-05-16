<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEventList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
  
<v:tab-group name="tab" main="true">
  <% boolean first = true; %>
  <% if (rights.EventView_All.getBoolean() || (rights.EventView_Tags.getArray().length > 0)) { %>
    <v:tab-item caption="@Event.Events" icon="<%=LkSNEntityType.Event.getIconName()%>" tab="event" jsp="event_list_tab_event.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.GenericSetup.getBoolean()) { %>
    <v:tab-item caption="@Event.EventCategories" icon="<%=LkSNEntityType.EventCategory.getIconName()%>" tab="eventcat" jsp="event_list_tab_category.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
