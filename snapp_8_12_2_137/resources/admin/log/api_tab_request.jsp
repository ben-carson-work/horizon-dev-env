<%@page import="com.vgs.cl.json.*"%>
<%@page import="com.vgs.cl.json.JSONObject"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
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
        QryBO_ApiLog.Sel.RequestHeader,
        QryBO_ApiLog.Sel.RequestBody);

//Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<div class="tab-content">
  <% if(ds.getField(QryBO_ApiLog.Sel.RequestHeader).getHtmlString() != "") { %>
  <v:widget caption="Header">
    <v:widget-block>
      <% request.setAttribute("message", ds.getField(QryBO_ApiLog.Sel.RequestHeader).toString()); %>
      <jsp:include page="../common/text_format_widget.jsp" />
    </v:widget-block>
  </v:widget>
  <% } %>
  
  <% if (!ds.getField(QryBO_ApiLog.Sel.RequestBody).isNull()) { %>
  <v:widget caption="Body">
    <v:widget-block>
      <% request.setAttribute("message", ds.getField(QryBO_ApiLog.Sel.RequestBody).toString()); %>
      <jsp:include page="../common/text_format_widget.jsp" />
    </v:widget-block>
  </v:widget>
  <% } %>
</div>