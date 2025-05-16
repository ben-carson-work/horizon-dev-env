<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.web.queue.outbound.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<div class="tab-content">
  <v:alert-box type="warning">
    <% String href = rights.QueueURL.getString() + "/admin?page=outboundcfg&tab=broker";%>
    <v:itl key="@Outbound.OutboundBrokersLink"/>&nbsp;
    <a href="<%=href%>" target="_blank"><%=href%></a>
  </v:alert-box>
</div>  



