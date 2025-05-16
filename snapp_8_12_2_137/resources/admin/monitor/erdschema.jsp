<%@page import="com.vgs.snapp.dataobject.DOSchemaTable"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="java.io.*" %>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageErdSchema" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
File fileSchema = new File( JvString.addTrailingSlash(BLBO_Right.findServerLocalCachePath()) + "map.html");
%>

<jsp:include page="/resources/common/header-head.jsp"/>

<%-- had to set the margin top of the wait-glass-spinner because the height of the page is too wide and it wont show up (it will show on the exact half of the page bc of the image) --%>
<style>
.v-wait-glass-spinner{
  margin-top: 100px !Important;
}
</style>

<div>
  <% if (fileSchema.exists()) { %>
    <img src="<v:config key="site_url"/>/repository?Id=<%=pageBase.getEmptyParameter("RepositoryId") %>" usemap="#dbschema" border="0" alt="dbSchema" usemap="#dbschema">
    <% try (Scanner scan = new Scanner(fileSchema)) { %>
      <% while(scan.hasNextLine()) { %>
        <%=scan.nextLine() %>
      <% } %>
    <% } %>
  <% } %>
</div>

<script>
<% if (request.getParameter("table") != null) { %>
showWaitGlass();
window.onload = scrollToPoint;

function scrollToPoint() {
	var coords = $('#<%=request.getParameter("table")%>').attr('coords').split(',');
	var width = coords[2] - coords[0];
	var height = coords[3] - coords[1];
	var x = coords[0] - document.body.clientWidth/2 + width/2;
  var y = coords[1] - document.body.clientHeight/2 + height/2;
  
  hideWaitGlass();
  window.scrollTo(x,y);
  <% if (!JvString.isSameString(JvString.getEmpty(request.getParameter("table")),"")) { %>
    $('#<%=request.getParameter("table")%>').focus();
  <% } %>
}
<% } %>
</script>

<jsp:include page="/resources/common/footer.jsp"/>