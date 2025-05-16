<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request"/>

<script>
	$(document).on("click",'#buyButton',function() {
		mainactivity(mainactivity_step.catalog);
	});
	$(document).on("click",'#lookupButton',function() {
		mainactivity(mainactivity_step.lookup);
	});
  $(document).on("click",'#accountButton',function() {
    mainactivity(mainactivity_step.account);
  });
</script>