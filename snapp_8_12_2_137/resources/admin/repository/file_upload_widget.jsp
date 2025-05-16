<%@page import="com.vgs.cl.JvUtils"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% String asyncProcessId = JvUtils.newSqlStrUUID(); %>

<div id="upload-file">
  <iframe name="upload-file-frame" class="v-hidden"></iframe>
  <form id="upload-file-form" method="post" enctype="multipart/form-data" target="upload-file-frame" action="<v:config key="site_url"/>/FileUploadServlet?AsyncProcessId=<%=asyncProcessId%>" onsubmit="doUploadFile();">
    <div>
      <div id="upload-file-params">
	      <label class="btn btn-default">
	        <i class="fa fa-folder-open"></i>
	        <v:itl key="@Upload.SelectFile"/>
	        <input type="file" class="hidden"  name="upload-file-select" id="upload-file-select" onchange="validate(this)">
	      </label>
      </div>  
      <div id="step-upload-progress" class="v-hidden">
        <div class="progress-block">
          <div id="progressbar-title"><v:itl key="@Upload.UploadingFile"/>...</div>
          <b><span class='status'></span></b>
          <br/>
          <div id="upload-progress-bar" class="progress">
		    <div class="progress-bar" role="progressbar"></div>
          </div>
        </div>
      </div>
    </div>
  </form>
</div>

<script>
  var divProgress = $(".progress-block");
  var pbar = divProgress.find("#upload-progress-bar");
  var uploadCompleted = false;

  function doGetProcess() {
    if (!uploadCompleted) {
      var reqDO = {
        Command: "GetProcess",
        GetProcess: {
          AsyncProcessId: '<%=asyncProcessId%>'
        }
      };
      
      vgsService("AsyncProcess", reqDO, false, function(ansDO) {       
        divProgress.find(".status").html(ansDO.Answer.GetProcess.PercComplete + "% completed (uploaded: " + getSmoothSize(ansDO.Answer.GetProcess.QuantityPos) + " - " + "total: " + getSmoothSize(ansDO.Answer.GetProcess.QuantityTot) + ")");
        
        if ((ansDO.Answer.GetProcess.AsyncProcessStatus != <%=LkSNAsyncProcessStatus.Finished.getCode()%>) && 
            (ansDO.Answer.GetProcess.AsyncProcessStatus != <%=LkSNAsyncProcessStatus.Aborted.getCode()%>)) {
            pbar.find(".progress-bar").css("width", ansDO.Answer.GetProcess.PercComplete+"%");
            setTimeout(doGetProcess, 500);
          }
        else {
          divProgress.find("#progressbar-title").replaceWith("<strong><v:itl key="Upload completed."/></strong><br/>");
          pbar.addClass("hidden");
        }
      });
    }
  }
  
  function doSetComplete(obj) {
    uploadCompleted = true;
    $("#step-upload-progress").addClass("v-hidden");
    if (obj.IsUploadable == true)
    	doUploadFinish(obj);
    else 
      showMessage(itl("@Upload.UploadFailed") + obj.ErrorMessage); 
  }

  function doUploadFile() {
    $(".alert").addClass("v-hidden");
    $(".params-box").addClass("v-hidden");
    $("#upload-file-params").addClass("v-hidden");
    $("#step-error-msg").addClass("v-hidden");
    $("#step-upload-progress").removeClass("v-hidden");
    setTimeout(doGetProcess, 500);
  }
  
  function validate(ele) {
    var checkFileSizeUploadLimit = <%=rights.FileSizeUploadLimit.isDefined()%>;
    var checkBannedExtensions = <%=rights.BannedFileExtensions.isDefined()%>;
    var file = $('#upload-file-select');

    if (checkBannedExtensions) {
      var bannedExtensions = <%=rights.BannedFileExtensions.getJsString()%>;
      var filePathSplit = file.val().split(".");
      var fileExtension = filePathSplit.length > 1 ? filePathSplit[1] : "";
      
      if (fileExtension=="") {
        showMessage(itl("@Upload.UploadFailed") + " " + itl("@Upload.CannotUploadFileWithoutExtension"));
        return;
      }
      
      //Convert value and array in lowercase
      var fileExtension = fileExtension.toLowerCase();
      var bannedExtensions = bannedExtensions.map(function(ele) { return ele.toLowerCase(); });
      
      if ($.inArray(fileExtension, bannedExtensions) != -1) {
        showMessage(itl("@Upload.UploadFailed") + itl("@Upload.FileExtensionNotAllowed", "." + fileExtension));
        return;
      }
    }
    
    if (checkFileSizeUploadLimit) {
      var fileSizeUploadLimit = <%=rights.FileSizeUploadLimit.getJsString()%>;
      if (ele.files.length > 0) { 
        for (i=0; i<=ele.files.length-1; i++) { 
          var fsize_B = ele.files.item(i).size; 
          var fSize_MB = fsize_B / (1024 * 1024);
          
          if (fSize_MB > fileSizeUploadLimit) {
            showMessage(itl("@Upload.UploadFailed") + itl("@Upload.FileSizeExceeded"));
            return;
          }
        } 
      } 
    }
    
    $('#upload-file-form').submit();
    
  }
</script>