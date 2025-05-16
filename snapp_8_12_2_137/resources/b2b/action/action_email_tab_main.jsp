<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Action" scope="request"/>
<jsp:useBean id="action" class="com.vgs.snapp.dataobject.DOAction" scope="request"/>
<jsp:useBean id="email" class="com.vgs.snapp.dataobject.DODocTemplateEmail" scope="request"/>
<% boolean readonly = action.ActionStatus.isLookup(LkSNActionStatus.InProgress, LkSNActionStatus.Completed); %>

<script type="text/javascript" src="<v:config key="site_url"/>/libraries/ckeditor/ckeditor.js"></script>
<style>
  .subtools {margin-bottom:10px; padding-bottom:10px; border-bottom:1px var(--border-color) solid}
  .email-body-block {padding:10px}
  .cke_top {background:rgba(0,0,0,0.1)!important}
  .cke_toolgroup, .cke_combo_button {background:rgba(0,0,0,0.1)!important;border:none!important;overflow:hidden!important}
  .cke_button:hover, .cke_combo_button:hover {background:var(--highlight-color)!important;border:none!important}
</style>
<div class="tab-toolbar">
  <% if (!readonly) { %>
	  <div class="subtools">
	    <v:button caption="@Action.Send" clazz="hl-green" href="javascript:doSend()"/>
	    <v:button caption="@Action.SaveDraft" clazz="hl-green" href="javascript:doSave()"/>
	     <!-- <v:button caption="@Common.Delete" clazz="hl-red" href="javascript:doDelete()"/> -->
	    <span class="divider"></span>
	    <v:db-checkbox field="email.IncludeTickets" caption="@Action.IncludeTickets" value="true"/>
	  </div>
  <% } %>
  <v:form-field caption="@Common.DateTime">
    <% if (action.CloseDateTime.isNull()) { %>
      <% action.CreateDateTime.setDisplayFormat(pageBase.getShortDateTimeFormat()); %>
      <v:input-text enabled="false" field="action.CreateDateTime"/>
    <% } else { %>
      <% action.CloseDateTime.setDisplayFormat(pageBase.getShortDateTimeFormat()); %>
      <v:input-text enabled="false" field="action.CloseDateTime"/>
    <% } %>
  </v:form-field>
  <v:form-field caption="@DocTemplate.Email_From">
    <v:input-text enabled="false" field="email.AddressFrom"/>
  </v:form-field>
  <v:form-field caption="@DocTemplate.Email_To">
    <v:input-text enabled="<%=!readonly%>" field="email.AddressTo"/>
  </v:form-field>
  <% if (!email.AddressCC.isNull()) { %>
    <v:form-field caption="@DocTemplate.Email_CC">
      <v:input-text enabled="false" field="email.AddressCC"/>
    </v:form-field>
  <% } %>
  <v:form-field caption="@DocTemplate.Email_Subject">
    <v:input-text enabled="<%=!readonly%>" field="email.Subject"/>
  </v:form-field>
</div>

<div class="tab-content" style="background:var(--content-bg-color)">
  <v:page-form id="email-form">
		<div class="email-body-block">
		  <% if (readonly) { %>
		    <%=email.Body.getString()%>
		  <% } else { %>
		    <textarea id="editor1" name="email.Body"><%=email.Body.getString()%></textarea>
		    <script type="text/javascript">CKEDITOR.replace("editor1", {toolbar:"Full",height:450});</script>
		  <% } %>
		</div>
  </v:page-form>
</div>


<script>

<% action.DataEmail.clear(); %>
var action = <%=action.getJSONString()%>;

function prepareSaveRequest() {
  action = (action) ? action : {};
  action.DataEmail = (action.DataEmail) ? action.DataEmail : {}; 
  
  action.DataEmail.AddressFrom = $("#email\\.AddressFrom").val();
  action.DataEmail.AddressTo = $("#email\\.AddressTo").val();
  action.DataEmail.AddressCC = $("#email\\.AddressCC").val();
  action.DataEmail.Subject = $("#email\\.Subject").val();
  action.DataEmail.IncludeTickets = $("#email\\.IncludeTickets").isChecked()
  action.DataEmail.Body = CKEDITOR.instances.editor1.getData();

  var reqDO = {
    Command: "Save",
    Save: {
      Action: action
    }
  };
  
  return reqDO;
}

function doSave() {
  showWaitGlass();
  vgsService("Action", prepareSaveRequest(), false, function(ansDO) {
    hideWaitGlass();
    showMessage("<v:itl key="@Common.SaveSuccessMsg" encode="UTF-8"/>")
  });
}

function doSend() {
  showWaitGlass();
  vgsService("Action", prepareSaveRequest(), false, function(ansDO) {
    var reqActDO = {
      Header: {
        RequestCode: "SendEmail",
        WorkstationId: "<%=pageBase.getSession().getWorkstationId()%>",
        UserAccountId: "<%=pageBase.getSession().getUserAccountId()%>"
      },
      Request: {
        ActionId: "<%=pageBase.getId()%>"
      }
    };
    
    var reqUplDO = {
      Command: "Add",
      Add: {
        UploadType: <%=LkSNUploadType.SendEmail.getCode()%>,
        MsgRequest: JSON.stringify(reqActDO)
      }
    };
    
    vgsService("Upload", reqUplDO, false, function(ansDO) {
      var uploadId = ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Add)) ? ansDO.Answer.Add.UploadId : null;
      if (uploadId != null)
        waitForCompletion(uploadId)
      else {
        hideWaitGlass();
        showMessage(<v:itl key="@Common.GenericError" encode="JS"/>);
      }
    });
  });
}

function waitForCompletion(uploadId) {
  var reqDO = {
    Command: "Status",
    Status: {
      UploadId: uploadId
    }
  };
  
  function showCompletionMessage(msg) {
    hideWaitGlass();
    showMessage(msg, function() {
      window.location.reload();
    });
  }
  
  vgsService("Upload", reqDO, false, function(ansDO) {
    try {
      var uploadStatus = ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Status)) ? ansDO.Answer.Status.UploadStatus : null;
      if (uploadStatus == <%=LkSNUploadStatus.Success.getCode()%>) 
        showCompletionMessage("<v:itl key="@Common.SaveSuccessMsg" encode="UTF-8"/>");
      else if (uploadStatus == <%=LkSNUploadStatus.Failed.getCode()%>) 
        showCompletionMessage("<v:itl key="@Common.GenericError" encode="UTF-8"/>");
      else 
        setTimeout(function() {
          waitForCompletion(uploadId);
        }, 1000);
    }
    catch (e) {
      hideWaitGlass();
      showMessage(e.message);
    }
  });
}

function doDelete() {
  var reqDO = {
    Command: "Delete",
    Delete: {
      ActionIDs: "<%=pageBase.getId()%>"
    }
  };
  
  vgsService("Action", reqDO, false, function(ansDO) {
    showMessage("<v:itl key="@Common.SaveSuccessMsg" encode="UTF-8"/>", function() {
      window.location = "<%=request.getAttribute("BackURL")%>";
    });
  });
}

</script>

