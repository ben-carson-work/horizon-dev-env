<%@page import="com.vgs.cl.json.JSONObject"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageOutboundQueue" scope="request"/>

<% 
QueryDef qdef = new QueryDef(QryBO_OutboundQueue.class);
//Select
qdef.addSelect(QryBO_OutboundQueue.Sel.DocRef);

//Where
qdef.addFilter(QryBO_OutboundQueue.Fil.OutboundQueueId, pageBase.getId());

JvDataSet ds = pageBase.execQuery(qdef);

String msg = ds.getField(QryBO_OutboundQueue.Sel.DocRef).isNull("{}");
request.setAttribute("message", msg);
%>

<div class="tab-content">
  <v:widget caption="@Outbound.OutboundQueueReference">
    <v:widget-block>
       <jsp:include page="../common/text_format_widget.jsp"/>
    </v:widget-block>
  </v:widget>
</div>