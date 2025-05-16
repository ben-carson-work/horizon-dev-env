<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<script type="text/javascript">

$(document).ready(function() {
	
	
	$('.scrolling').bind("touchmove", function(e) {
	    e.stopPropagation();
	});

	$(document ).on( "click",".event", function() {
		$('#eventattributes').attr('rel',$(this).attr('rel'));
//		var attributes = JSON.parse($(this).attr('rel'));
//		alert(JSON.stringify(attributes));
		$("#eventlist #alertmsgbg").show();
	});
	$("#eventlist #alertmsgBtnYes").click(function() {
		
		var attributes = JSON.parse($('#eventattributes').attr('rel'));
		
		$("#eventlist #alertmsgbg").hide();
		saveEventId(attributes.EventId,attributes.EventName,attributes.LocationId,attributes.AccessAreaId,attributes.DefaultPerformanceDuration);
	});
	$(document).on("click","#eventlist #alertmsgBtnCancel",function() {
		$("#alertmsgbg").hide();
		
	});
	function saveEventId(eventId,eventName,LocationId,AccessAreaId,DefaultPerformanceDuration) {
		    localStorage.setItem("eventId", eventId);
	        localStorage.setItem("eventName", eventName);
	        localStorage.setItem("LocationId", LocationId);
	       
	        reqDO = {
	    		    Command: "SavePerformance",
	    		    SavePerformance: {
		    		    Performance: {
		    		    	EventId: eventId,
		    		    	PerformanceStatus: 2,
		    		    	LocationId: LocationId,
		    		    	AccessAreaId: AccessAreaId
		    		    }
	    		    }
	    		  };
	        //alert(JSON.stringify(reqDO));
	        //return false;
	        //$('#floatingBarsG').show();
	    		vgsService('Performance',reqDO,false, function(ansDO) {
	    			//$('#floatingBarsG').hide();
	    			//alert(JSON.stringify(ansDO.Answer.SavePerformance));
	    			var performanceId = ansDO.Answer.SavePerformance.PerformanceId;
	    			localStorage.setItem("performanceId", performanceId);
	    			localStorage.setItem("performanceId",performanceId);
					localStorage.setItem("eventId",eventId);
					localStorage.setItem("eventName",eventName);
					$('#admission-tab').removeClass("hidden");
	    	        $('#peoplelist-tab').removeClass("hidden");
	    	        $('#eventlist-tab').addClass("hidden");
	    	        $('#admission .infobar').html("Current Event: "+eventName);
	    	        $('#info .infobar').html("Current Event: "+eventName);
	    	        $('#peoplelist .infobar').html("Current Event: "+eventName);
					//$('#accesspointlist-btn').addClass("hidden");
					$('#admission-tab').removeClass("hidden");
				    $('#peoplelist-tab').removeClass("hidden");
					mainactivity(mainactivity_step.admission);

	    		});
	 }
	function getDateTime(DefaultPerformanceDuration) {
	    var now     = new Date(); 
	    var year    = now.getFullYear();
	    var month   = now.getMonth()+1; 
	    var day     = now.getDate();
	    var hour    = now.getHours();
	    var minute  = now.getMinutes();
	    var second  = now.getSeconds(); 
	    if(month.toString().length == 1) {
	        var month = '0'+month;
	    }
	    if(day.toString().length == 1) {
	        var day = '0'+day;
	    }   
	    if(hour.toString().length == 1) {
	        var hour = '0'+hour;
	    }
	    if (DefaultPerformanceDuration){
	    	minute = minute+DefaultPerformanceDuration;
	    } else {
	    	minute = minute-5;
	    }
	    if(minute.toString().length == 1) {
	        var minute = '0'+minute;
	    }
	    if(second.toString().length == 1) {
	        var second = '0'+second;
	    }   
	    var dateTime = year+'-'+month+'-'+day+'T'+hour+':'+minute+':'+second;   
	    return dateTime;
	}

});
$(document).on("<%=pageBase.getEventMouseDown()%>", "#eventlist-tab", function() {
	$('#eventlist .body-panel').scrollTop(0);
	var eventId = localStorage.getItem("eventId");
	
	$('#admission-tab').addClass("hidden");
	$('#peoplelist-tab').addClass("hidden");
	reqDO = {
		    Command: "Search",
		    Search: {
          AccessPointId: localStorage.getItem("aptId"),
          PerfOnDemand: true
		    }
		  };
	$('#floatingBarsG').show();
		vgsService('event',reqDO,false, function(ansDO) {
			$('#floatingBarsG').hide();
			//alert(JSON.stringify(ansDO));
			var eventlist = '';
			//for (i = 0; i < ansDO.Answer.Search.EventList.length; i++) { 
				if (ansDO.Answer) {
				$.each(ansDO.Answer.Search.EventList,function (index,value) {
				//alert(JSON.stringify(value));
    				if (value.TracePortfolioInPerformance) {
        				if (value.ProfilePictureId != null) {
        					bg = '<v:config key="site_url"/>/repository?id='+value.ProfilePictureId+'&type=small';
        				} else {
        					bg = '<v:image-link name="<%=LkSNEntityType.Event.getIconName()%>" size="100"/>';
        				}
        				eventlist += 
        				"<li class='event' rel='"+JSON.stringify(value)+"'>"+
        					'<div id="apt-info" class="vblock">'+
        						'<span class="thumb" style="background-image:url('+bg+'); background-size:80%">' +
        						'</span>' +
        						'<span class="apt-name">' +
        						value.EventName +
        						'</span>'+
        						'<br/>'+
        						'<span class="apt-detail">' +
        						value.EventCode +
        						'</span>'+
        						'<br/>'+
        						'<span class="apt-detail">'+
        							'' +
        						'</span><br/>'+
        					'</div>'+
        				'</li>';
    				}    
  				});
				}
  				$('#ULeventlist').html(eventlist);
				
			//}	
		});
	
});

</script>
