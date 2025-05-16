<%@ page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request"/>
<jsp:include page="app_sales_operator-js.jsp" />
<jsp:include page="app_sales_operator-css.jsp" />

<div id="appSalesGuestContent">
	<div id="homeContent">
		<div class="appSalesGuestButtonContainer"  id="lookupButton">
			<div class="appSalesGuestButtonContent">
				<div class="appSalesGuestButtonImage">
				</div>
				<div class="appSalesGuestButtonName">
					Account Check
				</div>
			</div>
		</div>
    <div class="appSalesGuestButtonContainer" id="buyButton">
      <div class="appSalesGuestButtonContent">
        <div class="appSalesGuestButtonImage">
        </div>
        <div class="appSalesGuestButtonName">
          Buy
        </div>
      </div>
    </div>
    <div class="appSalesGuestButtonContainer" id="accountButton">
      <div class="appSalesGuestButtonContent">
        <div class="appSalesGuestButtonImage">
        </div>
        <div class="appSalesGuestButtonName">
          Create Account
        </div>
      </div>
    </div>
 		<br clear="all" />
	</div>

</div>
