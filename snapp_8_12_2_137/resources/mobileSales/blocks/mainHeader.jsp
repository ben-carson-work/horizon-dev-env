<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<style>
#configPanel {
display:none;
	z-index: 1000000000;
	width: 60vw;
	margin: 0 20vw;
	position: absolute;
	top: 0;
	height: 2vh;
}
div#configPanelContent {
	width: 100%;
	display: block;
	overflow: hidden;
	display:none;
	background:#FFF;
	padding: 10px;
}

#configPanelToggle {
	background: #fff;
	width: 50px;
	border-bottom-left-radius: 10px;
	border-bottom-right-radius: 10px;
	height: 20px;
	text-align: center;
	float: right;
	border-bottom: 2px solid rgb(0,155,133);
	border-left: 2px solid rgb(0,155,133);
	border-right: 2px solid rgb(0,155,133);
}

.settings {
	float:left;
	margin:0 30px;
	font-size:9px;
	text-align:center;
	text-decoration:none;
	line-height:50px;
}
</style>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request"/>

<script>
$(document).on("<%=pageBase.getEventMouseDown()%>",'#configPanelToggle',function(e) {
	e.stopPropagation();
	$('#configPanelContent').slideToggle( "slow");
});
</script>
<div id="mainHeaderContent">
	<div id="logo"></div>
	<div id="WkName"></div>
	<div id="controls">
		<a href="javascript:void(0)" class="button back navigation hidden" id="mainHeaderBack"></a>
		<a href="javascript:void(0)" class="button home navigation" id="mainHeaderHome"></a>
		
		<div id="mainHeaderCart">
			<span id="mainHeaderCartItems">No items</span><br />
			<span id="mainHeaderCartTotal">&euro; 0.00</span>
		</div>
		<a href="javascript:void(0)" class="button" id="mainHeaderCartButton">
			<span class="buttonText">
				Review Order
			</span>
		</a>
		<a href="javascript:void(0)" class="button hidden" id="mainHeaderCheckoutButton">
			<span class="buttonText">
				Checkout
			</span>
		</a>
	</div>
</div>
<div id="configPanel">
	<div id="configPanelContent">
		<a href="javascript:void(0)" class="button settings" id="settings" style="float:left;">Settings</a>
		<a href="javascript:void(0)" class="button settings" id="title" style="line-height:25px">Show/Hide Title</a>
	</div>
	<div id="configPanelToggle">
	</div>
</div>