<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<script>
var GOOD_RESULT_TIME = 10000;
var MAX_READ_TIME = 35000;
var ILVScannerStatusCode_ScannerTimeout = 4;
var ILVScannerStatusCode_BarcodeFail = 5;
var ILVScannerStatusCode_BadRead = 7;
var dragstart = 0;
var doclick = true;

function init(selector) {
  var btns = $(selector).filter(".button").not(".initialized");
  btns.addClass("initialized");
  
  btns.bind("<%=pageBase.getEventMouseDown()%>", function() {
    $(this).filter(".enabled").addClass("button-pressed");
  });
  
  btns.bind("<%=pageBase.getEventMouseUp()%>", function() {
    $(this).removeClass("button-pressed");
  });
  
  $("<span class='press-shade'></span>").appendTo(btns);
}

$(document).ready(function() {
  init(".button, .v-click");
	NativeBridge.call("getDeviceId", ["firstArgument"], function (serial) {
		doInit(serial);
  	});
	
	
	localStorage.removeItem("AccountId");
	//doInit('05EFA78F-D2E6-46F0-8E73-2CE5156B2788');
  	
  //doInit('C05060A2-FBF3-4649-B40D-B35EA8649167'); // spa
	
});

var workstationId;
function doInit(wksId) {
	workstationId = wksId;
	if (!localStorage.getItem('AccountId')) {
		$('#loginBg').removeClass('hidden');
	}
}

$(document).on('submit','#loginForm',function(){
	dologin('checkAptId');
	return false;
});

$(document).on("<%=pageBase.getEventMouseDown()%>", '.logout', function() {
  dologout();
});

$(document).bind("touchmove", function(e) {
  e.preventDefault();
});


$(document).bind("VGS_ScannerError", function(event, msg) {
	var dlg = showMessage({
	   text: msg,
	   buttons: {
	     "OK": function() {
	       dlg.remove();
	     }
	   }
	 }); 
});

Number.prototype.formatMoney = function(c, d, t) {
  var n = this, c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "." : d, t = t == undefined ? "," : t, s = n < 0 ? "-" : "", i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
     return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

function formatMoney(value) {
  return "$ " + (value).formatMoney(2, ".", ",");
}

jQuery.fn.setClass = function(clazz, condition) {
  if (condition)
    $(this).addClass(clazz);
  else
    $(this).removeClass(clazz);
};

jQuery.fn.startSpinner = function() {
  if ($(this).hasClass("button") && !$(this).hasClass("spinner")) {
    $(this).addClass("spinner");
    $("<div class='spinner-elem'/>").appendTo(this);
  }
};

jQuery.fn.stopSpinner = function() {
  if ($(this).hasClass("button") && $(this).hasClass("spinner")) {
    $(this).removeClass("spinner");
    $(this).find(".spinner-elem").remove();
  }
};

jQuery.fn.toggleSpinner = function() {
  if ($(this).hasClass("spinner"))
    $(this).stopSpinner();
  else
    $(this).startSpinner();
};


function dispatchAppEvent(eventName, data) {
  $(document).trigger(eventName, data);
}

function coalesce(array) {
  if (array != null) {
    for (var i=0; i<array.length; i++)
      if (array[i] != null)
        return array[i];
  }
  return null;
}

function showError(errorMsg) {
  var dlg = showMessage({
	     text: errorMsg,
	     buttons: {
	       "OK": function() {
           event.preventDefault();
	         dlg.remove();
	       }
	     }
	   }); 	  
}

function showDialog(Title,Htmlmsg,close,w,h) {
	if (close) {
		$(document).on("click",'#dialogBG',function() {
			hideDialog();
		});
	}
	
	$('#dialogBox').css('width',w);
	$('#dialogBox').css('height',h);
 
	$('#dialogTitle').html(Title);
	$('#dialogContent').html(Htmlmsg);
	$('#dialogBG').show();
}

function hideDialog() {
	$('#dialogBG').hide();
}

function alertjson(message) {
	alert(JSON.stringify(message,null,4));
}

function showMessage(options) {
  if (options != null) {
    var dlg = $("<div/>");

    $("<div class='dialog-title'/>").appendTo(dlg).html(coalesce([options.title, "<v:config key="site_title"/>"]));
    var body = $("<div class='dialog-body'/>").appendTo(dlg);
    body.html(options.text);
    
    body.css('top', coalesce([options.bodyTop, "40"]));
    
    if (options.buttons != null) {
      var buttons = $("<div class='dialog-buttons'/>").appendTo(body);
      for (var key in options.buttons) {
        var btn = $("<div class='button v-click enabled'/>").appendTo(buttons);
        
        if ((key.toLowerCase() == "ok") || (key.toLowerCase() == "yes"))
          btn.css({"background-image": "url('<v:image-link name="yes.png" size="70" />')", "background-position":"center center"});
        else if ((key.toLowerCase() == "cancel") || (key.toLowerCase() == "no"))
          btn.css({"background-image": "url('<v:image-link name="no.png" size="70" />')", "background-position":"center center"});

          $("<div class='caption'/>").appendTo(btn).html(key);
        init(btn);
        btn.bind("<%=pageBase.getEventClick()%>", options.buttons[key]);
      }
    }
    
    return showDialog(dlg, options);
  }
}

function asyncRemove(selector) {
  $(selector).addClass("hidden-to-remove");
  setTimeout(function() {
    $('.hidden-to-remove').remove();
  }, 100);
}

function formatVisualId(visualId) {
  return visualId.substring(0, 4) + " " + visualId.substring(4, 8) + " " + visualId.substring(8);
}

function getUsageIcon(usageType) {
  if (usageType == 0)
    return "<v:image-link name="usage_entry.png" size="32"/>";
  else if (usageType == 4)
    return "<v:image-link name="usage_reentry.png" size="32"/>";
  
  return null;
}

function dateFromXMLString(xmlDate)
{
  if (!/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}/.test(xmlDate)) {
       throw new RangeError("xmlDate must be in ISO-8601 format YYYY-MM-DD.");
  }
  return new Date(xmlDate.substring(0,4), xmlDate.substring(5,7)-1, xmlDate.substring(8,10));
}

function getFiscalEndOfDay(date) {
	var result = new Date(date);
	result.setDate(result.getDate() + 1); 
	result.setHours(6, 0, 0, 0);
	return result;
}

function resetSounds() {
  audio = document.getElementById('bad-sound');
  if(audio.duration > 0 && !audio.paused) {
      audio.pause();
      audio.currentTime = 0;
  }
  audio = document.getElementById('good-sound');
  if(audio.duration > 0 && !audio.paused) {
      audio.pause();
      audio.currentTime = 0;
  }
}

Number.prototype.padZero = function(padZero, length) {
    var my_string = '' + this;
    return my_string.padZero(length);    
}

String.prototype.padZero = function(length) {
    var my_string = this;
    for (var to_add = length - my_string.length; to_add > 0; to_add -= 1)
      my_string = '0' + my_string;
    return my_string;    
}

String.prototype.endsWith = function(suffix) {
    if (this[this.length - 1] == suffix) return true;
    return false;
}


	function showTecnicMsg(type,msg) {
		$("#tecnicmsg #tecnicmsgHeader").html(type);
		$("#tecnicmsg #tecnicmsgContent").html(msg);
		$("#tecnicmsg").show();
		$(document).on('click',"#tecnicmsg",function() {
			$("#tecnicmsg").hide();
		});
	}
	
	var mainactivity_step = {idle:0, error:1, checkAptId:2, checkActPerf:3, createPerf:4, admission:5};
	
	var mainactivityStep = mainactivity_step.checkAptId;
	
	function mainactivity(step){
  	mainactivityStep = step;
		 switch (mainactivityStep) {
       case mainactivity_step.checkAptId:
					searchApt();
					deactivateReader();
					if ("localStorage" in window && window['localStorage'] == null) {
						showTecnicMsg('Error',"This browser does not support localStorage");
						return false;
					}
					
					var aptId = localStorage.getItem("aptId");
        	if (aptId) {
        		if (localStorage.getItem("aptEntryControl")==0) 
   	        	$('#redeembutton').hide();
   	        else 
   	        	$('#redeembutton').show();
   	        
   	        if (localStorage.getItem("aptExitControl")==0) 
  	        	$('#exitbutton').hide();
   	        else 
   	        	$('#exitbutton').show();
    	        
        		setAccesspointName();
        		$(".accesspointlist-tab").hide();
        		$('.footer').removeClass("hidden");
        		$('#tabs').removeClass("hidden");        		
             if (localStorage.getItem("aptCheckValidPerf") && (localStorage.getItem("aptCheckValidPerf") == 'true'))
               mainactivity(mainactivity_step.checkActPerf);  
             else 
               mainactivity(mainactivity_step.admission);                          
        	} else {
	        	$('.access-point-name').html('No Access Point');
	    			$('.footer').addClass("hidden");
	    			$(".accesspointlist-tab").show();
	    			localStorage.removeItem("aptId");
   	        localStorage.removeItem("aptName");
   	        localStorage.removeItem("aptCode");
   	        localStorage.removeItem("aptLocation");
   	        localStorage.removeItem("eventId");
   	        localStorage.removeItem("eventName");
   	        localStorage.removeItem("performanceId");
        	}
        	break;
			case mainactivity_step.checkActPerf:
				var aptId = localStorage.getItem("aptId");

				var reqDO = {
				   	Command: "GetRunningPerformances",
				   	GetRunningPerformances: {
					   	AccessPointId: aptId,
					   	FillInsidePortfolioList: true
						}
					};
				vgsService("performance", reqDO, false, function(ansDO) {
					//alert(JSON.stringify(ansDO.Answer));
					if (ansDO.Answer) 
            mainactivity(mainactivity_step.createPerf);
          else {
						$.each( ansDO.Answer.GetRunningPerformances.AccessAreaList, function( key2, AccessArea ) {							
							if (AccessArea.PerformanceList.length == 0) 
	              mainactivity(mainactivity_step.createPerf);
	            else {
								var performanceId = AccessArea.PerformanceList[0].PerformanceId;
								localStorage.setItem("performanceId",performanceId);
								localStorage.setItem("eventId",AccessArea.PerformanceList[0].EventId);
								localStorage.setItem("eventName",AccessArea.PerformanceList[0].EventName);
								$('#admission-tab').removeClass("hidden");
	    	        $('#peoplelist-tab').removeClass("hidden");
	    	        $('#eventlist-tab').addClass("hidden");
	    	        $('#admission .infobar').html("Current Event: "+AccessArea.PerformanceList[0].EventName);
	    	        $('#info .infobar').html("Current Event: "+AccessArea.PerformanceList[0].EventName);
	    	        $('#peoplelist .infobar').html("Current Event: "+AccessArea.PerformanceList[0].EventName);
								//$('#accesspointlist-btn').addClass("hidden");
								$('#admission-tab').removeClass("hidden");
                if (AccessArea.PerformanceList[0].TracePortfolioInPerformance) 
                	$('#peoplelist-tab').removeClass("hidden");
								else 
									$('#peoplelist-tab').addClass("hidden");
							    						    
							  if (AccessArea.PerformanceList.length>1) {
									$('#admission .infobar').html("Multiple Events");
									$('#info .infobar').html("Multiple Events");
						      $('#peoplelist .infobar').html("Multiple Events");
								}
							   
								//fillpeople();
								mainactivity(mainactivity_step.admission);
								return false;
							}
	//------------------------------------------------------ end access area loop -------------------------------------------						
						});
					}
				});
        	break;
			case mainactivity_step.createPerf:
						localStorage.removeItem("performanceId");
						$('#admission-tab').addClass("hidden");
					  $('#peoplelist-tab').addClass("hidden");
					  $('#eventlist-tab').removeClass("hidden");
						$('#accesspointlist-btn').removeClass("hidden");
						$("#eventlist-tab").trigger("<%=pageBase.getEventMouseDown()%>");
        	break;
			case mainactivity_step.admission:
						//setAdmissionStep(admission_step.waitingTap, true);
						$("#admission-tab").trigger("<%=pageBase.getEventMouseDown()%>");				
        	break;
		 }
	}
	

	function showMessage(msg) {
	    alert(msg);
	}
	
	var NativeBridge = {
    callbacksCount : 1,
    callbacks : {},
    
    // Automatically called by native layer when a result is available
    resultForCallback : function resultForCallback(callbackId, resultArray) {
      try {
      var callback = NativeBridge.callbacks[callbackId];
      if (!callback) return;
      
      callback.apply(null,resultArray);
      } catch(e) {alert(e)}
    },
    
    // Use this in javascript to request native objective-c code
    // functionName : string (I think the name is explicit :p)
    // args : array of arguments
    // callback : function with n-arguments that is going to be called when the native code returned
    call : function call(functionName, args, callback) {
      
      var hasCallback = callback && typeof callback == "function";
      var callbackId = hasCallback ? NativeBridge.callbacksCount++ : 0;
      
      if (hasCallback)
        NativeBridge.callbacks[callbackId] = callback;
      
      var iframe = document.createElement("IFRAME");
      iframe.setAttribute("src", "js-frame:" + functionName + ":" + callbackId+ ":" + encodeURIComponent(JSON.stringify(args)));
      document.documentElement.appendChild(iframe);
      iframe.parentNode.removeChild(iframe);
      iframe = null;
    }
  };	
</script>





