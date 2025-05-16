<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="extpackage_upload_dialog" title="@Upload.FileUpload" width="500" autofocus="false">
  <div id="step-input">
    <jsp:include page="../repository/file_upload_widget.jsp"/>
  </div>
  <div id="step-title" class="v-hidden"><v:itl key="@Upload.UploadingFile"/>...</div>
  <div id="step-process" class="spinner32-bg v-hidden" style="height:100px"></div>
</v:dialog>

<script>

$(document).ready(function() {
  var $dlg = $("#extpackage_upload_dialog");
  $dlg.dialog({
    modal: true,
    buttons: [
      {
        text: itl("@Common.Close"),
        click: doCloseDialog
      }
    ]
  });
});

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-title").removeClass("v-hidden");
  $("#step-process").removeClass("v-hidden");
  
  var reqDO = {
    Command: "UploadExtensionPackage",
    UploadExtensionPackage: {
      RepositoryId: obj.RepositoryId
    }
  };
  
  vgsService("Plugin", reqDO, false, function(ansDO) {
    $("#step-process").addClass("v-hidden");
    $("#step-title").replaceWith("<strong><v:itl key="@Upload.FileUploadedOk"/></strong><br/>");
    triggerEntityChange(<%=LkSNEntityType.ExtensionPackage.getCode()%>);
  });
}

</script>