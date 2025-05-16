<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:include page="checkout-css.jsp" />
<jsp:include page="checkout-js.jsp" />

<div id="checkoutContent">
	<div class="tap">
		Tap on back...
	</div>
	<div id="tapResults" class="hidden">
		<div id="tapResultsContent"></div>
		<div class="button pay disabled">Pay</div>
	</div>
	<div id="beforepay" class="hidden">
		<div id="noteContainer">
			<h1 style="margin:0; text-align:center;">Insert Notes</h1>
			<textarea id="note"></textarea>	
		</div>
		<div id="operatorCheckout" class="hidden">
			<h1 style="margin:0; text-align:center;">Insert the Order's Destination</h1>
			<input type="text" value="" name="location" id="location"/> 
		</div>
		<div class="button proceed">Proceed</div>
	</div>
</div>
