<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAction" scope="request"/>
<jsp:useBean id="action" class="com.vgs.snapp.dataobject.DOAction" scope="request"/>
<jsp:useBean id="email" class="com.vgs.snapp.dataobject.DODocTemplateEmail" scope="request"/>

<script type="text/javascript" src="<v:config key="site_url"/>/libraries/ckeditor/ckeditor.js"></script>
<style>

#email-header {
}

#email-header .form-field {
  min-height: 24px;
  line-height: inherit;
}

#email-header .form-field-value {
  font-weight: bold;
}

#email-content .readonly {
  padding: 40px;
  overflow: hidden;
}

</style>

<% 
  boolean isDraft = action.ActionStatus.isLookup(LkSNActionStatus.Draft);
  boolean allowModifyAddress = pageBase.getRights().OverrideEmailAddress.getBoolean();
  boolean readonly = !isDraft;
%>

<v:tab-toolbar>
  <v:button caption="@Common.Save" fa="save" onclick="saveAction()" enabled="<%=!readonly%>"/>
  <v:button id="send" caption="@Action.Send" fa="upload" onclick="sendEmail()" clazz="v-hidden"/>
  <v:button id="resend" caption="@Action.ReSend" fa="upload" onclick="sendEmail(true)" clazz="v-hidden"/>
  <v:button caption="@Common.Print" fa="print" onclick="printEmail()"/>
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
    <v:widget>
      <v:widget-block>
        <v:recap-item caption="@Common.Status" valueColor="<%=((LkSNActionStatus.ActionStatusItem)action.ActionStatus.getLkValue()).getColor()%>"><%=action.ActionStatus.getHtmlLookupDesc(pageBase.getLang())%></v:recap-item>
      </v:widget-block>
    </v:widget>
  
    <jsp:include page="action_link_widget.jsp"></jsp:include>

    <v:grid include="<%=!email.AttachmentList.isEmpty()%>">
      <thead>
        <v:grid-title caption="@Common.Attachments"/>
      </thead>
      <tbody>
      <% for (DODocTemplateEmail.DOAttachment attachment : email.AttachmentList) { %>
        <tr class="grid-row">
          <td>
            <div class="list-title"><%=attachment.FileName.getHtmlString()%></div>
            <div class="list-subtitle"><%=attachment.ContentType.getHtmlString()%></div>
          </td>
          <td align="right" nowrap>
            <% long size = attachment.Content.isNull() ? 0 : attachment.Content.getBytes().length; %>
            <%=JvString.escapeHtml(JvString.getSmoothSize(size))%>
          </td>
        </tr>
      <% } %>
      </tbody>
    </v:grid>
  </v:profile-recap>
  
  <v:profile-main>
    <v:widget>
      <v:widget-block id="email-header">
        <v:form-field caption="@Common.DateTime">
          <% FtTimestamp field = action.CloseDateTime.isNull() ? action.CreateDateTime : action.CloseDateTime; %>
          <snp:datetime timezone="local" timestamp="<%=field%>" format="longdatetime"/>
        </v:form-field>
        <v:form-field caption="@DocTemplate.Email_From">
          <v:input-text field="email.AddressFrom" enabled="<%=!readonly%>"/>
        </v:form-field>
        <v:form-field caption="@DocTemplate.Email_To">
          <v:input-text field="email.AddressTo" enabled="<%=!readonly%>"/>
        </v:form-field>
        <% if (!email.AddressCC.isNull()) { %>
          <v:form-field caption="@DocTemplate.Email_CC">
            <v:input-text field="email.AddressCC" enabled="<%=!readonly%>"/>
          </v:form-field>
        <% } %>
        <v:form-field caption="@DocTemplate.Email_Subject">
          <v:input-text field="email.Subject" enabled="<%=!readonly%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block id="email-content">
        <% if (readonly) { %>
          <div class="readonly">
            <%=email.Body.getEmptyString()%>
          </div>
	    <% } else { %>
	      <textarea id="editor1" name="email.Body"><%=email.Body.getString()%></textarea>
	      <script type="text/javascript">CKEDITOR.replace("editor1", {toolbar:"Full"});</script>
	  	<% } %>
      </v:widget-block>
    </v:widget>
  </v:profile-main>
</v:tab-content>

<script>

$(document).ready(function() {
  contentChanged = false;
  
  $("#send").setClass("v-hidden", <%=!isDraft%>);
  $("#resend").setClass("v-hidden", <%=isDraft%>);
  
  CKEDITOR.instances.editor1.on('change', function() { 
    contentChanged = true;
    console.log("changed...");
  });
  
});

function showContentChangedDialog(callback) {
  confirmDialog(itl("@Common.DiscardChangesConfirm"), function() {
    contentChanged = false;
    callback();
  });
}

function sendEmail(resend) {
  if (resend) {
    inputDialog(itl("@Action.ReSend"), null, null, <%=email.AddressTo.getJsString()%>, <%=!allowModifyAddress%>, function(addressTo) {
      var reqDO = {
          Command: "SendEmailAction",
          SendEmailAction: {
            ActionId: <%=JvString.jsString(pageBase.getId())%>,
            AddressTo: addressTo,
            AddressFrom: $("#email\\.AddressFrom").val(),
            AddressCC: $("#email\\.AddressCC").val(),
            Subject: $("#email\\.Subject").val(),
            Body: <%=JvString.jsString(email.Body.getString())%>
          }
       };
       
       vgsService("Action", reqDO, false, function(ansDO) {
         triggerEntityChange(<%=LkSNEntityType.Email.getCode()%>);
         window.location.reload();
       });
   });
 }
 else {
   if (contentChanged)
     showContentChangedDialog(sendEmail);
   else {
     var reqDO = {
         Command: "SendEmailAction",
         SendEmailAction: {
           ActionId: <%=JvString.jsString(pageBase.getId())%>,
           AddressTo: $("#email\\.AddressTo").val(),
           AddressFrom: $("#email\\.AddressFrom").val(),
           AddressCC: $("#email\\.AddressCC").val(),
           Subject: $("#email\\.Subject").val(),
           Body: <%=JvString.jsString(email.Body.getString())%>
         }
       };
       
       vgsService("Action", reqDO, false, function(ansDO) {
         triggerEntityChange(<%=LkSNEntityType.Email.getCode()%>);
         window.location.reload();
       });
   }
 }
}

function printEmail() {
  if (contentChanged)
    showContentChangedDialog(printEmail);
  else {
    var contentToPrint = "";
    var printWindow = window.open("");
    
    if (<%=isDraft%>) {
      contentToPrint = document.getElementById("editor1");
      printWindow.document.write(contentToPrint.innerText);
    }
    else {
      contentToPrint = document.getElementById("email-content");
      printWindow.document.write(contentToPrint.outerHTML);
    }
    
    setTimeout(
       function() {
         printWindow.print();
         printWindow.close();
       }, 100);
  }
}

function saveAction() {
  contentChanged = false;
  sendPost("#email-form", "action.email-save");
}

</script>