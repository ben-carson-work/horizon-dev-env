<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<style id="mainheader.jsp">
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

<div id="mainHeaderContent" class="col-md-12">
  <div class="mainHeaderBtnContainer">
    <div class="btn btn-default text-center" id="mainHeaderBack">
      <img src="<v:image-link name="bkoact-back.png" size="64"/>" class="img-responsive" />
    </div>
  </div>
  <div id="tab-header-redeem-manual" class=" hidden">
    <div class="pane-text"><input type="text" placeholder="<v:itl key="@Common.InsertBarcode"/>" style="text-transform:uppercase"/></div>
  </div>
  <div class="miniCartContainer">
    <div class="miniCart">
<!--       <div class="miniCartSubTotal"> -->
<%--         <div class="col-md-6 col-xs-6 "><v:itl key="@Common.SubTotal"/></div> --%>
<!--         <div class="col-md-6 col-xs-6 miniCartSubTotalValue text-right">0.00</div> -->
<!--       </div> -->
<!--       <div class="miniCartTax"> -->
<%--         <div class="col-md-6 col-xs-6 "><v:itl key="@Common.Tax"/></div> --%>
<!--         <div class="col-md-6 col-xs-6 miniCartTaxValue text-right">0.00</div> -->
<!--       </div> -->
      <div class="miniCartItems row">
<%--         <div class="col-md-6 col-xs-6 "><v:itl key="@Common.SubTotal"/></div> --%>
		<div class="col-md-12 col-xs-12 text-left">Quantity</div>
        <div class="col-md-12 col-xs-12 miniCartItemsValue text-right">0</div>
      </div>
      <hr/>
      <div class="miniCartTotal row">
<%--         <div class="col-md-4 col-xs-4 "><v:itl key="@Common.Total"/></div> --%>
		<div class="col-md-12 col-xs-12 text-left">Amount Due</div>
        <div class="col-md-12 col-xs-12 miniCartTotalValue text-right">0.00</div>
      </div>
    </div>
  </div>
  <div class="mainHeaderText hidden">
    Ready
  </div>
  <div class="mainHeaderBtnContainer">
    <div class="btn btn-default text-center disabled" id="mainHeaderClearCart">
       <img src="<v:image-link name="bkoact-no-black.png" size="64"/>" class="img-responsive" />
    </div>
  </div>
  <div class="mainHeaderBtnContainer">
    <div class="btn btn-default text-center disabled" id="mainHeaderContinue" >
    <span></span>
      <!--<img src="<v:image-link name="bkoact-forward.png" size="64"/>" class="img-responsive" />-->
    </div>
  </div>
	<br clear="all" />
</div>
