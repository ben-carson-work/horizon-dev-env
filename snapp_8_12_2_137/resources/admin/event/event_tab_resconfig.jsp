<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEvent" scope="request"/>

<jsp:include page="../resource/resource_config_widget.jsp">
  <jsp:param name="RC-EntityType" value="<%=LkSNEntityType.Event.getCode()%>"/>
  <jsp:param name="RC-EntityId" value="<%=pageBase.getId()%>"/>
</jsp:include>