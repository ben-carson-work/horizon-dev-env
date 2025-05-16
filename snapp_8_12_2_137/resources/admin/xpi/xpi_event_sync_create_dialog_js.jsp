<%@page import="com.vgs.web.library.BLBO_Category"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />
<script>
  
var currentStep = 0;

function validateStep1() {
	var result = false;  
	checkRequired("#xpi-event-sync-create-dialog", function() {
	  result = true;
	});
	return result;
}

function updateWizardDialogButtonsState(step){
  if(step == 0) {
    $(".button-previous").prop("disabled", true).addClass("ui-button-disabled ui-state-disabled");
    $(".button-next").prop("disabled", false);
    $(".button-close").prop("disabled", false);
    $(".button-next").text(<v:itl key="@Common.Next" encode="JS"/>);
  } else if(step == 1){
    $(".button-previous").prop("disabled", false).removeClass("ui-button-disabled ui-state-disabled");
    $(".button-next").prop("disabled", false);
    $(".button-close").prop("disabled", false);
    $(".button-next").text(<v:itl key="@Common.Create" encode="JS"/>);
  }
}

function nextStep() {
  if (currentStep == 0) {
	  if (validateStep1()) {
      $("#wizard").steps("next");
	  }
  } else if (currentStep == 1) 
	    doCreateSyncEvent();
}

function doClose(){
	$("#xpi-event-sync-create-dialog").dialog("close");
}

function prevStep() {
  $("#wizard").steps("previous");
}

  
$(document).ready(function() {
      
  $("#wizard").steps({
    headerTag: "h3",
    bodyTag: "section",
    transitionEffect: "slideLeft",
    autoFocus: true,
    enableCancelButton: false,
    enablePagination: false,
    enableAllSteps: false,
    enableKeyNavigation: false,
    onStepChanged: function(event, currentIndex, priorIndex){
      currentStep = currentIndex;
      updateWizardDialogButtonsState(currentStep);
    }
  });

  var dlg = $("#xpi-event-sync-create-dialog");

  dlg.bind("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": <v:itl key="@Common.Back" encode="JS"/>,
        "class": "button-previous",
        "click": prevStep,
        "disabled": true
      },
      {
        "text": <v:itl key="@Common.Next" encode="JS"/>,
        "class": "button-next",
        "click": nextStep,
        "disabled": false
      },
      {
        "text": <v:itl key="@Common.Cancel" encode="JS"/>,
        "class": "button-close",
        "click": doClose,
        "disabled": false
      }
    ];
  });
  
  $("#eventCrossSell\\.CrossPlatformId").change(doRefreshUI);
  $("#eventCrossSell\\.CrossEventName").change(refreshSnappEventUI);
  
  doRefreshUI();
});

function doRefreshUI() {
  var optionSelected = $("#eventCrossSell\\.CrossPlatformId").find('option:selected');
  var crossPlatformSnApp = <%=LkSNCrossPlatformType.SnApp.getCode()%>;
  var crossPlatformType = optionSelected.attr("data-Type");
  var crossPlatformURL = optionSelected.attr("data-URL");
  var crossPlatformRef = optionSelected.attr("data-Ref");
  
  $("#eventCrossSell\\.CrossEventCode").val("");
  $("#eventCrossSell\\.CrossEventName").val("");
  
  if (crossPlatformSnApp == crossPlatformType) {
    showWaitGlass();
    var reqDO = {
        Command: "GetSharedEvents",
        GetSharedEvents: {
          CrossPlatformURL: crossPlatformURL,
          CrossPlatformRef: crossPlatformRef
        }
      };
      
    vgsService("Event", reqDO, false, function(ansDO) {
      hideWaitGlass();
      if (ansDO.Answer && (ansDO.Answer.GetSharedEvents.SharedEventList.length > 0))
        populateEventSelection(ansDO);
      else 
        showMessage(<v:itl key="@XPI.CrossEventListEmpty" encode="JS"/>);
    });
  }
}

function refreshSnappEventUI() {
  var optionSelected = $("#eventCrossSell\\.CrossEventName").find('option:selected');
  $("#eventCrossSell\\.CrossEventCode").val(optionSelected.attr("data-Ref"));
}

function populateEventSelection(ansDO) {
	var select = $("#eventCrossSell\\.CrossEventName");
	$(select).empty();
	for (i=0; i<ansDO.Answer.GetSharedEvents.SharedEventList.length; i++) {
	  if (i > 0)
	    selected = "";
	  var item = ansDO.Answer.GetSharedEvents.SharedEventList[i];
	  select.append("<option value='" + item.EntityId + "' data-Ref='" + item.EntityCode + "'>" + item.EntityName + "</option>")
	}
	refreshSnappEventUI();
}

function doCreateSyncEvent() {
	  var optionSelected = $("#eventCrossSell\\.CrossPlatformId").find('option:selected');
	  var crossPlatformSnApp = <%=LkSNCrossPlatformType.SnApp.getCode()%>;
	  var crossPlatformType = optionSelected.attr("data-Type");
	  var crossPlatformURL = optionSelected.attr("data-URL");
	  var crossPlatformRef = optionSelected.attr("data-Ref");
	  var eventId = $("#eventCrossSell\\.CrossEventName").val();
	  
	  var categoryId = $("#CategoryId").val();
		if ((categoryId == "") || (categoryId == "all"))
			categoryId = <%=JvString.jsString(pageBase.getBL(BLBO_Category.class).getRootCategoryId(LkSNEntityType.Event))%>;
			
		var productCategoryId = $("#product\\.CategoryId").val();
		if (productCategoryId == "")
			productCategoryId = <%=JvString.jsString(pageBase.getBL(BLBO_Category.class).getRootCategoryId(LkSNEntityType.ProductType))%>;
	  
	  if (crossPlatformSnApp == crossPlatformType) {
		  checkRequired("#xpi-event_sync-create-dialog", function() {
			  showWaitGlass();
			  var reqDO = {
		       Command: "CreateSyncXPIEvent",
		       CreateSyncXPIEvent: {
		    	   CrossPlatformId: $("#eventCrossSell\\.CrossPlatformId").val(),
		    	   CrossPlatformURL: crossPlatformURL,
		         CrossPlatformRef: crossPlatformRef,
		         Event: {
		        	 EventId: eventId,
		 	         CategoryId: categoryId
			       },
			       Product: {
		        	 Status: $("#product\\.ProductStatus").val(),
		 	         CategoryId: productCategoryId,
		 	         TagIDs: $('#product\\.TagIDs').selectize()[0].selectize.getValue(),
		 	         SaleChannelIDs: $('#product\\.SaleChannelIDs').selectize()[0].selectize.getValue(),
		 	         PerformanceTypeIDs: $('#product\\.PerfTypeIDs').selectize()[0].selectize.getValue(),
		 	         POS_AllowPrint: $("[name='product\\.POS_AllowPrint']").isChecked(),
		 	         POS_DocTemplateIDs: $("#product\\.POS_DocTemplateIDs").val(),
		 	         B2B_AllowPrint: $("[name='product\\.B2B_AllowPrint']").isChecked(),
		 	         B2B_DocTemplateId: $("#product\\.B2B_DocTemplateId").val(),
		 	         CLC_AllowPrint: $("[name='product\\.CLC_AllowPrint']").isChecked(),
		 	         CLC_DocTemplateId: $("#product\\.CLC_DocTemplateId").val(),
		 	         B2C_AllowPrint: $("[name='product\\.B2C_AllowPrint']").isChecked(),
		 	         B2C_DocTemplateId: $("#product\\.B2C_DocTemplateId").val(),
		 	         MOB_AllowPrint: $("[name='product\\.MOB_AllowPrint']").isChecked(),
		 	         MOB_DocTemplateId: $("#product\\.MOB_DocTemplateId").val()
			       }
		       }
		    };
			  
				vgsService("Event", reqDO, false, function(ansDO) {
				  hideWaitGlass();
				  doClose();
				  window.location = "<v:config key="site_url"/>/admin?page=event&id=" + eventId;
				});
		  });
	  }
	}

</script>