<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>



<div class="tab-content">
  <div class="profile-cont-div">
    <jsp:include page="../invoice/invoice_list_widget.jsp"/>
  </div>
</div>