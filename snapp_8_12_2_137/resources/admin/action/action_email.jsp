<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAction" scope="request"/>
<jsp:useBean id="action" class="com.vgs.snapp.dataobject.DOAction" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <%-- MAIN --%>
  <v:tab-item caption="@Common.Email" fa="envelope" jsp="action_email_tab_main.jsp" tab="main" default="true"/>
  
  <%-- LOGS --%>
  <% if (pageBase.isTab("tab", "logs") || pageBase.getBLDef().hasLogs(pageBase.getId())) { %>
    <v:tab-item caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" tab="logs" jsp="../log/log_tab_widget.jsp" />
  <% } %>
</v:tab-group>


<jsp:include page="/resources/common/footer.jsp"/>
