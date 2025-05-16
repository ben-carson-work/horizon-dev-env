<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:include page="admission-css.jsp" />
<script type="text/javascript" charset="utf-8" src="<v:config key="resources_url"/>/mobileAdmission/script/iphone-style-checkboxes.js"></script>
<div id="admission"  class="status-select">
	<%-- HEADER --%>
	<div class="toolbar">
		<div id="adm-title" class="title wrap">Admission</div>
		<!--<%-- Back BUTTON --%>
			<div class="back-btn img-undo button v-click">
				<div class="caption">Back</div>
			</div>
			<%-- test BUTTON 
				<div id="adm-test-btn" class="adm-test-btn button v-click enabled" >
				  <div class="caption">Sim. Read</div>
				</div> --%>
			<%-- TckNote BUTTON --%>
			<div class="manual-input-btn img-keyboard button v-click enabled">
				<div class="caption">Input</div>
			</div>-->
		<div class="access-point-name">
			No access point
		</div>
	</div>
	<%-- BODY --%>
	<div class="body ">
		<div class="infobar">
			Insert Media code to check it
		</div>
		<div class="actionbar">
			<div class="on_off">
				<input type="checkbox" id="" checked="checked" id="on_off_on" name="radio-scan-type"/>
			</div>
            <div class="button admission img-entry ftleft checked" id="redeembutton"  data-usagetype="<%=LkSNTicketUsageType.Entry.getCode()%>">
            Redeem Mode
            </div>
           <!--   <div class="button admission img-query ftleft" id="querybutton" data="0">
            Query Mode
            </div>
            -->
            <div class="button admission img-exit ftleft" id="exitbutton" data-usagetype="<%=LkSNTicketUsageType.Exit.getCode()%>">
            Exit Mode
            </div>
            <div class="admissionmode ftleft"></div>
            
			<div id="barcode-btn" class="actionbar-btn ftright img-camera button">Bar Code</div>
		</div>
		<div class="wrap scrolling">
			<div class="body-panel scrolling">
				<div class="ticket-input">
					<div id="search-bar">
						<input type="search" name="search" id="MediaCode" value="" />
						<br clear="all" />
					</div>
				</div>
				<div id="results" class="vpane hidden">
					<div id="operator-msg" class="vpane hidden">
						<div class="vblock">
							<span class="thumb" style="background-size: 80%"></span>
							<span class="text"></span>
							<br clear="all" />
						</div>
					</div>
					<div id="result" class="vpane hidden">
						<div id="ticket-info" class="vblock">
							<span class="thumb" style="background-image:url(' <v:image-link name="<%=LkSNEntityType.ProductType.getIconName()%>" size="100"/> '); background-size:80%"></span>
							<span class="text"><span class="product-name"></span><br /> <span class="product-code"></span></span><br />
							<br clear="all" />
						</div>
						<div id="account-info" class="vblock">
							<div id="no-account" style="display:none;">
								<span class="thumb"></span>
								<span class="text">
									<span class="account-name">Anonymous Account
									</span>
									<br />
								</span>
								<br />
								<br clear="all" />
							</div>
							<div id="yes-account" style="display:none;">
								<a href="javascript:openPicturePage();"><span class="thumb"></span></a><span class="text"><span class="account-name"></span><br />
								<span class="account-code"></span></span><br />
								<br clear="all" />
							</div>
						</div>
					</div>
					<br clear="all" />
				</div>
			</div>
		</div>
	</div>
</div>
<jsp:include page="admission-js.jsp" />
