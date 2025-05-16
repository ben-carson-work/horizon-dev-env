<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
LookupItem entityType = LkSN.EntityType.getItemByCode(JvString.strToIntDef(pageBase.getNullParameter("EntityType"), 0));

%>

<v:dialog id="category-snapp-import-dialog" title="Import categories" width="800" height="490" autofocus="false">
  <div id="step-upload">
    <v:widget caption="File upload">
      <v:widget-block>
        <jsp:include page="repository/file_upload_widget.jsp"/> 
      </v:widget-block>
    </v:widget>
  
    <v:alert-box type="info" title="@Common.Info" style="max-height:350px;overflow:auto">
      This wizard will import categories from a SnApp file into the system, the following operations for linked entities are supported:<br/><br/>
      Create
      <ul>
        <li><b>Tags</b></li>
      </ul>
    </v:alert-box>
  </div>
  
  <div id="step-preview" class="v-hidden">
    <jsp:include page="snapp_import_geninfo_widget.jsp"/>
    <v:widget caption="@Common.Parameters">
      <v:widget-block>
        <v:db-checkbox field="UpdateExistingCategories" caption="Update existing categories" value="true"/><br/><br/>
        <v:db-checkbox field="UpdateLinkedEntities" caption="Create or update linked entities if different" value="true"/><br/><br/>
        <v:alert-box type="warning" clazz="update-linked-entities-warning hidden" title="IMPORTANT">
          <i><b>IMPORTANT: Updating linked entities can result in modifying other entities behavior.</b></i>
        </v:alert-box>
        <v:db-checkbox field="DeleteMissing" caption="Remove obsolete categories from destination" hint="If a specific category is not present in the import file, will be removed from the destination system" value="true"/><br/><br/>
        <v:alert-box type="warning" clazz="remove-obsolete-categories-warning hidden" title="IMPORTANT">
          <i><b>IMPORTANT: Obsolete categories linked to any entity will not be deleted but moved under "#OBSOLETE" category node.</b></i>
        </v:alert-box>        
      </v:widget-block> 
    </v:widget>
  </div>
  
  <jsp:include page="snapp_import_invalidimport_widget.jsp"/>
  
<script>

var repositoryId = null;

$(document).ready(function() {
  var $dlg = $("#category-snapp-import-dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": <v:itl key="@Common.Ok" encode="JS"/>,
        "id": "button-ok",
        "class": "v-hidden",
        "click": doImportCategories
      },
      {
        "text": <v:itl key="@Common.Cancel" encode="JS"/>,
        "click": doCloseDialog
      }
    ];
  });
  $("#category-snapp-import-dialog").find("[name='UpdateExistingCategories']").prop('checked', false);
  $("#category-snapp-import-dialog").find("[name='UpdateLinkedEntities']").prop('checked', false);
  $("#category-snapp-import-dialog").find("[name='DeleteMissing']").prop('checked', false);
  $("#category-snapp-import-dialog").find("[name='UpdateLinkedEntities']").change(refreshWarning);
  $("#category-snapp-import-dialog").find("[name='DeleteMissing']").change(refreshWarning);
});

function refreshWarning() {
  var $warnDivUpd = $("#category-snapp-import-dialog").find(".update-linked-entities-warning");
  $warnDivUpd.setClass("hidden", !$("#category-snapp-import-dialog").find("[name='UpdateLinkedEntities']").isChecked());
  
  var $warnDivDel = $("#category-snapp-import-dialog").find(".remove-obsolete-categories-warning");
  $warnDivDel.setClass("hidden", !$("#category-snapp-import-dialog").find("[name='DeleteMissing']").isChecked());
}

function getImportParams() {
  return {
    Category: {
    	UpdateExistingCategories: $("#category-snapp-import-dialog [name='UpdateExistingCategories']").isChecked(),
    	UpdateLinkedEntities: $("#category-snapp-import-dialog [name='UpdateLinkedEntities']").isChecked(),
    	DeleteMissing: $("#category-snapp-import-dialog [name='DeleteMissing']").isChecked()
    }
  }
}

function doUploadFinish(obj) {
  resizeDialogWidth("#category-snapp-import-dialog", 800);
  repositoryId = obj.RepositoryId;   
  var reqDO = {
    Command: "SnAppImportPreview",
    SnAppImportPreview: {
      RepositoryId: repositoryId
    } 
  };

  vgsService("AsyncProcess", reqDO, false, function(ansDO) {
	  var validImport = (ansDO.Answer.SnAppImportPreview.ImportTypeCode == <%=LkSNExportType.Category.getCode()%>) && (ansDO.Answer.SnAppImportPreview.ImportSubtypeCode == <%=entityType.getCode()%>) ;     
	    
    $("#step-upload").addClass("v-hidden");
    
    if (validImport) {
      $('text[name=ImportType]').append(ansDO.Answer.SnAppImportPreview.ImportType + " - " + ansDO.Answer.SnAppImportPreview.ImportSubtype + "<br/>"); 
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
      $('text[name=ImportTypeExpected]').append(<%=JvString.jsString(LkSNExportType.Category.getHtmlDescription(pageBase.getLang()))%> + " - " + <%=JvString.jsString(entityType.getHtmlDescription(pageBase.getLang()))%> + "<br/>"); 
      $('text[name=ImportTypeFound]').append(ansDO.Answer.SnAppImportPreview.ImportType + " - " + ansDO.Answer.SnAppImportPreview.ImportSubtype + "<br/>"); 
      $("#invalid-import-type").removeClass("hidden");
    }
    
  });
}

function doImportCategories() {
  var reqDO = {
      Command: "SnAppImport",
      SnAppImport: {
        RepositoryId: repositoryId,
        AsyncProcessClassAlias: <%=JvString.jsString(AsyncProcessUtils.CLASS_ALIAS_IMPORT_SNP_CATEGORY)%>, 
        Params: functionExists("getImportParams") ? getImportParams() : null
      } 
  };
    
  vgsService("AsyncProcess", reqDO, false, function(ansDO) {
    showAsyncProcessDialog(ansDO.Answer.SnAppImport.AsyncProcessId, function() {
    	window.location =BASE_URL + "/admin?page=category_list&EntityType=" + <%=entityType.getCode()%> 
    });
    $("#category-snapp-import-dialog").dialog("close");
  });
}


</script>

</v:dialog>
