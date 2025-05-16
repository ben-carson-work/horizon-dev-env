<%@page import="com.vgs.cl.json.JSONObject"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>

  .xml-tag {
    color: #881280;
  }
  
  <% Boolean flat = (Boolean)request.getAttribute("flat"); %> 
  <% if ((flat == null) || flat) { %>
  pre {
    background: none;
    border: none;
    padding: 0;
  }
  <% } %>

</style>
  <%
  Throwable error = null;
  String msg = JvString.getEmpty((String)request.getAttribute("message"));
  try {
    if (msg.startsWith("{"))
      msg = new JSONObject(msg).toString(2);
    else if (msg.startsWith("<"))
      msg = JvDocUtils.docToHtml(msg);
  }
  catch (Throwable t) {
    error = t;
  }
  %>
  
  <% if (error != null) { %>
    <div class="errorbox"><%=JvString.escapeHtml(JvUtils.getErrorMessage(error))%></div>
  <% } %>
  
  <pre><%=msg%></pre> 

