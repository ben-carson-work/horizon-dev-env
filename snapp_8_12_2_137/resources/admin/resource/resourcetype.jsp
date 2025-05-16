<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageResourceType" scope="request"/>
<jsp:useBean id="restype" class="com.vgs.snapp.dataobject.DOResourceType" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <%-- PROFILE --%>
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="resourcetype_tab_main.jsp" tab="main" default="true"/>
    <% if (!pageBase.isNewItem()) { %>
      <%-- RESOURCE --%>
      <v:tab-item caption="@Resource.Resources" icon="<%=LkSNEntityType.ResourceType.getIconName()%>" jsp="resourcetype_tab_resource.jsp" tab="resource"/>
      <%-- CALENDAR --%>
      <% String jspCalendar = "/admin?page=calendar_widget&EntityType=" + LkSNEntityType.ResourceType.getCode() + "&EntityId=" + pageBase.getId(); %>
      <v:tab-item caption="@Common.Calendar" icon="calendar.png" jsp="<%=jspCalendar%>" tab="schedule"/>
      <%-- ADD --%>
      <v:tab-plus>
			  <%-- NOTES --%>
			  <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ResourceType.getCode() + "');"; %>
			  <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
			
			  <%-- HISTORY --%>
        <% if (rights.History.getBoolean()) { %>
          <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
          <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
        <% } %>        </v:tab-plus>
    <% } %>
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp"/>
