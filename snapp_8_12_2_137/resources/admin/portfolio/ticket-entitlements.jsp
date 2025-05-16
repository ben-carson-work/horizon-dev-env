<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicketEntitlements" scope="request"/>
<!DOCTYPE html>
<html>
  <jsp:include page="/resources/common/header-head.jsp"/>

  <body style="padding:10px">  
    <% 
    DOEntitlement entitlement = pageBase.getBL(BLBO_Entitlement.class).getTicketEntitlement(pageBase.getId());
    request.setAttribute("entitlement", entitlement);
    request.setAttribute("entitlement-readonly", "true");
    %>
    <jsp:include page="../entitlement/entitlement_widget.jsp"/>
  </body>
</html>