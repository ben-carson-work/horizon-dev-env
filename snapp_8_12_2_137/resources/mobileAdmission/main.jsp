<%@ page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">	
<html>
	<head>
		<title><v:config key="site_title"/></title>
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
		<META HTTP-EQUIV="Expires" CONTENT="-1"> 
    <meta http-equiv="X-Frame-Options" content="SAMEORIGIN">
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
		<script type="text/javascript" charset="utf-8" src="<v:config key="site_url"/>/libraries/jquery/jquery-2.2.0.min.js"></script>
		<jsp:include page="main-css.jsp" />
		<jsp:include page="main-js.jsp" />
    <jsp:include page="../mobileCommon/functions.jsp" />
	</head>
 	<body>
  <jsp:include page="../mobileCommon/login.jsp" />
  <div id="WkName"></div>
 	<div id="content" style="">
 	<div class="tabs accesspointlist-tab">
		<jsp:include page="accesspointlist.jsp" />
	</div>
		<div id="tabs">
			<div class="tabs eventlist-tab">
				<jsp:include page="eventlist.jsp" />
			</div>
			<div class="tabs admission-tab">
				<jsp:include page="admission.jsp" />
			</div>
			<div class="tabs peoplelist-tab">
				<jsp:include page="peoplelist.jsp" />
			</div>
			<div class="tabs info-tab">
				<jsp:include page="info.jsp" />
			</div>
			
			
		</div>
		<div class="footer">
			<div class="inner">
				<%-- ADMISSION --%>
				<div id="eventlist-tab" class="tab enabled">
					<div class="icon img-event"></div>
					<div class="caption">Event List</div>
				</div>
				<div id="admission-tab" class="tab enabled">
					<div class="icon img-accessctrl"></div>
					<div class="caption">Admission</div>
				</div>
				<div id="peoplelist-tab" class="tab enabled">
					<div class="icon img-people"></div>
					<div class="caption">People</div>
				</div>
				<div id="info-tab" class="tab enabled">
					<div class="icon img-property"></div>
					<div class="caption">Info</div>
				</div>
			</div>
		</div>
	</div>
	<div id="floatingBarsG" style="display:none;">
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
	<div id="tecnicmsg" style="display:none;">
			<div id="tecnicmsgHeader"></div>
			<div id="tecnicmsgContent"></div>
			<div id="alertmsgBody">
				<div id="tecnicmsgBtn" class="tecnicmsgBtn">OK</div>
			</div>
	</div>
    
    <div id="dialogBG" style="display:none;">
      <div id="dialogBox">
        <div id="dialogTitle">
        </div>
        <div id="dialogContent">
        </div>
      </div>
    </div>
	<script>
		$(".tab").bind("<%=pageBase.getEventMouseDown()%>", function() {
		   // alert("main");
			if ($(this).hasClass("tab-pressed"))
			   $(this).trigger("tabroot");
			else {
			    if ($(this).hasClass("enabled")) {
			  	    var tab = $(this).attr('id');
			        
			        $(".tab").removeClass("tab-pressed");
			        $(this).addClass("tab-pressed");
			        
			        $("#tabs .tabs").removeClass("show");
			        $('#tabs .'+tab).addClass("show");
			        
			        //setActiveFunc(lookup_func.idle);	    	  
			    }
			}
		});
	</script>
	</body>
</html>
