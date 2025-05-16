<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="paymentmethod-snapp-import-dialog" title="Import payment methods" width="800" height="490" autofocus="false">
  <div id="step-upload">
    <v:widget caption="File upload">
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/> 
      </v:widget-block>
    </v:widget>
  
    <v:alert-box type="info" title="@Common.Info" style="max-height:350px;overflow:auto">
      This wizard will import payment methods from a SnApp file into the system, the following operations for linked entities are supported:<br/><br/>
      Create
      <ul>
        <li><b>Payment groups</b></li>
        <li><b>Ledger rules</b></li>
      </ul>
    </v:alert-box>
  </div>
  
  <div id="step-preview" class="v-hidden">
    <jsp:include page="../snapp_import_geninfo_widget.jsp"/> 
    
    <v:widget caption="@Common.Parameters">
      <v:widget-block>
        <v:db-checkbox field="UpdateExistingPaymentMethods" caption="Update existing payment methods" value="true"/><br/><br/>
        <v:db-checkbox field="UpdateLinkedEntities" caption="Create or update linked entities if different" value="true"/><br/><br/>
      </v:widget-block> 
    </v:widget>
    
    <v:alert-box type="warning" clazz="update-linked-entities-warning hidden" title="IMPORTANT">
      <i><b>IMPORTANT: Updating linked entities can result in modifying other payment methods behavior.</b></i>
    </v:alert-box>
  </div>
  
  <jsp:include page="../snapp_import_invalidimport_widget.jsp"/> 

<script>

var repositoryId = null;

$(document).ready(function() {
  var $dlg = $("#paymentmethod-snapp-import-dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": <v:itl key="@Common.Ok" encode="JS"/>,
        "id": "button-ok",
        "class": "v-hidden",
        "click": doImportPaymentMethods
      },
      {
        "text": <v:itl key="@Common.Cancel" encode="JS"/>,
        "click": doCloseDialog
      }
    ];
  });
  
  $("#paymentmethod-snapp-import-dialog").find("[name='UpdateExistingPaymentMethods']").prop('checked', true);
  $("#paymentmethod-snapp-import-dialog").find("[name='UpdateLinkedEntities']").prop('checked', false);
  $("#paymentmethod-snapp-import-dialog").find("[name='UpdateLinkedEntities']").change(refreshWarning);
});

function refreshWarning() {
  var $warnDiv = $("#paymentmethod-snapp-import-dialog").find(".update-linked-entities-warning");
  $warnDiv.setClass("hidden", !$("#paymentmethod-snapp-import-dialog").find("[name='UpdateLinkedEntities']").isChecked());
}

function getImportParams() {
  return {
    PaymentMethod: {
    	UpdateExistingPaymentMethods: $("#paymentmethod-snapp-import-dialog [name='UpdateExistingPaymentMethods']").isChecked(),
      UpdateLinkedEntities: $("#paymentmethod-snapp-import-dialog [name='UpdateLinkedEntities']").isChecked()
    }
  }
}

function doUploadFinish(obj) {
  resizeDialogWidth("#paymentmethod-snapp-import-dialog", 800);
  repositoryId = obj.RepositoryId;   
  var reqDO = {
    Command: "SnAppImportPreview",
    SnAppImportPreview: {
      RepositoryId: repositoryId
    } 
  };

  vgsService("AsyncProcess", reqDO, false, function(ansDO) {
    var validImport = ansDO.Answer.SnAppImportPreview.ImportTypeCode == <%=LkSNExportType.PaymentMethod.getCode()%>;     
      
    $("#step-upload").addClass("v-hidden");
    
    if (validImport) {
      $('text[name=ImportType]').append(ansDO.Answer.SnAppImportPreview.ImportType + "<br/>"); 
      $('text[name=ItemCount]').append(ansDO.Answer.SnAppImportPreview.Descriptor.ItemCount + "<br/>");
      $('text[name=LicenseName]').append(ansDO.Answer.SnAppImportPreview.Descriptor.LicenseName);
      $('text[name=URL]').append(ansDO.Answer.SnAppImportPreview.Descriptor.URL);
      $('text[name=SnAppBkoVersion]').append(ansDO.Answer.SnAppImportPreview.Descriptor.SnAppBkoVersion);
      $('text[name=WorkstationName]').append(ansDO.Answer.SnAppImportPreview.Descriptor.WorkstationName);
      $('text[name=UserAccountName]').append(ansDO.Answer.SnAppImportPreview.Descriptor.UserAccountName);
      $('text[name=ExportDateTime]').append(formatDate(xmlToDate(ansDO.Answer.SnAppImportPreview.Descriptor.ExportDateTime), <%=pageBase.getRights().ShortDateFormat.getInt()%>) + " - " + formatTime(xmlToDate(ansDO.Answer.SnAppImportPreview.Descriptor.ExportDateTime), <%=pageBase.getRights().ShortTimeFormat.getInt()%>));
        
      $("#step-preview").removeClass("v-hidden");
      $("#button-ok").removeClass("v-hidden");
    }
    else {
      $('text[name=ImportTypeExpected]').append(<%=JvString.jsString(LkSNExportType.PaymentMethod.getHtmlDescription(pageBase.getLang()))%> + "<br/>"); 
      $('text[name=ImportTypeFound]').append(ansDO.Answer.SnAppImportPreview.ImportType + "<br/>"); 
      $("#invalid-import-type").removeClass("hidden");
    }
    
  });
}

function doImportPaymentMethods() {
  var reqDO = {
      Command: "SnAppImport",
      SnAppImport: {
        RepositoryId: repositoryId,
        AsyncProcessClassAlias: <%=JvString.jsString(AsyncProcessUtils.CLASS_ALIAS_IMPORT_SNP_PAYMENTMETHOD)%>, 
        Params: functionExists("getImportParams") ? getImportParams() : null
      } 
  };
    
  vgsService("AsyncProcess", reqDO, false, function(ansDO) {
    showAsyncProcessDialog(ansDO.Answer.SnAppImport.AsyncProcessId, function() {
      triggerEntityChange(<%=LkSNEntityType.PaymentMethod.getCode()%>);    
    });
    $("#paymentmethod-snapp-import-dialog").dialog("close");
  });
}


</script>

</v:dialog>
