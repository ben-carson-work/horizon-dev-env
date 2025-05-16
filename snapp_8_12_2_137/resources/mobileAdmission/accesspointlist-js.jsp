<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<script type="text/javascript">

$(document).on('click','#accesspointlistback-btn',function() {
	$(".accesspointlist-tab").show();
	$('.footer').addClass("hidden");
	$('#tabs').addClass("hidden");
});

$(document).ready(function() {
	$('.scrolling').bind("touchmove", function(e) {
	    e.stopPropagation();
	});

	$(document ).on( "click",".apt", function() {
		var attributes = JSON.parse($(this).attr('rel'));
		//alertjson(attributes);
		saveAptId(attributes.AccessPointId,
				attributes.AccessPointName,
				attributes.AccessPointCode,
				attributes.LocationName,
				attributes.AptEntryControl,
				attributes.AptExitControl,
				attributes.AptCheckValidPerf);
	});	
});

function searchApt() {
	reqDO = {
		Command : 'SearchApt',
			SearchApt: {
				DrvClassAlias: ['apt_mobile_adm']	
			}
	  }; 
	
	vgsService('Workstation',reqDO,false, function(ansDO) {
		//alertjson(ansDO);
		var accesspointlist = '';
		for (i = 0; i < ansDO.Answer.SearchApt.AccessPointList.length; i++) { 
			accesspointlist += 
			"<li class='apt' rel='"+JSON.stringify(ansDO.Answer.SearchApt.AccessPointList[i])+"'>"+
				'<div id="apt-info" class="vblock">'+
					'<span class="thumb" style="background-image:url(\'<v:image-link name="accesspoint.png" size="100"/>\'); background-size:80%">' +
					'</span>' +
					'<span class="apt-name">' +
						ansDO.Answer.SearchApt.AccessPointList[i].AccessPointName +
					'</span>'+
					'<br/>'+
					'<span class="apt-detail">' +
						ansDO.Answer.SearchApt.AccessPointList[i].AccessPointCode +
					'</span>'+
					'<br/>'+
					'<span class="apt-detail">'+
					ansDO.Answer.SearchApt.AccessPointList[i].LocationName +
					'</span><br/>'+
				'</div>'+
			'</li>';
		  $('#ULaccesspoinlist').html(accesspointlist);
		}
	});
}

function saveAptId(aptId, aptName, aptCode, aptLocation,AptEntryControl,AptExitControl,AptCheckValidPerf) {
	localStorage.setItem("aptId", aptId);
	localStorage.setItem("aptName", aptName);
	localStorage.setItem("aptCode", aptCode);
	localStorage.setItem("aptLocation", aptLocation);
	
	localStorage.removeItem("aptEntryControl");
  localStorage.removeItem("aptExitControl");
  localStorage.removeItem("aptCheckValidPerf");
	localStorage.setItem("aptEntryControl", AptEntryControl);
  localStorage.setItem("aptExitControl", AptExitControl);
  localStorage.setItem("aptCheckValidPerf", AptCheckValidPerf);
	
	$('.admission.button').removeClass('checked');
	
	if (AptExitControl==0) {
		$('#exitbutton').hide();
	} else {
		$('#exitbutton').show();
		$('#exitbutton').addClass('checked');
	}
	if (AptEntryControl==0) {
		$('#redeembutton').hide();
	} else {
		$('.admission.button').removeClass('checked');
		$('#redeembutton').show();
		$('#redeembutton').addClass('checked');
	}
	localStorage.removeItem("eventId");
	setAccesspointName();
	
	$('.footer').removeClass("hidden");
	$('#tabs').removeClass("hidden");
	$('.accesspointlist-tab').hide();
	$('#admission-tab').addClass("hidden");
	$('#peoplelist-tab').addClass("hidden");
	if (AptCheckValidPerf)
	  mainactivity(mainactivity_step.checkActPerf);
	else
    mainactivity(mainactivity_step.admission);
}

function setAccesspointName() {
	$('#aptName').html(localStorage.getItem("aptName")+" >");
  $('#aptCode').html(localStorage.getItem("aptCode"));
  $('#aptLocation').html(localStorage.getItem("aptLocation"));
	$('#info .infobar').html(localStorage.getItem("aptName"));
	$('.access-point-name').html(localStorage.getItem("aptName"));
}

$(document).on('click','#accesspointlistback-btn',function() {
	$(".accesspointlist-tab").hide();
	$('.footer').removeClass("hidden");
	$('#tabs').removeClass("hidden");
});

</script>
