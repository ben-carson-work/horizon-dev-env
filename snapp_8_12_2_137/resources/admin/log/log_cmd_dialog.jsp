<%@page import="com.vgs.web.dataobject.DODocLogCmd"%>
<%@page import="com.vgs.web.dataobject.DODocLogSql"%>
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

<% 
DODocLogCmd logCMD = new DODocLogCmd();
logCMD.setJSONString(logInfo.LogText.getString());
%>

<v:widget caption="Recap">
  <v:widget-block>
    Client IP Address<span class="recap-value"><%=logCMD.ClientIPAddress.getHtmlString()%></span><br/>
    Execution Time<span class="recap-value"><%=JvString.escapeHtml(JvDateUtils.getSmoothTime(logCMD.ExecutionTime.getInt()))%></span><br/>
    Request URL<span class="recap-value"><%=logCMD.RequestURL.getHtmlString()%></span><br/>
  </v:widget-block>
</v:widget>

<v:widget caption="Request HTTP Header">
  <v:widget-block>
  <% for (DODocLogCmd.DOHeaderParam param : logCMD.HeaderParamList.getItems()) { %>
    <%=param.ParamName.getHtmlString()%><span class="recap-value"><%=param.ParamValue.getHtmlString()%></span><br/>
  <% } %>
  </v:widget-block>
</v:widget>

<v:widget caption="Request">
  <v:widget-block><%=logCMD.CmdRequest.getHtmlString()%></v:widget-block>
</v:widget>

<v:widget caption="Response">
  <v:widget-block><%=logCMD.CmdAnswer.getHtmlString()%></v:widget-block>
</v:widget>
