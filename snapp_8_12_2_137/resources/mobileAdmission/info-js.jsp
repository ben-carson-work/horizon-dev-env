<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<script type="text/javascript">

$(document).on('click','#accesspointlist-btn',function() {
	$(".accesspointlist-tab").show();
	$('.footer').addClass("hidden");
	$('#tabs').addClass("hidden");
	$('#accesspointlist .actionbar').removeClass("hidden");	
});

$(document).on('click','#aptName',function() {
	$(".accesspointlist-tab").show();
	$('.footer').addClass("hidden");
	$('#tabs').addClass("hidden");
	$('#accesspointlist #accesspointlistback-btn').removeClass("hidden");
	$('#accesspointlist .body-panel').scrollTop(0);
});

</script>
