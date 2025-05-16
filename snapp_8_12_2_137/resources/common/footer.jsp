<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<% // This IF-BLOCK is supposed to always fail. Just a workaround to resolve warning. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
<div><div>
<% } %>

</div>

</div>

<datalist id="DocDateEncode">
<% for (NDocDateEncode item : NDocDateEncode.values()) { %>
  <option value="<%=item.name()%>"><%=item.name()%></option>
<% } %>
</datalist>

</body>

</html>