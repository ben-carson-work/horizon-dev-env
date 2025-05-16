<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageUpload" scope="request" />
<jsp:useBean id="ds" class="com.vgs.cl.JvDataSet" scope="request" />

<v:ds-loop dataset="<%=ds%>"></v:ds-loop> <%-- WORKAROUND TO REMOVE RESOURCE LEAK WARNING --%>

<jsp:include page="/resources/common/header.jsp" />

<v:page-title-box />

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <v:tab-item caption="@Common.Recap" icon="profile.png" jsp="upload_tab_main.jsp" tab="main" default="true"/>
    
    <%-- REQUEST --%>
    <v:tab-item caption="@Upload.RequestMessage" icon="xml.png" tab="request" jsp="upload_tab_request.jsp" />
    
    <%-- ANSWER --%>
    <% if (ds.getField(QryBO_Upload.Sel.MsgAnswerSize).getLong() > 0) { %>
      <v:tab-item caption="@Upload.AnswerMessage" icon="xml.png" tab="answer" jsp="upload_tab_answer.jsp" />
    <% } %>
        
    <%-- LOGS --%>
    <% if (pageBase.isTab("tab", "logs") || pageBase.getBLDef().hasLogs(pageBase.getId())) { %>
      <v:tab-item caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" tab="logs" jsp="../log/log_tab_widget.jsp" />
    <% } %>
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp" />
