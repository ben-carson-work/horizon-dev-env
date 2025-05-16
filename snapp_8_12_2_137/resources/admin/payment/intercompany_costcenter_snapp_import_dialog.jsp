<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="costcenter-snapp-import-dialog" title="Import cost centers" width="800" height="490" autofocus="false">
  <div id="step-upload">
    <v:widget caption="File upload">
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/> 
      </v:widget-block>
    </v:widget>
  
    <v:alert-box type="info" title="@Common.Info" style="max-height:350px;overflow:auto">
      This wizard will import cost centers from a SnApp file into the system, the following operations for linked entities are supported:<br/><br/>
      Create
      <ul>
        <li><b>Doc template</b></li>
      </ul>
    </v:alert-box>
  </div>
  
  <div id="step-preview" class="v-hidden">
    <jsp:include page="../snapp_import_geninfo_widget.jsp"/>

    <v:widget caption="@Common.Parameters">
      <v:widget-block>
        <v:db-checkbox field="UpdateExistingCostCenters" caption="Update existing cost centers" value="true"/><br/><br/>
        <v:db-checkbox field="UpdateLinkedEntities" caption="Create or update linked entities if different" value="true"/><br/><br/>
      </v:widget-block> 
    </v:widget>
  </div>
  
  <jsp:include page="../snapp_import_invalidimport_widget.jsp"/>
  
<script>

var repositoryId = null;

$(document).ready(function() {
  var $dlg = $("#costcenter-snapp-import-dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": <v:itl key="@Common.Ok" encode="JS"/>,
        "id": "button-ok",
        "class": "v-hidden",
        "click": doImportCostCenters
      },
      {
        "text": <v:itl key="@Common.Cancel" encode="JS"/>,
        "click": doCloseDialog
      }
    ];
  });
  
  $("#costcenter-snapp-import-dialog").find("[name='UpdateExistingCostCenters']").prop('checked', true);
  
});

function getImportParams() {
  return {
    CostCenter: {
      UpdateExistingCostCenters: $("#costcenter-snapp-import-dialog [name='UpdateExistingCostCenters']").isChecked(),
      UpdateLinkedEntities: $("#costcenter-snapp-import-dialog [name='UpdateLinkedEntities']").isChecked()
    }
  }
}

function doUploadFinish(obj) {
  resizeDialogWidth("#costcenter-snapp-import-dialog", 800);
  repositoryId = obj.RepositoryId;   
  var reqDO = {
    Command: "SnAppImportPreview",
    SnAppImportPreview: {
      RepositoryId: repositoryId
    } 
  };

  vgsService("AsyncProcess", reqDO, false, function(ansDO) {
    var validImport = ansDO.Answer.SnAppImportPreview.ImportTypeCode == <%=LkSNExportType.CostCenter.getCode()%>;     
      
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
      $('text[name=ImportTypeExpected]').append(<%=JvString.jsString(LkSNExportType.CostCenter.getHtmlDescription(pageBase.getLang()))%> + "<br/>"); 
      $('text[name=ImportTypeFound]').append(ansDO.Answer.SnAppImportPreview.ImportType + "<br/>"); 
      $("#invalid-import-type").removeClass("hidden");
    }
    
  });
}

function doImportCostCenters() {
  var reqDO = {
      Command: "SnAppImport",
      SnAppImport: {
        RepositoryId: repositoryId,
        AsyncProcessClassAlias: <%=JvString.jsString(AsyncProcessUtils.CLASS_ALIAS_IMPORT_SNP_COSTCENTER)%>, 
        Params: functionExists("getImportParams") ? getImportParams() : null
      } 
  };
    
  vgsService("AsyncProcess", reqDO, false, function(ansDO) {
    showAsyncProcessDialog(ansDO.Answer.SnAppImport.AsyncProcessId, function() {
      triggerEntityChange(<%=LkSNEntityType.IntercompanyCostCenter.getCode()%>);    
    });
    $("#costcenter-snapp-import-dialog").dialog("close");
  });
}


</script>

</v:dialog>
