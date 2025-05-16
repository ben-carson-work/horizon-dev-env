<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.json.JSONObject"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageApi" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_ApiLog.class)
    .addFilter(QryBO_ApiLog.Fil.ApiLogId, pageBase.getNullParameter("id"))
    .addSelect(
        QryBO_ApiLog.Sel.ApiLogId,
        QryBO_ApiLog.Sel.AnswerHeader,
        QryBO_ApiLog.Sel.AnswerBody,
        QryBO_ApiLog.Sel.ErrorStackTrace);

JvDataSet ds = pageBase.execQuery(qdef);
%>

<div class="tab-content">
  <% if(ds.getField(QryBO_ApiLog.Sel.AnswerHeader).getHtmlString() != "") { %>
  <v:widget caption="Header">
    <v:widget-block>
      <% request.setAttribute("message", ds.getField(QryBO_ApiLog.Sel.AnswerHeader).toString()); %>
      <jsp:include page="../common/text_format_widget.jsp" />
    </v:widget-block>
  </v:widget>
  <% } %>

  <% if (!ds.getField(QryBO_ApiLog.Sel.AnswerBody).isNull()) { %>
  <v:widget caption="Body"> 
    <v:widget-block>
      <% request.setAttribute("message", ds.getField(QryBO_ApiLog.Sel.AnswerBody).toString()); %>
      <jsp:include page="../common/text_format_widget.jsp" />
    </v:widget-block>
  </v:widget>
  <% } %>

  <% if (!ds.getField(QryBO_ApiLog.Sel.ErrorStackTrace).isNull()) { %>
  <v:widget caption="Java Stack Trace"> 
    <v:widget-block>
      <% request.setAttribute("message", ds.getField(QryBO_ApiLog.Sel.ErrorStackTrace).toString()); %>
      <jsp:include page="../common/text_format_widget.jsp" />
    </v:widget-block>
  </v:widget>
  <% } %>
</div>