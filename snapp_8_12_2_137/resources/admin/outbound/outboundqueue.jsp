<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageOutboundQueue" scope="request" />
<%
QueryDef qdef = new QueryDef(QryBO_OutboundQueue.class)
    .addSelect(
        QryBO_OutboundQueue.Sel.Itemized, 
        QryBO_OutboundQueue.Sel.HasDocRef)  
    .addFilter(QryBO_OutboundQueue.Fil.OutboundQueueId, pageBase.getId());

JvDataSet ds = pageBase.execQuery(qdef);

boolean itemized = (!ds.isEmpty() && ds.getField(QryBO_OutboundQueue.Sel.Itemized).getBoolean());
boolean hasDocRef = (!ds.isEmpty() && ds.getField(QryBO_OutboundQueue.Sel.HasDocRef).getBoolean());
%>

<jsp:include page="/resources/common/header.jsp" />

<v:page-title-box />

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <v:tab-item caption="@Common.Recap" icon="profile.png" jsp="outboundqueue_tab_main.jsp" tab="main" default="true"/>
     
    <% if (itemized) { %>
      <%-- ITEMS --%>
      <v:tab-item caption="@Common.Items" fa="envelope" tab="items" jsp="outboundqueue_tab_items.jsp" />
    <% } else { %>
      <%-- MESSAGE --%>
      <v:tab-item caption="@Outbound.OutboundQueueMessage" icon="xml.png" tab="message" jsp="outboundqueue_tab_message.jsp" />
    <% } %>
        
    <% if (hasDocRef) { %>    
      <v:tab-item caption="@Outbound.OutboundQueueReference" icon="note.png" tab="docref" jsp="outboundqueue_tab_docref.jsp" />
    <% } %>
        
    <%-- LOGS --%>
    <% if (pageBase.isTab("tab", "logs") || pageBase.getBLDef().hasLogs(pageBase.getId())) { %>
      <v:tab-item caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" tab="logs" jsp="../log/log_tab_widget.jsp" />
    <% } %>
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp" />
