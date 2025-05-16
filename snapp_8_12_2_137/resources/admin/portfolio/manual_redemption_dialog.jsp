<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.library.bean.*"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String mediaCode = pageBase.getEmptyParameter("mediaCode"); 
String ticketId = pageBase.getEmptyParameter("ticketId");

//String defaultRedemptionDateTime = pageBase.convertFromServerToBrowserTimeZone(pageBase.getDB().getDBTimestamp()).getXMLDateTime();
//pageBase.setDefaultParameter("RedemptionDateTime", defaultRedemptionDateTime);

String accessPointId = JvUtils.getCookieValue(request, "SNP-Redemption-AptId");
StationBean sb = SrvBO_Cache_Station.instance().findStationById(accessPointId);
String defaultLocationId = (sb != null) ? sb.locationId : pageBase.getSession().getLocationId();
String defaultOpAreaId = (sb != null) ? sb.opAreaId : pageBase.getSession().getOpAreaId();
String defaultAccessPointId = (sb != null) ? sb.workstationId : null;

int defaultUsageType = JvString.strToIntDef(JvUtils.getCookieValue(request, "SNP-Redemption-UsageType"), 1);

String[] transactionSurveyIDs = pageBase.getBL(BLBO_Survey.class).getShopCartSurvey(LkSNTransactionType.ManualRedemption).tranSurveyIDs;
String[] maskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(transactionSurveyIDs);
boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
%>

<v:dialog id="manual_redemption_dialog" title="@Lookup.TransactionType.ManualRedemption" width="800" height="600" autofocus="false">

  <style>
    #manual_redemption_dialog .validate-result-table {
      width: 100%;
    }
    
    #manual_redemption_dialog .icon-column {
      width: 32px;
      padding-left: 6px;
    }
    
    #manual_redemption_dialog .result-icon {
      font-size: 2.1em;
    }
    
    #manual_redemption_dialog .result-flash-icon {
      color: orange;
    }
    
  </style>

  <div class="wizard">    
    <div class="wizard-step wizard-step-params">
      <div class="wizard-step-title"><v:itl key="@ManualRedemption.Parameters"/></div>
      <div class="wizard-step-content">
        <v:widget>
          <v:widget-block>
            <v:form-field caption="@Lookup.EntityType.Location">
              <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" entityId="<%=defaultLocationId%>" auditLocationFilter="true"/>
            </v:form-field>
            <v:form-field caption="@Lookup.EntityType.OperatingArea">
              <snp:dyncombo id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" entityId="<%=defaultOpAreaId%>" auditLocationFilter="true" parentComboId="LocationId"/>
            </v:form-field>
            <v:form-field caption="@Lookup.EntityType.AccessPoint">
              <snp:dyncombo id="AccessPointId" entityType="<%=LkSNEntityType.AccessPoint%>" entityId="<%=defaultAccessPointId%>" auditLocationFilter="true" parentComboId="OpAreaId"/>
            </v:form-field>
           </v:widget-block>
          <v:widget-block>
            <v:form-field hint="@ManualRedemption.RedemptionDateHint" caption="@Common.DateTime" checkBoxField="CustomRedemptionDate">
              <v:input-text type="datetimepicker" field="RedemptionDateTime" style="width:200px"/>
            </v:form-field>
          </v:widget-block>
          <% if (rights.PermittedOverrides.getArray().length > 0)  {%>
          <v:widget-block>
            <v:form-field caption="@Entitlement.Overrides" hint="@Entitlement.ManualRedemptionOvewrridesHint">
              <v:lk-multibox field="OverrideTypes" lookup="<%=LkSN.OverrideType%>" limitItems="<%=rights.PermittedOverrides.getLkArray()%>" enabled="true"/>
            </v:form-field>          
          </v:widget-block>
          <% } %>
          <v:widget-block>
            <v:form-field caption="@Ticket.UsageType">
              <label class="checkbox-label"><input type="radio" id="usage-type" name="usage-type" value="<%=LkSNTicketUsageType.Entry.getCode()%>" checked="checked"/> <v:itl key="@Lookup.TicketUsageType.Entry"/></label>
              &nbsp;&nbsp;&nbsp;           
              <label class="checkbox-label"><input type="radio" id="usage-type" name="usage-type" value="<%=LkSNTicketUsageType.Exit.getCode()%>"/> <v:itl key="@Lookup.TicketUsageType.Exit"/></label>  
              <% if (pageBase.getRights().VGSSupport.getBoolean()) {%>
              &nbsp;&nbsp;&nbsp;           
              <label class="checkbox-label"><input type="radio" id="usage-type" name="usage-type" value="<%=LkSNTicketUsageType.ProductRedeem.getCode()%>"/> <v:itl key="@Lookup.TicketUsageType.ProductRedeem"/></label><br/>
              <%}%>
            </v:form-field>
            <v:form-field id="product-selection" caption="@Product.ProductType">
                <snp:dyncombo id="ProductId" entityType="<%=LkSNEntityType.ProductType%>"/>
            </v:form-field>
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

    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@ManualRedemption.Result"/></div>
      <div class="wizard-step-content">             
        <v:widget caption="@ManualRedemption.ValidateResult">
          <v:widget-block>
            <table class="validate-result-table">
              <tr>
                <td><v:itl key="@ManualRedemption.OperatorMessage"/></td>
                <td><span id="operator-msg" class="recap-value"></td>
                <td rowspan="2" id="result-handicap-col" class="icon-column"><span id="result-handicap-icon" class="fa fas fa-wheelchair result-icon"/></td>
                <td rowspan="2" id="result-flash-col" class="icon-column"><span id="result-flash-icon" class="fa fas fa-lightbulb-on result-icon result-flash-icon"/></td>
                <td rowspan="2" class="icon-column"><img id="result-code-icon"  width="32" height="32" > </td>
              </tr>
              <tr>
                <td><v:itl key="@ManualRedemption.CustomerMessage"/></td>
                <td><span id="customer-msg" class="recap-value"></span></td>
              </tr>
              <tr id="result-special-msg-row">
                <td><v:itl key="@ManualRedemption.SpecialMessage"/></td>
                <td><span id="special-msg" class="recap-value"></span></td>
              </tr>
              <tr id="result-rotations-row">
                <td><v:itl key="@ManualRedemption.RotationsAllowed"/></td>
                <td><span id="rotations-allowed" class="recap-value"></span></td>
              </tr>
            </table>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Ticket.Ticket">
          <v:widget-block>
            <div class="recap-value-item">
              <v:itl key="@Ticket.Ticket"/>
              <span class="recap-value">
                <a id="ticket-link" class="recap-value"/>
              </span>
            </div>
            <div class="recap-value-item">
              <v:itl key="@Product.ProductType"/>
              <span id="product-code" class="recap-value"></span>
            </div>
            <div class="recap-value-item">
              <v:itl key="@Performance.Performance"/>
              <span class="recap-value">
                <a id="event-link"/>&nbsp;&raquo;&nbsp;<a id="performance-link"/>
              </span>
            </div>
          </v:widget-block>
        </v:widget> 
        
        <v:widget caption="@Sale.Transaction">
          <v:widget-block>
            <div class="recap-value-item">
              <v:itl key="@Sale.PNR"/>
              <span class="recap-value">
                <a id="sale-link" class="recap-value"></a>
              </span>
            </div>
            <div class="recap-value-item">
              <v:itl key="@Sale.Transaction"/>
              <span class="recap-value">
                <a id="transaction-link" class="recap-value"></a>
              </span>
            </div>
          </v:widget-block>
        </v:widget> 
          
      </div>
    </div>
    
  </div>

<script>
//# sourceURL=manual_redemption_dialog.jsp

$(document).ready(function() {
  var $dlg = $("#manual_redemption_dialog");
  var $wizard = $dlg.find(".wizard");
  var $stepSurvey = $wizard.find(".wizard-step-survey");
  var $stepParams = $wizard.find(".wizard-step-params");
  var mediaCode = <%=JvString.jsString(mediaCode)%>;
  var ticketId = <%=JvString.jsString(ticketId)%>;
  var maskIDs = <%=JvString.jsString(JvArray.arrayToString(maskIDs, ","))%>;
  var metaDataList = [];
  
  $dlg.on("snapp-dialog", function(event, params) {
    params.open = _enableDisable;
    params.buttons = [
      dialogButton("@Common.Back", _previousStep, "btn-back"),
      dialogButton("@Common.Continue", _nextStep, "btn-continue"),
      dialogButton("@Common.Confirm", _confirm, "btn-confirm"),
      dialogButton("@Common.Close", doCloseDialog)
    ]; 
  });
  
  $("#product-selection").addClass("hidden");

  var $radios = $dlg.find("[name='usage-type']");
  $radios.filter('[value=<%=defaultUsageType%>]').prop('checked', true);
  $("#product-selection").setClass("hidden", <%=defaultUsageType%> != <%=LkSNTicketUsageType.ProductRedeem.getCode()%>);
  
  $dlg.find("[name='usage-type']").click(function() {
    var val = $dlg.find("[name='usage-type']:checked").val();
    $("#product-selection").setClass("hidden", val != "<%=LkSNTicketUsageType.ProductRedeem.getCode()%>");
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
  
  function _enableDisable() {
    var confirm = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 2);
    var lastStep = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") -1);
    var firstStep = ($wizard.vWizard("activeIndex") == 0);
    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-continue").setClass("hidden", confirm || lastStep);
    $buttonPane.find("#btn-confirm").setClass("hidden", !confirm || lastStep);
    $buttonPane.find("#btn-back").setClass("hidden", firstStep || lastStep);
  }
  
  function _nextStep() {
    if ($stepParams.is(".active")) {
      setCookie("SNP-Redemption-AptId", $("#AccessPointId").val(), 30);
      setCookie("SNP-Redemption-UsageType", $("input[name='usage-type']:checked").val(), 30);
    }

    if ($stepSurvey.is(".active")) {
      _validateMetaData(function() {
        $wizard.vWizard("next");
      });
    }
    else
      $wizard.vWizard("next");
  }
  
  function _previousStep() {
    $wizard.vWizard("prior");
  }

  
  function _confirm() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "ManualTicketRedemption",
        ManualTicketRedemption: _prepareManualTicketRedemptionCommand()
      };

      showWaitGlass();
      vgsService("Admission", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.TicketUsage.getCode()%>);
        _renderResult(ansDO.Answer.ManualTicketRedemption);
        hideWaitGlass();
        $wizard.vWizard("next");
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
  
  function _prepareManualTicketRedemptionCommand() {
    var noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
    var overrideTypes = $("[name='OverrideTypes']").val().join(",");   
    var reqDO = {
      MediaCode: mediaCode,
      Ticket: {TicketId: ticketId},
      AccessPointId: $("#AccessPointId").val(),
      RedemptionDateTime: $dlg.find('input[name ="CustomRedemptionDate"]').isChecked() ? $("#RedemptionDateTime-picker").getXMLDateTime() : null,
      OverrideTypes: overrideTypes,
      UsageType: $("input[name='usage-type']:checked").val(),
      IncProduct: {ProductId: $("#ProductId").val()},
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
  
  function _renderResult(ans) {    
	  if (ans.ValidateAnswer.UsageIconName != null) {
		  $("#result-code-icon").attr("src", getIconURL(ans.ValidateAnswer.UsageIconName, 32, null));
		  $("#result-code-icon").attr("title", ans.ValidateAnswer.UsageTypeDesc);
	  }
	  else 
		  $("#result-code-icon").hide();
		  
    $("#result-code").text(ans.ValidateAnswer.ResultCode);
    $("#operator-msg").text(ans.ValidateAnswer.OperatorMsg);
    $("#customer-msg").text(ans.ValidateAnswer.CustomerMsg);
    
    $("#special-msg").text(ans.ValidateAnswer.SpecialMsg);
    if (!ans.ValidateAnswer.SpecialMsg)
      $("#result-special-msg-row").addClass("hidden");
    
    if (!ans.ValidateAnswer.Flash)
      $("#result-flash-col").addClass("hidden");
    if (!ans.ValidateAnswer.PeopleOfDetermination)
      $("#result-handicap-col").addClass("hidden");

    $("#rotations-allowed").text(ans.ValidateAnswer.RotationsAllowed);
    if (ans.ValidateAnswer.RotationsAllowed <= 1)
      $("#result-rotations-row").addClass("hidden");
    
    if (ans.ValidateAnswer.Ticket != null) {
      $("#product-code").text(ans.ValidateAnswer.Ticket.ProductName + " [" + ans.ValidateAnswer.Ticket.ProductCode + "]");    
      $("#product-name").text(ans.ValidateAnswer.Ticket.ProductName);
  	  $("#ticket-link").text(ans.ValidateAnswer.Ticket.TicketCode);
  	  $("#ticket-link").attr("href", getPageURL(<%=LkSNEntityType.Ticket.getCode()%>, ans.ValidateAnswer.Ticket.TicketId));
    }
    if (ans.ValidateAnswer.Performance != null) {
      $("#event-link").text(ans.ValidateAnswer.Performance.EventName);    
      $("#event-link").attr("href", getPageURL(<%=LkSNEntityType.Event.getCode()%>, ans.ValidateAnswer.Performance.EventId));
      $("#performance-link").text(formatDate(ans.ValidateAnswer.Performance.DateTimeFrom, <%=rights.ShortDateFormat.getInt()%>) + " " + formatTime(ans.ValidateAnswer.Performance.DateTimeFrom, <%=rights.ShortTimeFormat.getInt()%>));    
      $("#performance-link").attr("href", getPageURL(<%=LkSNEntityType.Performance.getCode()%>, ans.ValidateAnswer.Performance.PerformanceId));
    }
    if (ans.TransactionRecap != null) {
      $("#sale-link").text(ans.TransactionRecap.SaleCode);    
      $("#sale-link").attr("href", getPageURL(<%=LkSNEntityType.Sale.getCode()%>, ans.TransactionRecap.SaleId));
      $("#transaction-link").text(ans.TransactionRecap.TransactionCode);    
      $("#transaction-link").attr("href", getPageURL(<%=LkSNEntityType.Transaction.getCode()%>, ans.TransactionRecap.TransactionId));
    }
  }

});

</script>

</v:dialog>


