<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
boolean reqImportParam = false;
if (pageBase.getNullParameter("requireImport") != null)
  reqImportParam = pageBase.findBoolParameter("requireImport");

String queryBase64 = pageBase.getNullParameter("QueryBase64");
String mediaIDs = pageBase.getEmptyParameter("mediaIDs"); 
List<LookupItem> mediaStatuses = pageBase.getBL(BLBO_Media.class).findMediaStatuses(JvArray.stringToArray(mediaIDs, ","));
LookupItem mediaStatus = (mediaStatuses.size() == 1) ? mediaStatuses.get(0) : null;

String[] transactionSurveyIDs = pageBase.getBL(BLBO_Survey.class).getShopCartSurvey(LkSNTransactionType.MediaChangeStatus).tranSurveyIDs;
String[] maskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(transactionSurveyIDs);
boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
%>

<v:dialog id="media_change_status_dialog" title="@Media.ChangeMediaStatus" width="800" height="600" autofocus="false">

  <style>
    #media_change_status_dialog .status-label {
      display: block;
    }
    
    #media_change_status_dialog .progress {
      margin-bottom: 0;
    }
  </style>

  <div class="wizard">
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Media.StatusWizard_Status"/></div>
      <div class="wizard-step-content">
        <% if ((mediaStatus == null) || !mediaStatus.isLookup(LkSNTicketStatus.Active)) { %>
          <v:widget caption="@Common.Unblock">
            <v:widget-block>
              <label class="checkbox_label status-label">
                <input type="radio" name="MediaStatus" value="<%=LkSNTicketStatus.Active.getCode()%>"/> 
                <%=LkSNTicketStatus.Active.getHtmlDescription(pageBase.getLang())%>
              </label>
            </v:widget-block>
          </v:widget>
        <% } %>
        
        <v:widget caption="@Common.Block">
          <v:widget-block>
            <% 
            List<LookupItem> blockedStatuses = LookupManager.getArray(        
                LkSNTicketStatus.MediaBlockedManually,
                LkSNTicketStatus.MediaBlockedDamaged,
                LkSNTicketStatus.MediaBlockedStolen,
                LkSNTicketStatus.MediaBlockedLost
            );
            if (mediaStatus != null)
              blockedStatuses.remove(mediaStatus);
            %>
            <% for (LookupItem item : blockedStatuses) { %>
              <label class="checkbox-label status-label">
                <input type="radio" name="MediaStatus" value="<%=item.getCode()%>"/> 
                <%=item.getHtmlDescription(pageBase.getLang())%>
              </label>
            <% } %>
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
    
    <div class="wizard-step wizard-step-importupload">
      <div class="wizard-step-title"><v:itl key="@Media.StatusWizard_ImportUpload"/></div>
      <div class="wizard-step-content">
        <v:widget>
          <v:widget-block>
            <div id="file-upload-section">
              <jsp:include page="../repository/file_upload_widget.jsp"/>
            </div>
          </v:widget-block>
          <v:widget-block>
            <v:alert-box type="info" title="@Common.Info">
              <v:itl key="@Media.ImportStatusWizard_Line1"/><br/>
              <v:itl key="@Media.ImportStatusWizard_Line2"/>
              <ul>
                <li><b>MediaCode</b> <i>(mandatory)</i>: unique media code</li>
              </ul>
            </v:alert-box>
          </v:widget-block>
        </v:widget>
      </div>
    </div>
    
    <div class="wizard-step wizard-step-importpreview">
      <div class="wizard-step-title"><v:itl key="@Media.StatusWizard_ImportPreview"/></div>
      <div class="wizard-step-content">
        <v:widget>
          <v:widget-block>
            <jsp:include page="../csv_import_widget.jsp">
              <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_MEDIA_STATUS%>"/>
              <jsp:param name="ExternalStart" value="true"/>
            </jsp:include>
          </v:widget-block>
        </v:widget>
      </div>
    </div>
    
    <div class="wizard-step wizard-step-importprocess">
      <div class="wizard-step-title"><v:itl key="@Media.StatusWizard_ImportProcess"/></div>
      <div class="wizard-step-content">
        <v:widget caption="@Common.Status">
          <v:widget-block>
            <div class="progressbar-status"><v:itl key="@Common.PleaseWait"/></div>
            <div class="progress"><div class="progress-bar progress-bar-snp-success"></div></div>
          </v:widget-block>
        </v:widget>

        <v:widget caption="@Common.Logs">
          <v:widget-block>
            <v:button id="btn-refresh" caption="@Common.Refresh" fa="sync-alt"/>
            <v:pagebox gridId="importprocess-log-grid"/>
          </v:widget-block>
        </v:widget>
        
        <% String params = "EntityId=" + JvUtils.newSqlStrUUID(); %>
        <v:async-grid id="importprocess-log-grid" jsp="log/log_grid.jsp" params="<%=params%>"></v:async-grid>
      </div>
    </div>
  </div>

<script>

$(document).ready(function() {
  var $dlg = $("#media_change_status_dialog");
  var $wizard = $dlg.find(".wizard");
  var $stepSurvey = $wizard.find(".wizard-step-survey");
  var mediaIDs = <%=JvString.jsString(mediaIDs)%>;
  var maskIDs = <%=JvString.jsString(JvArray.arrayToString(maskIDs, ","))%>;
  var metaDataList = [];
  var requireImport = <%=reqImportParam%>;
  
  window.doUploadFinish = _doUploadFinish;
  window.getImportParams = _getImportParams;

  $dlg.on("snapp-dialog", function(event, params) {
    params.open = _enableDisable;
    params.buttons = [
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
  
  if (!requireImport)
    $wizard.find(".wizard-step-importupload,.wizard-step-importpreview,.wizard-step-importprocess").remove();
  
  $wizard.vWizard({
    onStepChanged: _enableDisable
  });
  
  $dlg.find("[name='MediaStatus']").first().setChecked(true);

  
  function _enableDisable() {
    var stepUpload = $wizard.find(".wizard-step-importupload").is(".active");
    var stepPreview = $wizard.find(".wizard-step-importpreview").is(".active");
    var stepProcess = $wizard.find(".wizard-step-importprocess").is(".active");
    var last = stepPreview || ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 1);
    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-continue").setClass("hidden", last || stepUpload);
    $buttonPane.find("#btn-confirm").setClass("hidden", !last || stepProcess);
  }
  
  function _nextStep() {
    if ($stepSurvey.is(".active")) {
      _validateMetaData(function() {
        $wizard.vWizard("next");
      });
    }
    else
      $wizard.vWizard("next");
  }
  
  function _confirm() {
    confirmDialog(itl("@Media.MediaStatusChangeWarning"), function() {
      if (requireImport) {
        _nextStep();
        doStartCsvImport(_importCallback);
      }
      else {
        var reqDO = {
          Command: "ChangeMediaStatus",
          ChangeMediaStatus: _prepareChangeStatusCommand()
        };

        showWaitGlass();
        vgsService("Media", reqDO, false, function(ansDO) {
          hideWaitGlass();
          window.location.reload();
        });
      }
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
  
  function _prepareChangeStatusCommand() {
    var noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
    var reqDO = {
      MediaStatus: $dlg.find("[name='MediaStatus']:checked").val(),
      MediaList: [],
      Note: $dlg.find("#Note").val(),
      NoteType: noteType,
      QueryBase64: <%=JvString.jsString(queryBase64)%>,
      TransactionSurveyMetaDataList: metaDataList,
      TransactionMaskList: []
    };
    
    if (mediaIDs.length > 0) {
      $(mediaIDs.split(",")).each(function(index, elem) {
        reqDO.MediaList.push({"MediaId":elem});
      });
    }
    
    if (maskIDs.length > 0) {
      $(maskIDs.split(",")).each(function(index, elem) {
        reqDO.TransactionMaskList.push({"MaskId":elem});
      });
    }
    
    return reqDO;
  }
  
  function _importCallback(proc) {
    console.log(proc);
    
    var sSkip = "";
    if (proc.QuantitySkip != 0) 
      sSkip = " - skipped " + proc.QuantitySkip;
    
    var $stepProcess = $dlg.find(".wizard-step-importprocess");
    $stepProcess.find(".progressbar-status").text(proc.PercComplete + "% completed (" + proc.QuantityPos + " / " + proc.QuantityTot + sSkip + ")");
    $stepProcess.find(".progress-bar").css("width", proc.PercComplete+"%");

    setGridUrlParam("#importprocess-log-grid", "EntityId", proc.AsyncProcessId, true);
  }

  function _doUploadFinish(obj) {
    _nextStep();
    doCsvImport(obj.RepositoryId);
  }

  function _getImportParams() {
    return {
      MediaBlock: _prepareChangeStatusCommand()
    }
  }
});

</script>

</v:dialog>


