<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%@page import="com.vgs.web.library.bean.*"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String[] transactionSurveyIDs = pageBase.getBL(BLBO_Survey.class).getShopCartSurvey(LkSNTransactionType.AdjustAdmissionsCount).tranSurveyIDs;
String[] maskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(transactionSurveyIDs);
boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
int maxDaysInThePast = rights.MaxAdjustAdmissionsDays.getInt();
%>

<jsp:include page="adjust_admissions_count_dialog_css.jsp"/>

<v:dialog id="adjust_admissions_count_dialog" title="@Right.AdjustAdmissionsCount" width="800" height="600" autofocus="false">
  <div class="wizard">
    <div class="wizard-step wizard-step-performance">
      <div class="wizard-step-title"><v:itl key="@Performance.Performance"/></div>
      <div class="wizard-step-content">
        <v:widget>
          <v:widget-block>
            <v:form-field caption="@Event.Event">
              <snp:dyncombo id="AdjustEventId" entityType="<%=LkSNEntityType.Event%>" auditLocationFilter="true" allowNull="false"/>
            </v:form-field>
            <div class="filter-divider"></div>

            <v:form-field caption="@Common.DateTime" hint="@AccessPoint.AdjustAdmissionDateTimeHint">
              <v:input-text type="datetimepicker" field="AdjustAdmissionDateTime" style="width:120px"/>
            </v:form-field>
            <div class="filter-divider"></div>
          </v:widget-block>
        </v:widget>
        <v:widget id="PerfContainer">
          <v:widget-block>
            <div id="perf-container">
              <div class="item-container"></div>
            </div>
            <div class="v-hidden"> 
              <div id="folder-template">
                <div class="catalog-item">
                  <div class="item-indent">
                    <img class="item-img"/>
                    <div class="item-caption v-tooltip-overflow"></div>
                  </div>
                </div>
              </div>
            </div>
          </v:widget-block>
        </v:widget>
      </div>
    </div>
  
    <div class="wizard-step wizard-step-admission">
      <div class="wizard-step-title"><v:itl key="@Performance.Admission"/></div>
      <div class="wizard-step-content">
        <v:widget>
          <v:widget-block>
            <v:form-field caption="@Lookup.EntityType.Location">
              <snp:dyncombo id="AdjustLocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true" allowNull="false"/>
            </v:form-field>
            <div class="filter-divider"></div>
          
            <v:form-field caption="@Lookup.EntityType.OperatingArea">
              <snp:dyncombo id="AdjustOpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" auditLocationFilter="true" allowNull="false" parentComboId="AdjustLocationId"/>
            </v:form-field>  
            <div class="filter-divider"></div>
            
            <v:form-field caption="@Lookup.EntityType.AccessPoint">
              <snp:dyncombo id="AdjustAccessPointId" entityType="<%=LkSNEntityType.AccessPoint%>" auditLocationFilter="true" allowNull="false" parentComboId="AdjustOpAreaId"/>
            </v:form-field>   
            <div class="filter-divider"></div>
          </v:widget-block>
            
          <v:widget-block>
            <v:form-field caption="@Common.Quantity" hint="@AccessPoint.AdjustAdmissionQuantityHint">
              <input type="text" id="AdjustAdmissionQuantity" class="txt-search form-control"/>
            </v:form-field>
            <div class="filter-divider"></div>
            
            <v:form-field caption="@Ticket.UsageType">
              <v:lk-combobox field="AdjustUsageType" lookup="<%=LkSN.TicketUsageType%>" allowNull="false"/>
            </v:form-field>
            <div class="filter-divider"></div>
          </v:widget-block>
        </v:widget>
      </div>
    </div>

    <div class="wizard-step wizard-step-survey">
      <div class="wizard-step-title"><v:itl key="@Media.StatusWizard_Survey"/></div>
      <div class="wizard-step-content"></div>
    </div>
    
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Media.StatusWizard_Notes"/></div>
      <div class="wizard-step-content">
        <v:input-txtarea field="Note" rows="16"/>
        <% if (canCreateNoteType) { %>
          <v:widget>
            <v:widget-block>
              <v:db-checkbox field="NoteHighlighted" value="true" caption="@Common.Highlighted"/>
            </v:widget-block>
          </v:widget>
        <% } %>
      </div>
    </div>
  </div>  

<script>

$(document).ready(function() {
  var $dlg = $("#adjust_admissions_count_dialog");
  $dlg.find("#PerfContainer").setClass("hidden", true);
  var $wizard = $dlg.find(".wizard");
  var $stepSurvey = $wizard.find(".wizard-step-survey");
  var $stepAdmission = $wizard.find(".wizard-step-admission");
  var $stepPerformance = $wizard.find(".wizard-step-performance");
  var $adjustEventId = $dlg.find("#AdjustEventId");
  var $adjustLocationId = $dlg.find("#AdjustLocationId");
  var $adjustAccessPointId = $dlg.find("#AdjustAccessPointId");
  var $adjustAdmissionQuantity = $dlg.find("#AdjustAdmissionQuantity");
  var selectedEventId = "";
  var foundPerfCount = 0;
  var today = new Date();
  var selectedPerfDate = today;
  var selectedPerfId = "";
  var selectedPerfAccessAreaId = "";
  var maskIDs = <%=JvString.jsString(JvArray.arrayToString(maskIDs, ","))%>;
  var metaDataList = [];
  
  var $adjustAdmissionDateTime = $dlg.find("#AdjustAdmissionDateTime-picker").datepicker("setDate", today);
  $dlg.find("#AdjustAdmissionDateTime-HH").val(leadZero(today.getHours(), 2));
  $dlg.find("#AdjustAdmissionDateTime-MM").val(leadZero(today.getMinutes(), 2));
  var admissionDateTime = $("#AdjustAdmissionDateTime-picker").getXMLDateTime();
  var lastAdmissionDateTime = admissionDateTime;

  $dlg.on("snapp-dialog", function(event, params) {
    params.open = _enableDisable;
    params.buttons = [
      {
        id: "btn-back",
        text: itl("@Common.Back"),
        click: _previousStep
      },

      {
        id: "btn-continue",
        text: itl("@Common.Continue"),
        click: _nextStep
      },
      {
        id: "btn-confirm",
        text: itl("@Common.Confirm"),
        click: _confirm
      },
      {
        text: itl("@Common.Close"),
        click: doCloseDialog
      }
    ]; 
  });
  
  if (maskIDs == "")
    $stepSurvey.remove();
  else {
    window.metaFields = {};
    asyncLoad($stepSurvey.find(".wizard-step-content"), addTrailingSlash(BASE_URL) + "admin?page=maskedit_widget&MaskIDs=" + maskIDs);
  }
  
  $wizard.vWizard({
    onStepChanged: _enableDisable
  });
  
  $adjustAdmissionQuantity.keypress(function(e) {
    var keyCode = e.which ? e.which : e.keyCode;
    if (!(keyCode >= KEY_0 && keyCode <= KEY_9) && (keyCode != KEY_MINUS))
      event.preventDefault();
  })
  
  function _enableDisable() {
    var last = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 1);
    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    var lastStep = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") -1);
    var firstStep = ($wizard.vWizard("activeIndex") == 0);
    
    $buttonPane.find("#btn-confirm").setClass("hidden", !last);
    $buttonPane.find("#btn-continue").setClass("hidden", last);
    $buttonPane.find("#btn-back").setClass("hidden", firstStep);
  }
  
  function _previousStep() {
    $wizard.vWizard("prior");
  }
  
  function _nextStep() {
    if ($stepSurvey.is(".active")) {
      _validateMetaData(function() {
        $wizard.vWizard("next");
      });
    }
    else if ($stepPerformance.is(".active")) {
      if (selectedEventId == "") 
        showMessage("<%=pageBase.getLang().AccessPoint.SelectEventError.getText()%>");
      else if (selectedPerfId == "") 
        showMessage("<%=pageBase.getLang().AccessPoint.SelectPerformanceError.getText()%>");
      else if ((!selectedPerfAccessAreaId) || (selectedPerfAccessAreaId == "")) 
        showMessage("<%=pageBase.getLang().AccessPoint.SelectAccessAreaError.getText()%>");
      else
        $wizard.vWizard("next");
    } 
    else if ($stepAdmission.is(".active")) {
      if ($adjustAccessPointId.val() == "")
        showMessage("<%=pageBase.getLang().AccessPoint.SelectAccessPointError.getText()%>");
      else if (($adjustAdmissionQuantity.val() == "") || isNaN($adjustAdmissionQuantity.val()))
        showMessage("<%=pageBase.getLang().AccessPoint.InvalidAdmissionQantity.getText()%>");
    	  
      else
        $wizard.vWizard("next");
    }
    else
      $wizard.vWizard("next");
  }
  
  function _prepareAdjustAdmissionsCountCommand() {
    var noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
    var reqDO = {
      AptLocationId: $adjustLocationId.val(), 		
      UsageLocalDateTime: admissionDateTime,
      AccessPointId: $adjustAccessPointId.val(),
      AdmissionPerformance : {
        PerformanceId: selectedPerfId
      },
      AdmissionQuantity: parseInt($adjustAdmissionQuantity.val()),
      UsageType: $dlg.find("#AdjustUsageType").val(),
      Note: $dlg.find("#Note").val(),
      NoteType: noteType,
      TransactionSurveyMetaDataList: metaDataList,
      TransactionMaskList: []
    };
        
    if (maskIDs.length > 0) {
      $(maskIDs.split(",")).each(function(index, elem) {
        reqDO.TransactionMaskList.push({"MaskId":elem});
      });
    }
    
    return reqDO;
  }
  
  function _confirm() {
    confirmDialog(itl("@AccessPoint.AdjustAdmissionsCountWarning"), function() {
      var reqDO = {
        Command: "AdjustAdmissionsCount",
        AdjustAdmissionsCount: _prepareAdjustAdmissionsCountCommand()
      };
    
      showWaitGlass();
      vgsService("Admission", reqDO, false, function(ansDO) {
        hideWaitGlass();
        window.location.reload();
      });
    });
  }
   
  function _validateMetaData(callback) {
    metaDataList = prepareMetaDataArray($stepSurvey);
    checkRequired($stepSurvey, function() {
      var reqDO = {
        Command: "ValidateMetaData",
        ValidateMetaData: {
          EntityType: <%=LkSNEntityType.Transaction.getCode()%>,
          MetaDataList: metaDataList
        }
      };
      
      showWaitGlass();
      vgsService("MetaData", reqDO, false, function(ansDO) {
        hideWaitGlass();
        callback();
      });
    });
  }

  $adjustEventId.change(function() {
    _doSearchPerformances();
  });
  
  function _adjustDateTimeChanged() {
    var oldestDate = xmlToDate("<%=JvDateTime.now().addDays(-maxDaysInThePast)%>");
    var selectedDate = xmlToDate($adjustAdmissionDateTime.getXMLDateTime());
    var lastSelectedDate = xmlToDate(selectedPerfDate);
    var nowDateTime = new Date();
    
    if ((<%=maxDaysInThePast != 0%>) && (selectedDate.getTime() < oldestDate.getTime())) {
      var msg = "<%=pageBase.getLang().AccessPoint.AdmissionDateInPastError.getText()%>" + formatDate(oldestDate, <%=pageBase.getRights().ShortDateFormat.getInt()%>);
      showMessage(msg);
      $dlg.find("#AdjustAdmissionDateTime-picker").datepicker("setDate", lastSelectedDate);
    } 
    else if (selectedDate.getTime() > nowDateTime.getTime()) {
      showMessage("<%=pageBase.getLang().AccessPoint.AdmissionDateInFutureError.getText()%>");
      $dlg.find("#AdjustAdmissionDateTime-picker").datepicker("setDate", lastSelectedDate);
      $dlg.find("#AdjustAdmissionDateTime-HH").val(leadZero(nowDateTime.getHours(), 2));
      $dlg.find("#AdjustAdmissionDateTime-MM").val(leadZero(nowDateTime.getMinutes(), 2));
    }
    else {
      admissionDateTime = $("#AdjustAdmissionDateTime-picker").getXMLDateTime();
      _doSearchPerformances();
    }
  }
  
  $("#AdjustAdmissionDateTime-picker").change(_adjustDateTimeChanged);
  $("#AdjustAdmissionDateTime-HH").change(_adjustDateTimeChanged);
  $("#AdjustAdmissionDateTime-MM").change(_adjustDateTimeChanged);

  function _initPerfVariables() {
    foundPerfCount = 0;
    selectedPerfId = "";
    selectedPerfAccessAreaId = "";
  }
  
  function _doSearchPerformances() {
	if ($adjustEventId) {  
	  $dlg.find("#PerfContainer").setClass("hidden", false);	
	  var perfPage = 1;
	  var perfRecPerPage = 50;
	  var eventId = $adjustEventId.val();
	  var perfDate = $adjustAdmissionDateTime.getXMLDate();
	  
	  if ((eventId) && ((selectedEventId != eventId) || (lastAdmissionDateTime != admissionDateTime))) {
		_initPerfVariables();  
	    $("#perf-container .item-container").empty();
	    selectedEventId = eventId;
	    selectedPerfDate = perfDate;
	    lastAdmissionDateTime = admissionDateTime;
	    
	    _renderPerfSearching();
	    
	    var reqDO = {
	      Command: "Search",
	      Search: {
	        EventId: eventId,
	        PerformingFromDateTime: admissionDateTime,
	        PerformingToDateTime: admissionDateTime,
	        PagePos: perfPage,
	        RecordPerPage: perfRecPerPage
	      }
	    };
	    
	    vgsService("Performance", reqDO, false, function(ansDO) {
	      $dlg.find("#perf-container .item-container .perf-searching").remove();
	      if ((ansDO.Answer) && (ansDO.Answer.Search) && (ansDO.Answer.Search.PerformanceList)) {
	        perfTotalRecCount = ansDO.Answer.Search.TotalRecordCount;
	        if (perfTotalRecCount > 0) {
	      	  _renderPerfDate(perfDate);  
	          var list = ansDO.Answer.Search.PerformanceList;
	          foundPerfCount = list.length;
	          for (var i=0; i<list.length; i++) {
	            _renderPerformance(list[i], list.length == 1);
	          }
	        }
	      }
          if (foundPerfCount == 0) 
            _renderNoElemFound(<v:itl key="@Performance.NoPerformances" encode="JS"/>);
	    });
	  }
	}
  }

  function _renderPerformance(perf, onlyOnePerfFound) {
    var date = xmlToDate(perf.DateTimeFrom);
    var desc = formatTime(date, <%=pageBase.getRights().ShortTimeFormat.getInt()%>);
    if (perf.PerformanceDesc)
      desc += " - " + perf.PerformanceDesc;
    var elem = _renderNode("#perf-container .item-container", "perf-item", "[font-awesome]clock", desc, _perfClick, 0);
    elem.attr("data-PerformanceId", perf.PerformanceId);
    elem.attr("data-AccessAreaId", perf.AccessAreaId);
    if (onlyOnePerfFound) {
      elem.addClass("selected");
      selectedPerfId = $("#perf-container .catalog-item.selected").attr("data-PerformanceId");
      selectedPerfAccessAreaId = $("#perf-container .catalog-item.selected").attr("data-AccessAreaId");
    }
  }
  
  function _perfClick() {
	$("#perf-container .catalog-item").removeClass("selected");
    $(this).addClass("selected");
    selectedPerfId = $("#perf-container .catalog-item.selected").attr("data-PerformanceId");
    selectedPerfAccessAreaId = $("#perf-container .catalog-item.selected").attr("data-AccessAreaId");
  }
  
  function _renderNode(container, clazz, iconName, caption, onclick, level) {
    var img = addTrailingSlash(BASE_URL) + "imagecache?size=32&name=" + encodeURIComponent(iconName);
    var elem = $($("#folder-template").html()).appendTo(container);
    elem.addClass(clazz);
    elem.addClass("noselect");
    elem.find(".item-img").attr("src", img);
    elem.find(".item-indent").css("left", (level*32) + "px");
    	
    var divCaption = elem.find(".item-caption");
    divCaption.text(caption);
    	
    elem.click(onclick);
    	
    return elem;
  }
	  
  function _renderPerfDate(date) {
    var div = $("<div class='perf-date'/>").appendTo("#perf-container .item-container");
    div.text(formatDate(date, <%=pageBase.getRights().LongDateFormat.getInt()%>));
  }
	  
  function _renderPerfSearching() {
    $("<div class='perf-searching waiting'/>").appendTo("#perf-container .item-container");
  }
	  
  function _renderNoElemFound(text) {
    var div = $("<div class='no-elem-found'/>").appendTo("#perf-container .item-container");
    div.text((text) ? text : <v:itl key="@Common.NoItems" encode="JS"/>);
  }
});

</script>

</v:dialog>


