<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request"/>

<script>
	
	
	$(document).on("click", '.proceed', function() {
		if (localStorage.getItem('AccountId')) {
			if ($('#location').val()) {
				OrderLocation = $('#location').val();
				//doTransaction();	
			} else {
				alert('Please insert the location');
				return false;
			}
		}
		OrderLocation = WorkstationName;
		$('#operatorCheckout').addClass('hidden');
		$('#beforepay').addClass('hidden');
		$('.tap').removeClass('hidden');
		sendCommand("StartRFID");
		window.OrderNote = $('#note').val();
	});
</script>