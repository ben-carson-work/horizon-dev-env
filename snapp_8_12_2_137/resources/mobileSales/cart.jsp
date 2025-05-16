<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:include page="cart-js.jsp" /> 
<jsp:include page="cart-css.jsp" />

<div id="cartContent" class="">
	<div class="scrolling cartRowsContainer" >
		<table style="width:100%" class="">
		<thead class="cartHeader">
			<tr class="">
				<th class="productImage"></th>
				<th class="cartProductName">Product Name</th>
				<th class="cartItemUnitPrice">unitPrice</th>
				<th class="quantity">#</th>
				<th class="buttons">&nbsp;</th>
				<th class="cartItemPrice">Price</th>
				<th class="delete">&nbsp;</th>
			</tr>
		</thead>
		<tbody  class="cartRows">
		</tbody>
		</table>
	</div>
</div>
