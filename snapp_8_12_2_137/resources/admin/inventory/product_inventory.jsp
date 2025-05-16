<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<!DOCTYPE html>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProductInventory" scope="request"/>
<html>
<jsp:include page="/resources/common/header-head.jsp"/>

<body>
  <jsp:include page="product_inventory_widget.jsp"/>
</body>

</html>