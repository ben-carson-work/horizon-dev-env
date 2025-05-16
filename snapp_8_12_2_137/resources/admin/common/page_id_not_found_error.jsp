<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<% PageBase<?> pageBase = (PageBase<?>)request.getAttribute("pageBase");%>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<div id="main-container">
<snp:list-tab caption="@Common.Warning"/>
<div class="mainlist-container">

<div class="warning-box">
  <strong><v:itl key="@Common.Warning"/></strong>
  <br/>&nbsp;<br/>
  <v:itl key="@Common.PageIdNotFoundError" param1="<%=pageBase.getId()%>"/>
</div>

</div>
</div>
<jsp:include page="/resources/common/footer.jsp"/>
