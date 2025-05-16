<%@ page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<!DOCTYPE html>	
<html>
	<head>
		<title>SnApp - Mobile POS</title>
		<!-- <v:config key="site_title"/> -->
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="-1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <link rel="shortcut icon" href="<v:config key="site_url"/>/resources/admin/images/favicon.ico">
    <jsp:include page="../mobileCommon/mob-common-header.jsp" />
    <jsp:include page="main-css.jsp" />
	<jsp:include page="main-js.jsp" />
	<jsp:include page="sale-controller-js.jsp" />
    <jsp:include page="../mobileCommon/functions.jsp" />
      
	</head>
 	<body>
      
 		<div id="mainBody">
	 		<div id="mainHeader">
		 		<jsp:include page="blocks/mainHeader.jsp" />
			</div>
      <div id="mainSidebar">
        <jsp:include page="blocks/mainSidebar.jsp" />
      </div>
		 	<div id="mainContainer" class="col-md-12 col-xs-12" >
      
		 		<div id="mainBreadcrumbs">
			 		<jsp:include page="blocks/mainBreadcrumbs.jsp" />
				</div>
				<br clear="all" />
				<div id="mainContent" class="scrolling col-md-12 col-xs-12">
					<div id="catalogContainer" class="hidden scrolling page">
						<jsp:include page="catalog.jsp" />
					</div>
					<br clear="all" />
					<div id="checkoutContainer" class="hidden page">
						<jsp:include page="checkout.jsp" />
					</div>
					<div id="transactionResultContainer" class="hidden page">
						<div id="transactionResultContent">
							<div id="transactionResult">
								<div class="thumb">
								</div>
								<div class="text">
								</div>
								<br clear="all" />
							</div>
							<div id="transactionResultLookup">
							</div>
						</div>
					</div>
					<div id="cartContainer" class="hidden page">
						<jsp:include page="cart.jsp" />
					</div>
          <div id="eventContainer" class="hidden scrolling page">
            <jsp:include page="event.jsp" />
          </div>
          <div id="mediaContainer" class="hidden scrolling page">
            <jsp:include page="mediaAssoc.jsp" />
          </div>
          <div id="lookupContainer" class="hidden page">
            
          </div>
          <div class="hidden">
            <jsp:include page="form-medialookup.jsp"/>    
          </div>
          <div id="registrationContainer" class="hidden scrolling page">
            <jsp:include page="account.jsp" />
          </div>
         <div id="infoContainer" class="hidden scrolling page">
            <jsp:include page="info.jsp" />
          </div>
				</div>
			</div>
      <div id="mainFooter">
        <jsp:include page="blocks/mainFooter.jsp" />
      </div>
		</div>
		<div id="floatingBarsGbg">
			<div id="floatingBarsG" class="">
				<div class="blockG" id="rotateG_01">
				</div>
				<div class="blockG" id="rotateG_02">
				</div>
				<div class="blockG" id="rotateG_03">
				</div>
				<div class="blockG" id="rotateG_04">
				</div>
				<div class="blockG" id="rotateG_05">
				</div>
				<div class="blockG" id="rotateG_06">
				</div>
				<div class="blockG" id="rotateG_07">
				</div>
				<div class="blockG" id="rotateG_08">
				</div>
			</div>
		</div>
		<div id="results"></div>
		<div id="dialogBG" style="display:none;">
			<div id="dialogBox">
				<div id="dialogTitle">
				</div>
				<div id="dialogContent">
				</div>
			</div>
		</div>
    <div class="modal fade" tabindex="-1" role="dialog" id="myModal">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <!-- <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>-->
            <h4 class="modal-title"></h4>
          </div>
          <div class="modal-body">
            
          </div>
          <div class="modal-footer">
          </div>
        </div>
      </div>
    </div>
 
    <div class="flex formNavigation" style="display:none;">
      <div class="col-md-2 col-xs-2 text-center btn formPrev">
        <img src="<v:image-link name="bkoact-prev-grey.png" size="64"/>" />
        <br />
        <v:itl key="@Common.Prev"/>
      </div>
      <div class="col-md-2 col-xs-2 text-center btn">
        
      </div>
      <div class="col-md-2 col-xs-2 text-center btn copyLast">
        <img src="<v:image-link name="bkoact-copy-grey.png" size="64"/>" />
        <br />
        <v:itl key="@Common.Copy"/>
      </div>
      <div class="col-md-2 col-xs-2 text-center btn formCancel">
        <img src="<v:image-link name="bkoact-cancel-grey.png" size="64"/>" />
        <br />
        <v:itl key="@Common.Cancel"/>
      </div>
      <div class="col-md-2 col-xs-2 text-center btn formSave saveTicketAccount">
        <img src="<v:image-link name="bkoact-save-grey.png" size="64"/>" />
        <br />
        <v:itl key="@Common.Save"/>
      </div>
      <div class="col-md-2 col-xs-2 text-center btn formNext">
        <img src="<v:image-link name="bkoact-next-grey.png" size="64"/>" />
        <br />
        <v:itl key="@Common.Next"/>
      </div>
    </div>
  
    
		<div id="wrap" class="hidden">
			<div class="wrapBlocker"></div>
    		<iframe id="frame" src="" ></iframe>
        </div>
        
        
        <div id="version" class=""></div>
	</body>
</html>
