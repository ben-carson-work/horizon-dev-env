<%@page import="com.vgs.cl.JvUtils"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="upload-dialog" title="@Upload.FileUpload" width="500" autofocus="false">
  <div id="step-input">
    <jsp:include page="file_upload_widget.jsp"/>
    <div style="margin-top:10px">
      <v:form-field caption="@Common.Code">
        <input type="text" name="RepositoryCode" class="form-control" maxlength="15"/>
      </v:form-field>
      <v:form-field caption="@Common.Description">
        <input type="text" name="RepositoryDescription" class="form-control" maxlength="50"/>
      </v:form-field>
      <v:form-field caption="@Common.ValidFrom">
        <v:input-text type="datepicker" field="RepositoryValidDateFrom" placeholder="@Common.Unlimited"/>
      </v:form-field>
      <v:form-field caption="@Common.ValidTo">
        <v:input-text type="datepicker" field="RepositoryValidDateTo" placeholder="@Common.Unlimited"/>
      </v:form-field>
    </div>
  </div>
  <div id="step-title" class="v-hidden"><v:itl key="@Upload.UploadingFile"/>...</div>
  <div id="step-process" class="spinner32-bg v-hidden" style="height:100px"></div>
</v:dialog>

<script>

$(document).ready(function() {
  var $dlg = $("#upload-dialog");
  $dlg.dialog({
    modal: true,
    buttons: {
      <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
    }
  });

  $('#RepositoryValidDateFrom-picker').change(_checkDates);
  $('#RepositoryValidDateTo-picker').change(_checkDates);
});

function _checkDates() {
  var $validFromDate = $('#RepositoryValidDateFrom-picker').datepicker('getDate');
  var $validToDate = $('#RepositoryValidDateTo-picker').datepicker('getDate');
  var validDateRange = false
  
  if (!$validFromDate || !$validToDate)
    validDateRange = true;
  
  if (validDateRange == false)
    validDateRange = ($validToDate >= $validFromDate) ? true : false;
  
  if (validDateRange == false) {
    showIconMessage("warning", itl("@Common.InvalidDateRangeError"));
    $('#RepositoryValidDateTo-picker').val('');
  }
}
  
function doUploadFinish(obj) {
  var $dlg = $("#upload-dialog");
  $("#step-input").addClass("v-hidden");
  $("#step-title").removeClass("v-hidden");
  $("#step-process").removeClass("v-hidden");
  
  var reqDO = {
    EntityType: <%=pageBase.getEmptyParameter("EntityType")%>,
    EntityId: '<%=pageBase.getEmptyParameter("EntityId")%>',
    FileName: obj.Origin,
    RepositoryCode: $dlg.find("[name='RepositoryCode']").val(),
    Description: $dlg.find("[name='RepositoryDescription']").val(),
    RepositoryUploadId: obj.RepositoryId,
    ValidDateFrom: $("#RepositoryValidDateFrom-picker").getXMLDate(),
    ValidDateTo: $("#RepositoryValidDateTo-picker").getXMLDate()
  };

  snpAPI.cmd("Repository", "Save", reqDO)
    .then(ansDO => {
        $("#step-process").addClass("v-hidden");
        $("#step-title").replaceWith("<strong><v:itl key="@Upload.FileUploadedOk"/></strong><br/>");
        triggerEntityChange(<%=LkSNEntityType.Repository.getCode()%>);
   });
}
</script>