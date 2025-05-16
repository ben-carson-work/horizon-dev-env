<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_SqlConsole" scope="request"/>

<%
String errorMessage = pageBase.getParameter("errorMessage");
Integer updateCount = (Integer)request.getAttribute("updateCount"); 
JvDataSet ds = (JvDataSet)request.getAttribute("ds"); 
%>

<% if (errorMessage != null) { %>
  <pre style="color:var(--base-red-color)"><%=JvString.escapeHtml(pageBase.getParameter("errorMessage"))%></pre>
<% } else if (updateCount != null) { %>
  <pre>(<%=pageBase.getParameter("updateCount")%> row(s) affected)</pre>
<% } else { %>
  <v:grid>
    <thead>
      <tr>
      <% for (JvDataSet.Column col : ds.getColumns()) { %>
        <td><%=JvString.escapeHtml(col.columnName)%></td>
      <% } %>
      </tr>
    </thead>
    <tbody>
      <%
      int maxResults = 1000;
      while (!ds.isEof()) {
        %><tr><%
        for (JvDataSet.Column col : ds.getColumns()) {
          %><td><%=ds.getField(col.columnName).getHtmlString()%></td><%
        }
        %></tr><%
        
        ds.next(); 

        if (ds.getRecNo() > maxResults) {
          %><tr><td colspan="100%">-- rendering cut at <%=maxResults%> results --</td></tr><%
          break;
        }
      }      
      %>
    </tbody>
  </v:grid>
<% } %>

