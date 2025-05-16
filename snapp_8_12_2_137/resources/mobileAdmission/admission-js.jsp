<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission"
  scope="request" />

<script type="text/javascript">

var adm_waitingForRFID = false;
var adm_TDVNumber = -1;
var readerTimer = null;
var admission_step = {idle:0, error:1, waitingTap:2, sendRequest:3, showResult:4, showDetails:5};
var admissionStep = admission_step.idle;
var lastAdmissionCard = null;
var pictureId = null;
var accountId = null;

function setAdmissionStep(step, updateMsg) {
	if (admissionStep != step) {
	    if (readerTimer != null)
	        clearTimeout(readerTimer);
	    admissionStep = step;
	    //alert(admissionStep);
	    /*$("#admission .back-btn").addClass("enabled");
	    $("#admission .back-btn").removeClass("hidden"); 
	    $("#admission .fp-text").addClass("hidden");*/
	    switch (admissionStep) {
	        case admission_step.idle:
	            //alert("idle");
	            if (updateMsg)
	                $("#msg-display").html("Inactive");
	            //sendCommand("StopRFID");
	            adm_waitingForRFID = false;
	            $("#admission .fp-text").html("<span style='color: #999999; font-weight:bold;'>ADMISSION</span><br>Touch to start");
	            $("#admission .fp-text").removeClass("hidden");
	            $("#admission .back-btn").removeClass("enabled");
	            $("#admission .back-btn").addClass("hidden");
	            $("#admission .fp-result-bk").css("display", "none");
	            resetResult();
	            
	            stopReading();
	            break;
	        case admission_step.waitingTap:
	            var eventId = localStorage.getItem("eventId");
                var performanceId = localStorage.getItem("performanceId");
        		if ( (performanceId) ) {
          			setAdmissionStep(admission_step.waitingTap, true);
          			  $('#eventlist-tab').addClass("hidden");	
          		} else {
          		}
	            resetResult();
	            lastAdmissionCard = null;
	            $("#admission .ticketInfo").css("display", "none");
	            $("#admission .fp-result-bk").css("display", "block");
	            
	            startReading();
	            break;
	        case admission_step.sendRequest:
	            //	    	alert("sendrequest");
	            //$("#admission .back-btn").removeClass("enabled");
	            resetResult();
	            //sendValidateRequest(lastAdmissionCard.SecureId, adm_TDVNumber);
	            break;
	        case admission_step.showResult:
	            activateReader();
	            if ($("#admission .ticketInfo").css("display") != "none") {
	                $("#admission .ticketInfo").hide("slide", 500, function() {
	                    $("#admission .fp-result-bk").show("slide", 500);
	                });
	            }
	            break;
	        case admission_step.showDetails:
	            deactivateReader();
	            if ($("#admission .fp-result-bk").css("display") != "none") {
	                $("#admission .fp-result-bk").hide("slide", 500, function() {
	                    $("#admission .ticketInfo").show("slide", 500);
	                });
	            }
	            break;
	    }
	}    
}
 
$(document).on("<%=pageBase.getEventMouseDown()%>", ".tab:not(#admission-tab)", function() {
	setAdmissionStep(admission_step.idle);
});

function openPicturePage() {
    pictureId = (pictureId) ? pictureId : "";
    accountId = (accountId) ? accountId : "";
    window.open ("<v:config key="site_url"/>/admin?page=mobile_aptpicture&id="+ pictureId + "&accountId=" + accountId,'_self',false);
//    $.mobile.changePage(
//            "<v:config key="site_url"/>/admin?page=mobile_aptpicture&id="+ pictureId + "&accountId=" + accountId, {
//              transition : "slideup"
//            });
    }

function admGoBack() {
  switch (admissionStep) {
    case admission_step.waitingTap: 
    	setAdmissionStep(admission_step.idle, true);
      break;            
    case admission_step.showResult: 
    	setAdmissionStep(admission_step.waitingTap, true);
      break;            
    case admission_step.showDetails: 
    	setAdmissionStep(admission_step.showResult, true);
      break;            
    case admission_step.waitConfirm: 
    	setAdmissionStep(admission_step.tapCard, true);
      break;            
    case admission_step.error: 
    	setAdmissionStep(admission_step.waitingTap, true);
      break;            
  }    
}

$( document ).on( "<%=pageBase.getEventClick()%>", ".admission.button", function() {
	  $('.admission.button').removeClass('checked');
	  $( this ).addClass('checked');
	  /*if ($( this ).attr('id')=='exitbutton') {
		  $('#querybutton').addClass('disabled');
	  } else {
		  $('#querybutton').removeClass('disabled');
	  }*/
	  //$('.admissionmode').html($( this ).html());
  });
  /*
$( document ).on( "<%=pageBase.getEventClick()%>", "#querybutton", function() {
	if ($( this ).hasClass('img-query')) {
		$( this ).removeClass('img-query');
		$( this ).addClass('img-redeem');
	} else {
		$( this ).removeClass('img-redeem');
		$( this ).addClass('img-query');
	}
	  //$('.admissionmode').html($( this ).html());
});
*/

$(document).on("<%=pageBase.getEventMouseDown()%>","#admission-tab", function() {
  // sendCommand("StopRFID");
  // sendCommand("StopCreditCard");
  
  var eventId = localStorage.getItem("eventId");
  //var eventName = localStorage.getItem("eventName");
  var performanceId = localStorage.getItem("performanceId");
  var aptCheckValidPerf = localStorage.getItem("aptCheckValidPerf");
 
  if ((aptCheckValidPerf == 'false') || (performanceId) ) {
  	setAdmissionStep(admission_step.waitingTap, true);
   	$('#eventlist-tab').addClass("hidden");	
  } else {
  }
});

$("#admission .adm-test-btn").bind("<%=pageBase.getEventClick()%>", function() { 
  if ((admissionStep == admission_step.waitingTap) || (admissionStep == admission_step.showResult)) {	  
		lastAdmissionCard = {
	          SecureId: "1009501863587518",
	          VisualId: "221145073112"         
	       };
	  
	  setAdmissionStep(admission_step.sendRequest, true);
  }
});

$("#admission .fp-result-bk").bind("<%=pageBase.getEventClick()%>", function() { 
  if (admissionStep == admission_step.showResult)
    setAdmissionStep(admission_step.showDetails, true);
});

//activate rfid to read data - start

function startReading() {
    activateReader();  
    $("#msg-display").html("Tap a card..."); 
}

function stopReading() {
    deactivateReader();  
}
function activateReader() {
	if (!adm_waitingForRFID) {
	  adm_waitingForRFID = true;
	  sendCommand("StartRFID");
	}
	$("#MediaCode").focus();
  if (readerTimer != null)
    clearTimeout(readerTimer);
  readerTimer = setTimeout(function() {
    //setAdmissionStep(admission_step.idle, true);
  }, MAX_READ_TIME);
}

function deactivateReader() {
   if (readerTimer != null)
       clearTimeout(readerTimer);
  if (adm_waitingForRFID) {
      sendCommand("StopRFID");
    adm_waitingForRFID = false;
  }	  
  sendCommand("StopRFID");
}

//activate rfid to read data - end

function resetResult(){
 /* $("#admission .fp-result-bk").removeClass("fp-result-good");
  $("#admission .fp-result-bk").removeClass("fp-result-bad");          
  $("#adm-statusbar").removeClass("display-good");
  $("#adm-statusbar").removeClass("display-bad");
  */
  $('#results').addClass('hidden');
 // $("#MediaCode").focus();
 /*
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
  */
}


$("#admission .back-btn").bind("<%=pageBase.getEventClick()%>", function() { 
  if ($(this).hasClass("enabled"))
    admGoBack();       
});

$("#admission .fp-text").bind("<%=pageBase.getEventClick()%>", function() { 
  if ($(this).hasClass("enabled"))
      setAdmissionStep(admission_step.waitingTap, true);
});

$("#admission .statusbar").bind("<%=pageBase.getEventClick()%>", function() { 
  if (admissionStep == admission_step.showResult)
    setAdmissionStep(admission_step.showDetails, true);
  else if (admissionStep == admission_step.showDetails)
    setAdmissionStep(admission_step.showResult, true);
});
	 
$(document).bind("VGS_RFIDRead", function(event, rfid) {
  if (adm_waitingForRFID) {
    lastAdmissionCard = rfid;
    adm_waitingForRFID = false;
    setAdmissionStep(admission_step.sendRequest, true);
  }
});

var readerBuffer = '';
var lastKeyPressTime = new Date(); 

$(document).on("keypress", function(e) {
	if ((e.target.id != "MediaCode")) {
	  var now = new Date();
	  if ((now.getTime() - lastKeyPressTime.getTime()) > 100) 
      readerBuffer = String.fromCharCode(e.which);
    else {
	    if (e.which == 13) { // enter 
	      if (readerBuffer != '') {   
          validate(readerBuffer);
	        readerBuffer = '';
	      }
	    } 
	    else 
	      readerBuffer += String.fromCharCode(e.which);     
	  } 
	  lastKeyPressTime = now; 		
	}
});

/*
function sendValidateRequest(secureId, tdvNumber) {
  $("#admission .fp-spinner").removeClass("hidden");          
  $("#msg-display").html("Validating...");
  reqDO = {
        AptCode: tdvNumber,
        SecureId: secureId
      };    
      
  CallService("Validate", reqDO, function(ans, errorMsg) {
      $("#admission .fp-spinner").addClass("hidden");          
      if (errorMsg != null)
        $("#msg-display").text(errorMsg);
      else {
        processValidateResult(ans.Answer);
        setAdmissionStep(admission_step.showResult, true);
      }    
    }); 
}
*/
function processValidateResult(answer) {
  if (answer.Decremented == "true") {
	  $("#admission .fp-result-bk").removeClass("fp-result-bad");
	  $("#admission .fp-result-bk").addClass("fp-result-good");                   
	  $("#adm-statusbar").removeClass("display-bad");
	  $("#adm-statusbar").addClass("display-good");
	  document.getElementById('good-sound').play();
  }
  else {
	  $("#admission .fp-result-bk").addClass("fp-result-bad");
	  $("#admission .fp-result-bk").removeClass("fp-result-good"); 
	  $("#adm-statusbar").addClass("display-bad");
	  $("#adm-statusbar").removeClass("display-good"); 		  
    document.getElementById('bad-sound').play();
  } 
  
  var str = answer.OperatorMessage;
  if (answer.EntitlementDescription != null)
    str += "<br/>" + answer.EntitlementDescription;
  str = "<span class='validateResult'>" + str + "</span>"; 
      
  $("#msg-display").html(str);
  
  $("#ticketInfo .usage").remove();
  
  if (answer.EntitlementText != null)
	    $("<div class='usage' style='background-image:url(\"<v:image-link name="note.png" size="32"/>\")'>" + answer.EntitlementText + "</div>").appendTo("#ticketInfo");
  if (answer.ValidityStart != null)
	    $("<div class='usage' style='background-image:url(\"<v:image-link name="calendar.png" size="32"/>\")'> Valid from <b>" + answer.ValidityStart + "</b> to <b>"  + answer.ValidityEnd + "</b></div>").appendTo("#ticketInfo");
    
  if ((answer.Usages != null) && (answer.Usages.length > 0)) {
     for (var i=0; i<answer.Usages.length; i++) 
       $("<div class='usage' style='background-image:url(\"" + getUsageIcon(answer.Usages[i].UsageType) + "\")'>" + answer.Usages[i].Gate + " - " + answer.Usages[i].DateTime + "</div>").appendTo("#ticketInfo");
  } 
  else
    $("<div class='usage'>No info</div>").appendTo("#ticketInfo");  
}
	//-------------------------------------------------modifica---------------------------
function validate(mediaCode) {
    pictureId = null;
    accountId = null;

		$("#operator-msg .text").html("");
			hideResults();
//			setVisible("#search-bar", false);

			if (localStorage.getItem("aptId") == null) {
				setAdmissionStep(admission_step.Error, true);
				$("#operator-msg .thumb").css("background-image", "url('<v:image-link name="[font-awesome]times|CircleRed" size="100"/>')");
				$("#operator-msg .text").html("Please select an access point first");
				
				$('#results').removeClass('hidden');
				$("#operator-msg").removeClass("hidden");
				
				$("#MediaCode").val("");
       // $("#MediaCode").focus();
      //$("#accesspointlist-tab").trigger("<%=pageBase.getEventMouseDown()%>");
			//setVisible("#operator-msg", true);
		} else {
			//$.mobile.showPageLoadingMsg();
			reqDO = {
				MediaCode : mediaCode,
				MediaCodeType : 0,
				SkipBiometricCheck: true,
				RedemptionPoint : {
					AccessPointId : localStorage.getItem("aptId"),
					UsageType : (getUseTicket()==2) ? 2 : 1,
					OperatorCmd : (getUseTicket()==2) ? 1 : getUseTicket()
				}
			};
			//alertjson(reqDO);
			$('#floatingBarsG').show();
			setAdmissionStep(admission_step.sendRequest, true);
			//alert(JSON.stringify(reqDO));
			vgsService('Validate',reqDO,false,function(ansDO) {
						//alert(JSON.stringify(ansDO));
						$('#floatingBarsG').hide();
						if (ansDO.Answer.Ticket == null) 
				      $('#ticket-info').hide();
						else {
							$('#ticket-info').show();
							$("#ticket-info .product-code").html(ansDO.Answer.Ticket.ProductCode);
							$("#ticket-info .product-name").html(ansDO.Answer.Ticket.ProductName);
						} 

						if ((ansDO.Answer.Match != null) && (ansDO.Answer.Match.AccountId != null)) {
							$("#yes-account").show();
							$("#no-account").hide();
							$("#account-info .account-name").html(ansDO.Answer.Match.AccountDisplayName);
							//$("#account-info .account-code").html(ansDO.Answer.Match.AccountCode);
              accountId = ansDO.Answer.Match.AccountId;
							if (ansDO.Answer.Match.ProfilePictureId == null) {
								$("#account-info .thumb").css("background-image",	"url(<v:image-link name='account_prs.png' size='100'/>)");
							} else {
								$("#account-info .thumb").css("background-image",	"url(<v:config key='site_url'/>/repository?id="	+ ansDO.Answer.Match.ProfilePictureId	+ "&type=small)");
							    pictureId = ansDO.Answer.Match.ProfilePictureId;
							}
						} else {
							$("#yes-account").hide();
							$("#account-info .thumb").css("background-image", "url(<v:image-link name='account_prs.png' size='100'/>)");
							$("#no-account").show();
						}
						if (ansDO.Answer.ResultCode == 102) {
							$("#yes-account").hide();
							$("#no-account").hide();
						} else {
							$("#result").removeClass("hidden");
						}
						if (ansDO.Answer.ResultCode < 100) {
							//playGoodSound();
							$("#operator-msg .thumb").css("background-image",	"url('<v:image-link name="[font-awesome]check|CircleGreen" size="100"/>')");
							$("#operator-msg .text").html(ansDO.Answer.OperatorMsg);
						} else {
							//playBadSound();
							$("#operator-msg .thumb").css("background-image",	"url('<v:image-link name="[font-awesome]times|CircleRed" size="100"/>')");
							$("#operator-msg .text").html(ansDO.Answer.OperatorMsg);
						}

						$("#operator-msg").removeClass("hidden");
						$('#results').removeClass("hidden");
						//$('#results').removeClass(getUseTicket());
						//$('#results').addClass(getUseTicket());
						$("#MediaCode").val("");
						//$("#MediaCode").focus();
						setAdmissionStep(admission_step.showResult, true);
					});

		}
	}

	$(document).on("click", "#barcode-btn", function() {
		sendCommand("StartBarcodeCamera");
	});

	function onCodeRead(barcode) {
		validate(barcode);
	}

	function getUseTicket() {
		//alert($("input[name='radio-scan-type']:checked").val());
		//alert($('.actionbar').find('div.checked').attr('data'));
		return $('.actionbar').find('div.checked').attr('data-usagetype');
	}
	function hideResults() {
		$('#results').addClass('hidden');
		$("#operator-msg").addClass('hidden');
		$("#result").addClass('hidden');
		pictureId = null;
	}
	$("#MediaCode").on("keypress", function(e) {

		if (e.keyCode == '13') {
			$("#MediaCode").blur();
			validate($("#MediaCode").val());
		}
	});
</script>
