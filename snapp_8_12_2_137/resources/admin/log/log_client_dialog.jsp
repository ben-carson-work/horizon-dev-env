<%@page import="com.vgs.snapp.dataobject.DODocLogClient"%>
<%@page import="com.vgs.snapp.dataobject.DOLogDataBase"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Log.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLogDataDialog" scope="request"/>
<jsp:useBean id="logInfo" class="com.vgs.snapp.dataobject.DOLogInfo" scope="request"/>

<% DODocLogClient logClient = pageBase.getDocLogClient(logInfo); %>

<% if (logClient != null) { %>
  <v:widget icon="[font-awesome]times|CircleRed" caption="Error">
    <v:widget-block>
      Type: <%=logClient.LogType.getLkValue().getDescription(pageBase.getLang())%>
    </v:widget-block>
    <v:widget-block>
      Subtype: <%=logClient.LogSubType.getLkValue().getDescription(pageBase.getLang())%>
    </v:widget-block>
  </v:widget>
  <v:widget icon="xml.png" caption="Text">
    <v:widget-block>
      <%=logClient.LogMessage.getHtmlString()%>
    </v:widget-block>
  </v:widget>
  
<% } %>
