<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>
<jsp:include page="mob-common-header.jsp"/>
  <h1 style="text-align:center; margin-top:20vw"><%=JvString.escapeHtml(pageBase.getParameter("error-msg"))%></h1>
<jsp:include page="mob-common-footer.jsp"/>
