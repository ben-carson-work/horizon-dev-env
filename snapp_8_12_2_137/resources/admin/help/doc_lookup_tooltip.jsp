<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%
int code = JvString.strToIntDef(pageBase.getNullParameter("LookupTable"), -1);
LookupTable table = LookupManager.findTableByCode(LkSN.class, code);
%>

<div style="/*max-height:400px; overflow:auto*/">
<% if (table == null) { %>
  <i>Unable to find table with code <%=code%></i>
<% } else { %>
    <% for (LookupItem item : table.getItems()) { %>
      <div>[<%=item.getCode()%>] &nbsp; <%=item.getHtmlDescription(pageBase.getLang())%></div>
    <% } %>  
<% } %>
</div>

