<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<style id="mainsidebar.jsp_style">
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

<script  id="mainsidebar.jsp_script">
$(document).on("<%=pageBase.getEventMouseDown()%>",'#configPanelToggle',function(e) {
	e.stopPropagation();
	$('#configPanelContent').slideToggle( "slow");
});

function testPay() {
  NativeBridge.call("Pay", ["pay_mPOS", "12.34", "CD8510D5-9351-4D98-9FD4-11F5703D3981"], function (serial) {
      //doInit(serial);
    });
}
</script>
<div id="mainSidebarContent" class="">
  <div class="col-md-2 col-xs-2 footerBtnContainer text-center active btn btn-block goToCatalog">
    <img src="<v:image-link name="mob-menu.png|TransformNegative" size="128"/>"  class="img-responsive" />
    
    <v:itl key="@Product.Catalog"/>
  </div>  
  <div class="col-md-2 col-xs-2 footerBtnContainer text-center btn btn-block goToShopcart">
    <img src="<v:image-link name="bkoact-basket.png|TransformNegative" size="128"/>"  class="img-responsive"  />
    
    <v:itl key="@Common.ShopCart"/>
  </div>  
  <div class="col-md-2 col-xs-2 footerBtnContainer text-center btn btn-block goToAccount">
    <img src="<v:image-link name="mob-pos-account.png|TransformNegative" size="128"/>"  class="img-responsive"/>
    
    <v:itl key="@Account.Account"/>
  </div>
  <div class="col-md-2 col-xs-2 footerBtnContainer text-center btn btn-block  goToInfo">
    <img src="<v:image-link name="bkoact-info.png|TransformNegative" size="128"/>" class="img-responsive"/>
    
    <v:itl key="@Account.Account"/>
  </div>
  <div class="col-md-2 col-xs-2 footerBtn">
  </div>
  <div class="col-md-2 col-xs-2 footerBtn">
  </div>
</div>
