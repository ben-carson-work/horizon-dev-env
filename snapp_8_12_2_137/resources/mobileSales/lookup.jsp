<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:include page="lookup-css.jsp" />
<jsp:include page="lookup-js.jsp" />
<div id="lookupContent">
<div class="tap">
	Tap on back...
</div>
<div id="lookupResults" class="hidden">
	<div id="lookupResultsContent"></div>
</div>
</div>